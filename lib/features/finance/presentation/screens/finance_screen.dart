import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/finance_transaction_entity.dart';
import 'package:rejabon_ai/core/integration/action_reward_bridge.dart';
import 'package:rejabon_ai/core/integration/provider_sync.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/shared/widgets/app_bottom_sheet.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_empty_state.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_feedback.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/core/utils/format_money.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

final financeTabProvider = StateProvider<int>((ref) => 0);

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txsAsync = ref.watch(financeTransactionsProvider);
    final tab = ref.watch(financeTabProvider);

    return ModuleScreen(
      title: AppStrings.finance,
      inShell: false,
      showGlobalCapture: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTransactionDialog(context, ref, type: tab),
        child: const Icon(Icons.add_rounded),
      ),
      body: txsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(financeTransactionsProvider),
        ),
        data: (txs) {
          final balance = FinanceRepository.balance(txs);
          final income = FinanceRepository.totalIncome(txs);
          final expense = FinanceRepository.totalExpense(txs);
          final filtered = txs.where((t) => t.type == tab).toList();

          return ListView(
            padding: ContentInsets.scrollPadding(context, inShell: true),
            children: [
              FadeIn(
                child: AppCard(
                  variant: AppCardVariant.outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.balance,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.textSecondary(
                                Theme.of(context).brightness,
                              ),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        formatMoney(balance),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryItem(
                              label: AppStrings.totalIncome,
                              value: formatMoney(income),
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _SummaryItem(
                              label: AppStrings.totalExpense,
                              value: formatMoney(expense),
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text(AppStrings.income)),
                  ButtonSegment(value: 1, label: Text(AppStrings.expense)),
                ],
                selected: {tab},
                onSelectionChanged: (s) =>
                    ref.read(financeTabProvider.notifier).state = s.first,
              ),
              const SizedBox(height: AppSpacing.md),
              if (txs.isEmpty)
                AppEmptyState(
                  icon: Icons.account_balance_wallet_outlined,
                  title: AppStrings.noFinance,
                  description: AppStrings.noFinanceDesc,
                )
              else ...[
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(
                      child: Text(
                        AppStrings.noData,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...filtered.map(
                    (tx) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _TransactionTile(tx: tx),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.statistics,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 220,
                  child: _FinanceChart(
                    transactions: txs.where((t) => t.type == 1).toList(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    this.light = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: light
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppColors.textSecondary(Theme.of(context).brightness),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _TransactionTile extends ConsumerWidget {
  const _TransactionTile({required this.tx});

  final FinanceTransactionEntity tx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = tx.type == 0;
    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => confirmDelete(context),
      onDismissed: (_) async {
        await ref.read(financeRepositoryProvider).delete(tx.id);
        if (context.mounted) showDeletedSnackBar(context);
      },
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isIncome ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                color: isIncome ? AppColors.success : AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.category,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    AppDateFormat.formatDate(tx.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (tx.description != null && tx.description!.isNotEmpty)
                    Text(
                      tx.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${formatMoney(tx.amount)}',
              style: TextStyle(
                color: isIncome ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinanceChart extends StatelessWidget {
  const _FinanceChart({required this.transactions});

  final List<FinanceTransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(child: Text(AppStrings.noData));
    }

    final categoryTotals = <String, double>{};
    for (final tx in transactions) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.error,
      AppColors.success,
      const Color(0xFF74B9FF),
      const Color(0xFFA29BFE),
    ];

    return AppCard(
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: List.generate(entries.length, (i) {
            final entry = entries[i];
            final total = categoryTotals.values.fold(0.0, (s, v) => s + v);
            final percent = total > 0 ? (entry.value / total) * 100 : 0.0;
            return PieChartSectionData(
              value: entry.value,
              title: '${percent.round()}%',
              color: colors[i % colors.length],
              radius: 60,
              titleStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }),
        ),
      ),
    );
  }
}

Future<void> _showTransactionDialog(
  BuildContext context,
  WidgetRef ref, {
  required int type,
}) async {
  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final categories = type == 0
      ? financeIncomeCategories
      : financeExpenseCategories;
  var category = categories.first;
  final formKey = GlobalKey<FormState>();

  await showAppBottomSheet<void>(
    context,
    title: type == 0 ? AppStrings.newIncome : AppStrings.newExpense,
    child: StatefulBuilder(
      builder: (ctx, setDialogState) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: amountCtrl,
                label: AppStrings.amount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) =>
                    v == null || double.tryParse(v) == null
                        ? 'Summa kiriting'
                        : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration:
                    const InputDecoration(labelText: AppStrings.category),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setDialogState(() => category = v!),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: descCtrl,
                label: AppStrings.description,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: AppStrings.save,
                isExpanded: true,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  await ref.read(financeRepositoryProvider).save(
                        FinanceTransactionEntity.create(
                          type: type,
                          amount: double.parse(amountCtrl.text),
                          category: category,
                          description: descCtrl.text.trim().isEmpty
                              ? null
                              : descCtrl.text.trim(),
                        ),
                      );
                  invalidateDerivedProviders(ref);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  if (context.mounted) {
                    await rewardFinanceLog(ref, context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
  deferDispose(() {
    amountCtrl.dispose();
    descCtrl.dispose();
  });
}
