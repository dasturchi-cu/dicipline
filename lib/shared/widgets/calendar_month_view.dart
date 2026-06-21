import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/database/schemas/calendar_event_entity.dart';
import 'app_card.dart';

/// Oy ko'rinishidagi kalendar — tadbirli kunlarni belgilaydi.
class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    super.key,
    required this.events,
    required this.selectedDate,
    required this.onDateSelected,
    this.planDays = const {},
  });

  final List<CalendarEventEntity> events;
  final Set<DateTime> planDays;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  Set<DateTime> get _eventDays {
    return widget.events
        .map((e) => AppDateFormat.dateOnly(e.startTime))
        .toSet();
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;
    final monthLabel = AppDateFormat.formatMonthYear(_focusedMonth);

    return AppCard(
      variant: AppCardVariant.elevated,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () => _changeMonth(-1),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday) {
                return const SizedBox.shrink();
              }

              final day = index - startWeekday + 1;
              final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
              final normalized = AppDateFormat.dateOnly(date);
              final isSelected = AppDateFormat.isSameDay(date, widget.selectedDate);
              final isToday = AppDateFormat.isToday(date);
              final hasEvents = _eventDays.contains(normalized);
              final hasPlan = widget.planDays.contains(normalized);

              return GestureDetector(
                onTap: () => widget.onDateSelected(normalized),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppColors.primary
                                  : null,
                          fontWeight: isToday || isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      if (hasEvents || hasPlan)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (hasEvents)
                              Container(
                                width: 5,
                                height: 5,
                                margin: const EdgeInsets.only(top: 2, right: 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (hasPlan)
                              Container(
                                width: 5,
                                height: 5,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white70
                                      : AppColors.warning,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
