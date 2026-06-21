import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/core/database/schemas/task_entity.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/app_empty_state.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/emoji_picker_field.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

enum TaskFilter { all, active, completed }

const _taskCategories = ['Umumiy', 'Ish', 'Shaxsiy', 'Sog\'liq', 'Ta\'lim'];

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

class TasksListScreen extends ConsumerWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final filter = ref.watch(taskFilterProvider);

    return ModuleScreen(
      title: AppStrings.tasks,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/vazifalar/yangi'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addTask),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: SegmentedButton<TaskFilter>(
              segments: const [
                ButtonSegment(
                  value: TaskFilter.all,
                  label: Text(AppStrings.all),
                ),
                ButtonSegment(
                  value: TaskFilter.active,
                  label: Text(AppStrings.taskActive),
                ),
                ButtonSegment(
                  value: TaskFilter.completed,
                  label: Text(AppStrings.taskCompleted),
                ),
              ],
              selected: {filter},
              onSelectionChanged: (s) =>
                  ref.read(taskFilterProvider.notifier).state = s.first,
            ),
          ),
          Expanded(
            child: tasksAsync.when(
              loading: () => const AppLoadingState(),
              error: (e, _) => AppErrorState(
                onRetry: () => ref.invalidate(tasksProvider),
              ),
              data: (tasks) {
                final filtered = switch (filter) {
                  TaskFilter.all => tasks,
                  TaskFilter.active =>
                    tasks.where((t) => !t.isCompleted).toList(),
                  TaskFilter.completed =>
                    tasks.where((t) => t.isCompleted).toList(),
                };

                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.task_alt_outlined,
                    title: AppStrings.noTasks,
                    description: AppStrings.noTasksDesc,
                    actionLabel: AppStrings.addTask,
                    onAction: () => context.push('/vazifalar/yangi'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final task = filtered[index];
                    return _TaskListTile(task: task);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListTile extends ConsumerWidget {
  const _TaskListTile({required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(taskRepositoryProvider);

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => confirmDelete(context),
      onDismissed: (_) async {
        await repo.delete(task.id);
        if (context.mounted) showDeletedSnackBar(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: AppCard(
          onTap: () => context.push('/vazifalar/${task.id}'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: task.isCompleted,
                activeColor: AppColors.primary,
                onChanged: (_) async {
                  await repo.toggleComplete(task);
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayWithEmoji(title: task.title, emoji: task.emoji),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _Chip(
                          label: taskPriorityLabel(task.priority),
                          color: taskPriorityColor(task.priority),
                        ),
                        _Chip(label: task.category),
                        if (task.dueDate != null)
                          _Chip(
                            label: AppDateFormat.formatDate(task.dueDate!),
                            icon: Icons.calendar_today_outlined,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    context.push('/vazifalar/tahrirlash/${task.id}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.color, this.icon});

  final String label;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color ?? AppColors.primary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.taskId});

  final String? taskId;

  bool get isEditing => taskId != null;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int _priority = 1;
  String _category = _taskCategories.first;
  String _emoji = '';
  DateTime? _dueDate;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    if (widget.taskId != null) {
      final id = int.tryParse(widget.taskId!);
      if (id != null) {
        final task = await ref.read(taskRepositoryProvider).getById(id);
        if (task != null && mounted) {
          _titleCtrl.text = task.title;
          _descCtrl.text = task.description ?? '';
          _priority = task.priority;
          _category = _taskCategories.contains(task.category)
              ? task.category
              : _taskCategories.first;
          _emoji = task.emoji;
          _dueDate = task.dueDate;
        }
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(taskRepositoryProvider);
    TaskEntity task;

    if (widget.isEditing) {
      final id = int.parse(widget.taskId!);
      final existing = await repo.getById(id);
      if (existing == null) return;
      task = existing
        ..title = _titleCtrl.text.trim()
        ..emoji = _emoji
        ..description = _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim()
        ..priority = _priority
        ..category = _category
        ..dueDate = _dueDate;
    } else {
      task = TaskEntity.create(
        title: _titleCtrl.text.trim(),
        emoji: _emoji,
        description:
            _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        priority: _priority,
        category: _category,
        dueDate: _dueDate,
      );
    }

    await repo.save(task);
    if (mounted) {
      showSavedSnackBar(context);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return ModuleScreen(
        title: widget.isEditing ? AppStrings.editTask : AppStrings.newTask,
        showBackButton: true,
        body: const AppLoadingState(),
      );
    }

    return ModuleScreen(
      title: widget.isEditing ? AppStrings.editTask : AppStrings.newTask,
      showBackButton: true,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              controller: _titleCtrl,
              label: AppStrings.taskTitle,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Sarlavha kerak' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            EmojiPickerField(
              selected: _emoji,
              onSelected: (e) => setState(() => _emoji = e),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _descCtrl,
              label: AppStrings.taskDescription,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.taskPriority,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text(AppStrings.priorityLow)),
                ButtonSegment(value: 1, label: Text(AppStrings.priorityMedium)),
                ButtonSegment(value: 2, label: Text(AppStrings.priorityHigh)),
              ],
              selected: {_priority},
              onSelectionChanged: (s) => setState(() => _priority = s.first),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: AppStrings.taskCategory),
              items: _taskCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              readOnly: true,
              label: AppStrings.taskDueDate,
              controller: TextEditingController(
                text: _dueDate != null
                    ? AppDateFormat.formatDate(_dueDate!)
                    : '',
              ),
              hint: 'Tanlang',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: _pickDueDate,
              ),
              onTap: _pickDueDate,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: AppStrings.save,
              isExpanded: true,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(taskId);
    final tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      loading: () => const ModuleScreen(
        title: AppStrings.tasks,
        showBackButton: true,
        body: AppLoadingState(),
      ),
      error: (e, _) => ModuleScreen(
        title: AppStrings.tasks,
        showBackButton: true,
        body: AppErrorState(
          onRetry: () => ref.invalidate(tasksProvider),
        ),
      ),
      data: (tasks) {
        final matches = tasks.where((t) => t.id == id);
        final task = matches.isEmpty ? null : matches.first;

        if (task == null) {
          return const ModuleScreen(
            title: AppStrings.tasks,
            showBackButton: true,
            body: AppEmptyStateDefault(),
          );
        }

        return ModuleScreen(
          title: task.title,
          showBackButton: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('/vazifalar/tahrirlash/${task.id}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                if (!await confirmDelete(context)) return;
                await ref.read(taskRepositoryProvider).delete(task.id);
                if (context.mounted) {
                  showDeletedSnackBar(context);
                  context.pop();
                }
              },
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) => ref
                              .read(taskRepositoryProvider)
                              .toggleComplete(task),
                        ),
                        Expanded(
                          child: Text(
                            task.isCompleted
                                ? AppStrings.taskCompleted
                                : AppStrings.taskActive,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(task.description!),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: AppStrings.taskPriority,
                      value: taskPriorityLabel(task.priority),
                    ),
                    _DetailRow(
                      label: AppStrings.taskCategory,
                      value: task.category,
                    ),
                    if (task.dueDate != null)
                      _DetailRow(
                        label: AppStrings.taskDueDate,
                        value: AppDateFormat.formatDate(task.dueDate!),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: AppStrings.edit,
                variant: AppButtonVariant.secondary,
                isExpanded: true,
                icon: Icons.edit_outlined,
                onPressed: () =>
                    context.push('/vazifalar/tahrirlash/${task.id}'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.labelLarge),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
