import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/content_insets.dart';
import 'package:rejabon_ai/features/life_os/presentation/providers/life_os_providers.dart';
import 'package:rejabon_ai/features/retention/presentation/providers/retention_providers.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

class SecondBrainScreen extends ConsumerStatefulWidget {
  const SecondBrainScreen({super.key});

  @override
  ConsumerState<SecondBrainScreen> createState() => _SecondBrainScreenState();
}

class _SecondBrainScreenState extends ConsumerState<SecondBrainScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  final _qaCtrl = TextEditingController();
  String _qaQuestion = '';
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _qaCtrl.dispose();
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScreen(
      title: AppStrings.secondBrain,
      showBackButton: true,
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            tabs: [
              Tab(text: AppStrings.search),
              Tab(text: AppStrings.brainQa),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _SearchTab(searchCtrl: _searchCtrl),
                _QaTab(
                  qaCtrl: _qaCtrl,
                  question: _qaQuestion,
                  onAsk: (q) => setState(() => _qaQuestion = q),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTab extends ConsumerWidget {
  const _SearchTab({required this.searchCtrl});

  final TextEditingController searchCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(brainSearchResultsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              hintText: AppStrings.brainSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
            onChanged: (v) =>
                ref.read(brainSearchQueryProvider.notifier).state = v,
          ),
        ),
        Expanded(
          child: resultsAsync.when(
            loading: () => const AppLoadingState(),
            error: (_, __) => const AppErrorState(),
            data: (results) {
              if (searchCtrl.text.trim().isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.brainSearchEmpty,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (results.isEmpty) {
                return Center(child: Text(AppStrings.noData));
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  ContentInsets.shellScrollBottom(context),
                ),
                itemCount: results.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = results[index];
                  return AppCard(
                    onTap: () => context.push(item.route),
                    child: Row(
                      children: [
                        Text(item.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              Text(item.subtitle, maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        if (item.isFavorite)
                          const Icon(Icons.star_rounded,
                              color: AppColors.gold, size: 18),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QaTab extends ConsumerWidget {
  const _QaTab({
    required this.qaCtrl,
    required this.question,
    required this.onAsk,
  });

  final TextEditingController qaCtrl;
  final String question;
  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answer = question.trim().isEmpty
        ? null
        : ref.watch(brainQaProvider(question.trim()));

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        ContentInsets.shellScrollBottom(context),
      ),
      children: [
        TextField(
          controller: qaCtrl,
          decoration: InputDecoration(
            hintText: AppStrings.brainQaHint,
            prefixIcon: const Icon(Icons.question_answer_rounded),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () => onAsk(qaCtrl.text.trim()),
            ),
          ),
          onSubmitted: onAsk,
        ),
        const SizedBox(height: AppSpacing.md),
        if (answer == null)
          Text(
            AppStrings.brainQaEmpty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        else
          FadeIn(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    answer.question,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    answer.answer,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
