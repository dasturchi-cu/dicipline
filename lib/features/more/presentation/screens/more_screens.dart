import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:rejabon_ai/core/ai/ai_status.dart';
import 'package:rejabon_ai/core/constants/app_strings.dart';
import 'package:rejabon_ai/core/database/schemas/calendar_event_entity.dart';
import 'package:rejabon_ai/core/database/schemas/document_entity.dart';
import 'package:rejabon_ai/core/database/schemas/note_entity.dart';
import 'package:rejabon_ai/core/database/schemas/plan_entity.dart';
import 'package:rejabon_ai/core/providers/core_providers.dart';
import 'package:rejabon_ai/core/providers/repository_providers.dart';
import 'package:rejabon_ai/core/theme/app_colors.dart';
import 'package:rejabon_ai/core/integration/provider_sync.dart';
import 'package:rejabon_ai/core/notifications/calendar_notification_helper.dart';
import 'package:rejabon_ai/core/utils/display_with_emoji.dart';
import 'package:rejabon_ai/core/utils/date_format.dart';
import 'package:rejabon_ai/features/ai_coach/presentation/providers/ai_coach_provider.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/ai_status_provider.dart';
import 'package:rejabon_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:rejabon_ai/features/settings/presentation/widgets/ai_status_card.dart';
import 'package:rejabon_ai/shared/widgets/app_button.dart';
import 'package:rejabon_ai/shared/widgets/achievement_celebration.dart';
import 'package:rejabon_ai/shared/widgets/app_card.dart';
import 'package:rejabon_ai/shared/widgets/calendar_month_view.dart';
import 'package:rejabon_ai/shared/widgets/app_empty_state.dart';
import 'package:rejabon_ai/shared/widgets/app_error_state.dart';
import 'package:rejabon_ai/shared/widgets/app_feedback.dart';
import 'package:rejabon_ai/shared/widgets/app_loading_state.dart';
import 'package:rejabon_ai/shared/widgets/app_text_field.dart';
import 'package:rejabon_ai/shared/widgets/emoji_picker_field.dart';
import 'package:rejabon_ai/shared/widgets/fade_in.dart';
import 'package:rejabon_ai/shared/widgets/glass_panel.dart';
import 'package:rejabon_ai/shared/widgets/hub_module_card.dart';
import 'package:rejabon_ai/shared/widgets/module_screen.dart';

export 'package:rejabon_ai/features/more/presentation/widgets/more_hub_screen.dart';

final noteSearchProvider = StateProvider<String>((ref) => '');

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final query = ref.watch(noteSearchProvider).toLowerCase();

    return ModuleScreen(
      title: AppStrings.notes,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppTextField(
              hint: AppStrings.search,
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (v) =>
                  ref.read(noteSearchProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: notesAsync.when(
              loading: () => const AppLoadingState(),
              error: (e, _) => AppErrorState(
                onRetry: () => ref.invalidate(notesProvider),
              ),
              data: (notes) {
                final filtered = query.isEmpty
                    ? notes
                    : notes.where((n) {
                        return n.title.toLowerCase().contains(query) ||
                            n.content.toLowerCase().contains(query);
                      }).toList();

                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.sticky_note_2_outlined,
                    title: AppStrings.noNotes,
                    description: AppStrings.noNotesDesc,
                    actionLabel: AppStrings.newNote,
                    onAction: () => _showNoteDialog(context, ref),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final note = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        onTap: () => _showNoteDialog(context, ref, note: note),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    displayWithEmoji(
                                      title: note.title,
                                      emoji: note.emoji,
                                    ),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    if (!await confirmDelete(context)) return;
                                    await ref
                                        .read(noteRepositoryProvider)
                                        .delete(note.id);
                                    if (context.mounted) {
                                      showDeletedSnackBar(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Text(
                              note.content,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (note.tags.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Wrap(
                                spacing: AppSpacing.xs,
                                children: note.tags
                                    .map(
                                      (t) => Chip(
                                        label: Text(t, style: const TextStyle(fontSize: 11)),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showNoteDialog(
    BuildContext context,
    WidgetRef ref, {
    NoteEntity? note,
  }) async {
    final titleCtrl = TextEditingController(text: note?.title ?? '');
    final contentCtrl = TextEditingController(text: note?.content ?? '');
    final tagsCtrl = TextEditingController(text: note?.tags.join(', ') ?? '');
    var emoji = note?.emoji ?? '';
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
        title: Text(note == null ? AppStrings.newNote : AppStrings.editNote),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: titleCtrl,
                  label: AppStrings.noteTitle,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Sarlavha kerak' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                EmojiPickerField(
                  selected: emoji,
                  onSelected: (e) => setDialogState(() => emoji = e),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: contentCtrl,
                  label: AppStrings.noteContent,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: tagsCtrl,
                  label: AppStrings.noteTags,
                  hint: 'ish, shaxsiy',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final tags = tagsCtrl.text
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();
              final repo = ref.read(noteRepositoryProvider);
              if (note != null) {
                note
                  ..title = titleCtrl.text.trim()
                  ..emoji = emoji
                  ..content = contentCtrl.text.trim()
                  ..tags = tags;
                await repo.save(note);
              } else {
                await repo.save(
                  NoteEntity.create(
                    title: titleCtrl.text.trim(),
                    emoji: emoji,
                    content: contentCtrl.text.trim(),
                    tags: tags,
                  ),
                );
              }
              if (context.mounted) {
                showSavedSnackBar(context);
                Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
        ),
      ),
    );
    titleCtrl.dispose();
    contentCtrl.dispose();
    tagsCtrl.dispose();
  }
}

// -- Calendar ---------------------------------------------------------------

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDate = AppDateFormat.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(calendarEventsProvider);
    final plansAsync = ref.watch(plansProvider);
    final planAsync = ref.watch(planForDateProvider(_selectedDate));

    return ModuleScreen(
      title: AppStrings.calendar,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: eventsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(calendarEventsProvider),
        ),
        data: (events) {
          final plans = plansAsync.valueOrNull ?? [];
          final planDays = plans
              .where((plan) => plan.items.isNotEmpty)
              .map((plan) => AppDateFormat.dateOnly(plan.planDate))
              .toSet();
          final dayEvents = events
              .where((e) => AppDateFormat.isSameDay(e.startTime, _selectedDate))
              .toList();
          final dayPlan = planAsync.valueOrNull;
          final planItems = dayPlan == null
              ? <PlanItemEmbedded>[]
              : (List<PlanItemEmbedded>.from(dayPlan.items)
                ..sort((a, b) => a.startTime.compareTo(b.startTime)));

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              CalendarMonthView(
                events: events,
                planDays: planDays,
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppDateFormat.formatDate(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (planItems.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppStrings.dayPlan,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/reja'),
                      child: const Text(AppStrings.aiPlanning),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ...planItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: () => context.push('/reja'),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 48,
                            decoration: BoxDecoration(
                              color: item.isCompleted
                                  ? AppColors.success
                                  : item.isMissed
                                      ? AppColors.error
                                      : AppColors.warning,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.emoji} ${item.title}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${AppDateFormat.formatTime(item.startTime)} — ${AppDateFormat.formatTime(item.endTime)}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              if (dayEvents.isEmpty)
                AppEmptyState(
                  icon: Icons.event_outlined,
                  title: AppStrings.noEvents,
                  description: AppStrings.noEventsDesc,
                  actionLabel: AppStrings.newEvent,
                  onAction: () => _showEventDialog(context, ref),
                )
              else
                ...dayEvents.map(
                  (event) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      onTap: () => _showEventDialog(context, ref, event: event),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${AppDateFormat.formatDateTime(event.startTime)} — ${AppDateFormat.formatTime(event.endTime)}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                                if (event.hasReminder)
                                  Row(
                                    children: [
                                      const Icon(Icons.notifications_outlined,
                                          size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${event.reminderMinutes} daq oldin',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              if (!await confirmDelete(context)) return;
                              await ref
                                  .read(calendarNotificationHelperProvider)
                                  .cancelEventReminder(event.id);
                              await ref
                                  .read(calendarRepositoryProvider)
                                  .delete(event.id);
                              if (context.mounted) showDeletedSnackBar(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showEventDialog(
    BuildContext context,
    WidgetRef ref, {
    CalendarEventEntity? event,
  }) async {
    final titleCtrl = TextEditingController(text: event?.title ?? '');
    final descCtrl = TextEditingController(text: event?.description ?? '');
    var start = event?.startTime ?? DateTime.now();
    var end = event?.endTime ?? DateTime.now().add(const Duration(hours: 1));
    var hasReminder = event?.hasReminder ?? false;
    var reminderMinutes = event?.reminderMinutes ?? 15;
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            event == null ? AppStrings.newEvent : AppStrings.editEvent,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: titleCtrl,
                    label: AppStrings.eventTitle,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Nom kerak' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: descCtrl,
                    label: AppStrings.description,
                    maxLines: 2,
                  ),
                  ListTile(
                    title: const Text(AppStrings.startTime),
                    subtitle: Text(AppDateFormat.formatDateTime(start)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: start,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (date == null) return;
                      if (!ctx.mounted) return;
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(start),
                      );
                      if (time != null) {
                        setDialogState(() {
                          start = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          if (end.isBefore(start)) {
                            end = start.add(const Duration(hours: 1));
                          }
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: const Text(AppStrings.endTime),
                    subtitle: Text(AppDateFormat.formatDateTime(end)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: end,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (date == null) return;
                      if (!ctx.mounted) return;
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: TimeOfDay.fromDateTime(end),
                      );
                      if (time != null) {
                        setDialogState(() {
                          end = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                  ),
                  SwitchListTile(
                    title: const Text(AppStrings.reminder),
                    value: hasReminder,
                    onChanged: (v) => setDialogState(() => hasReminder = v),
                  ),
                  if (hasReminder)
                    DropdownButtonFormField<int>(
                      initialValue: reminderMinutes,
                      decoration: const InputDecoration(
                        labelText: 'Eslatma vaqti',
                      ),
                      items: const [
                        DropdownMenuItem(value: 5, child: Text('5 daqiqa')),
                        DropdownMenuItem(value: 15, child: Text('15 daqiqa')),
                        DropdownMenuItem(value: 30, child: Text('30 daqiqa')),
                        DropdownMenuItem(value: 60, child: Text('1 soat')),
                      ],
                      onChanged: (v) =>
                          setDialogState(() => reminderMinutes = v!),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final repo = ref.read(calendarRepositoryProvider);
                final notifications = ref.read(calendarNotificationHelperProvider);
                final notificationsEnabled =
                    ref.read(settingsProvider).notificationEnabled;
                CalendarEventEntity saved;
                if (event != null) {
                  event
                    ..title = titleCtrl.text.trim()
                    ..description = descCtrl.text.trim().isEmpty
                        ? null
                        : descCtrl.text.trim()
                    ..startTime = start
                    ..endTime = end
                    ..hasReminder = hasReminder
                    ..reminderMinutes = reminderMinutes;
                  saved = await repo.save(event);
                } else {
                  saved = await repo.save(
                    CalendarEventEntity.create(
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      startTime: start,
                      endTime: end,
                      hasReminder: hasReminder,
                      reminderMinutes: reminderMinutes,
                    ),
                  );
                }
                await notifications.syncEventReminder(
                  event: saved,
                  notificationsEnabled: notificationsEnabled,
                );
                if (context.mounted) {
                  showSavedSnackBar(context);
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
    titleCtrl.dispose();
    descCtrl.dispose();
  }
}

// -- Documents --------------------------------------------------------------

const _documentTypes = [
  'Pasport',
  'ID karta',
  'Guvohnoma',
  'Shartnoma',
  'Boshqa',
];

final documentSearchProvider = StateProvider<String>((ref) => '');

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentsProvider);
    final query = ref.watch(documentSearchProvider).toLowerCase();

    return ModuleScreen(
      title: AppStrings.documents,
      showBackButton: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDocumentDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppTextField(
              hint: AppStrings.search,
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (v) =>
                  ref.read(documentSearchProvider.notifier).state = v,
            ),
          ),
          Expanded(
            child: docsAsync.when(
              loading: () => const AppLoadingState(),
              error: (e, _) => AppErrorState(
                onRetry: () => ref.invalidate(documentsProvider),
              ),
              data: (docs) {
                final filtered = query.isEmpty
                    ? docs
                    : docs.where((doc) {
                        return doc.title.toLowerCase().contains(query) ||
                            (doc.description?.toLowerCase().contains(query) ??
                                false) ||
                            doc.type.toLowerCase().contains(query);
                      }).toList();

                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.folder_outlined,
                    title: AppStrings.noDocuments,
                    description: AppStrings.noDocumentsDesc,
                    actionLabel: AppStrings.newDocument,
                    onAction: () => _showDocumentDialog(context, ref),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: () => _showDocumentDialog(context, ref, doc: doc),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${doc.type} · ${AppDateFormat.formatDate(doc.createdAt)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (doc.description != null)
                              Text(
                                doc.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          if (!await confirmDelete(context)) return;
                          await ref
                              .read(documentRepositoryProvider)
                              .delete(doc.id);
                          if (context.mounted) showDeletedSnackBar(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDocumentDialog(
    BuildContext context,
    WidgetRef ref, {
    DocumentEntity? doc,
  }) async {
    final titleCtrl = TextEditingController(text: doc?.title ?? '');
    final descCtrl = TextEditingController(text: doc?.description ?? '');
    var type = doc?.type ?? _documentTypes.first;
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            doc == null ? AppStrings.newDocument : AppStrings.edit,
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: titleCtrl,
                  label: AppStrings.documentTitle,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nom kerak' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration:
                      const InputDecoration(labelText: AppStrings.documentType),
                  items: _documentTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => type = v!),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: descCtrl,
                  label: AppStrings.description,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final repo = ref.read(documentRepositoryProvider);
                if (doc != null) {
                  doc
                    ..title = titleCtrl.text.trim()
                    ..description = descCtrl.text.trim().isEmpty
                        ? null
                        : descCtrl.text.trim()
                    ..type = type;
                  await repo.save(doc);
                } else {
                  await repo.save(
                    DocumentEntity.create(
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      type: type,
                    ),
                  );
                }
                if (context.mounted) {
                  showSavedSnackBar(context);
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
    titleCtrl.dispose();
    descCtrl.dispose();
  }
}

// -- AI Coach ---------------------------------------------------------------

class AiCoachScreen extends ConsumerWidget {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsAsync = ref.watch(aiTipsProvider);

    return ModuleScreen(
      title: AppStrings.aiCoach,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: AppStrings.refreshTips,
          onPressed: () => ref.invalidate(aiTipsProvider),
        ),
      ],
      body: tipsAsync.when(
        loading: () => const AppLoadingState(),
        error: (e, _) => AppErrorState(
          onRetry: () => ref.invalidate(aiTipsProvider),
        ),
        data: (tips) {
          if (tips.isEmpty) {
            return const AppEmptyState(
              icon: Icons.psychology_outlined,
              title: AppStrings.noTips,
              description: AppStrings.noTipsDesc,
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              FadeIn(
                child: AppCard(
                  variant: AppCardVariant.gradient,
                  gradientColors: AppColors.heroGradientLight,
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.psychology_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.aiCoach,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              '${tips.length} ${AppStrings.dailyRecommendations.toLowerCase()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _AiCoachStatusBanner(status: ref.watch(aiStatusProvider)),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(label: AppStrings.dailyRecommendations),
              const SizedBox(height: AppSpacing.sm),
              ...tips.asMap().entries.map(
                (entry) => FadeIn(
                  index: entry.key,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GlassPanel(
                      onTap: entry.value.actionRoute != null
                          ? () => context.push(entry.value.actionRoute!)
                          : null,
                      opacity: 0.88,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: const Icon(
                              Icons.lightbulb_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.value.title,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(entry.value.description),
                                if (entry.value.actionRoute != null) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    AppStrings.goToAction,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AiCoachStatusBanner extends StatelessWidget {
  const _AiCoachStatusBanner({required this.status});

  final AiStatusInfo status;

  @override
  Widget build(BuildContext context) {
    if (status.connectionState == AiConnectionState.notConfigured) {
      return AppCard(
        variant: AppCardVariant.filled,
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.lightTextSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AppStrings.aiRuleBasedFallback,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    final color = switch (status.connectionState) {
      AiConnectionState.active => AppColors.success,
      AiConnectionState.error => AppColors.error,
      AiConnectionState.notConfigured => AppColors.lightTextSecondary,
    };

    return AppCard(
      variant: AppCardVariant.filled,
      child: Row(
        children: [
          Icon(Icons.psychology_outlined, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${status.statusLabel} · '
              '${status.currentProvider?.name ?? '-'} · '
              '${status.currentModel ?? '-'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

// -- Settings ---------------------------------------------------------------

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nameCtrl = TextEditingController();
  bool _nameInitialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveUserName() async {
    await ref.read(settingsProvider.notifier).setUserName(_nameCtrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.saved)),
    );
  }

  Future<void> _exportBackup() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final backup = await ref.read(backupServiceProvider.future);
      final json = await backup.exportToJson();
      await Share.share(json, subject: '${AppStrings.appName} zaxira');
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.backupSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('${AppStrings.errorGeneric}: $e')),
      );
    }
  }
  Future<void> _importBackup() async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.restore),
        content: const Text(AppStrings.restoreWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) return;

    try {
      final backup = await ref.read(backupServiceProvider.future);
      final content = await File(path).readAsString();
      await backup.restoreFromJson(content);
      invalidateAllDataProviders(ref);
      resetAchievementCelebrations();
      await syncAllNotifications(ref);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.restoreSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('${AppStrings.errorGeneric}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(settingsProvider);

    if (!_nameInitialized) {
      _nameCtrl.text = appSettings.userName;
      _nameInitialized = true;
    }

    return ModuleScreen(
      title: AppStrings.settings,
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            AppStrings.preferences,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.userName,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: _nameCtrl,
                  hint: 'Ismingiz',
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: AppStrings.save,
                  size: AppButtonSize.sm,
                  onPressed: _saveUserName,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.theme,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(AppStrings.themeLight),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(AppStrings.themeDark),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(AppStrings.themeSystem),
                      icon: Icon(Icons.settings_suggest_outlined),
                    ),
                  ],
                  selected: {appSettings.themeMode},
                  onSelectionChanged: (s) => ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(AppStrings.notifications),
              value: appSettings.notificationEnabled,
              onChanged: (enabled) async {
                final messenger = ScaffoldMessenger.of(context);
                if (enabled) {
                  final granted = await ref
                      .read(notificationServiceProvider)
                      .requestPermissions();
                  if (!granted && mounted) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Bildirishnoma ruxsati berilmadi. Sozlamalardan yoqing.',
                        ),
                      ),
                    );
                    return;
                  }
                }

                await ref
                    .read(settingsProvider.notifier)
                    .setNotificationEnabled(enabled);

                if (enabled) {
                  await syncAllNotifications(ref);
                } else {
                  await ref.read(notificationServiceProvider).cancelAll();
                }

                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text(AppStrings.saved)),
                );
              },
            ),
          ),
          if (appSettings.notificationEnabled) ...[
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.notificationLeadTime,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<int>(
                    value: appSettings.notificationLeadMinutes,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text(AppStrings.leadExact)),
                      DropdownMenuItem(value: 5, child: Text(AppStrings.lead5min)),
                      DropdownMenuItem(value: 10, child: Text(AppStrings.lead10min)),
                      DropdownMenuItem(value: 15, child: Text(AppStrings.lead15min)),
                      DropdownMenuItem(value: 30, child: Text(AppStrings.lead30min)),
                      DropdownMenuItem(value: 60, child: Text(AppStrings.lead60min)),
                    ],
                    onChanged: (value) async {
                      if (value == null) return;
                      await ref
                          .read(settingsProvider.notifier)
                          .setNotificationLeadMinutes(value);
                      await syncAllNotifications(ref);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppStrings.saved)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.aiStatus,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          const AiStatusCard(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.backup,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppStrings.exportBackup,
            icon: Icons.upload_rounded,
            isExpanded: true,
            variant: AppButtonVariant.secondary,
            onPressed: _exportBackup,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: AppStrings.importBackup,
            icon: Icons.download_rounded,
            isExpanded: true,
            variant: AppButtonVariant.secondary,
            onPressed: _importBackup,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.about,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(AppStrings.appTagline),
                const SizedBox(height: AppSpacing.sm),
                Text('${AppStrings.version}: 1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
