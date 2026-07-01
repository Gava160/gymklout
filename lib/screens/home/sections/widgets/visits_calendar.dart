import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/visit_stats_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gymklout/providers/visits_provider.dart';

class VisitCalendarWidget extends ConsumerStatefulWidget {
  const VisitCalendarWidget({super.key});

  @override
  ConsumerState<VisitCalendarWidget> createState() =>
      _VisitCalendarWidgetState();
}

class _VisitCalendarWidgetState extends ConsumerState<VisitCalendarWidget> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final visitsAsync = ref.watch(visitsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // Accent stays consistent across themes; surface/text adapt.
    const accent = Color(0xFF6C5CE7);
    final cardColor = isDark ? const Color(0xFF1E1E22) : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final mutedCellColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return visitsAsync.when(
      loading: () => const SizedBox(
        height: 340,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SizedBox(
        height: 340,
        child: Center(child: Text('Failed to load visits: $err')),
      ),
      data: (state) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            children: [
              _StreakStatsRow(stats: state.stats, isDark: isDark),
              const SizedBox(height: 12),
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.now().add(const Duration(days: 1)),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: (AppDefaults.textStyle(context).fontSize ??
                                    16) + 1,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, size: 20, color: primaryText),
                  rightChevronIcon: Icon(Icons.chevron_right, size: 20, color: primaryText),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: (AppDefaults.textStyle(context).fontSize ??
                                    16) -2, color: secondaryText),
                  weekendStyle: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: (AppDefaults.textStyle(context).fontSize ??
                                    16) -2, color: secondaryText),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: primaryText),
                  weekendTextStyle: TextStyle(color: primaryText),
                  outsideTextStyle: TextStyle(color: secondaryText.withOpacity(0.5)),
                  disabledTextStyle: TextStyle(color: secondaryText.withOpacity(0.3)),
                ),
                selectedDayPredicate: (_) => false,
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                  ref.read(visitsProvider.notifier).changeMonth(focusedDay);
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) {
                    if (state.isVisited(day)) {
                      return _AttendedDayCell(day: day, isDark: isDark);
                    }
                    return null;
                  },
                  todayBuilder: (context, day, _) {
                    if (state.isVisited(day)) {
                      return _AttendedDayCell(day: day, isToday: true, isDark: isDark);
                    }
                    return _TodayCell(day: day, primaryText: primaryText);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AttendedDayCell extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final bool isDark;

  const _AttendedDayCell({
    required this.day,
    required this.isDark,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF6C5CE7).withAlpha(200),
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: isDark ? Colors.white : Colors.black87, width: 1.5)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _TodayCell extends StatelessWidget {
  final DateTime day;
  final Color primaryText;

  const _TodayCell({required this.day, required this.primaryText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF6C5CE7), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text('${day.day}',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13, color: primaryText)),
    );
  }
}

class _StreakStatsRow extends StatelessWidget {
  final VisitStatsModel stats;
  final bool isDark;

  const _StreakStatsRow({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.local_fire_department,
            label: 'Daily streak',
            value: '${stats.dailyStreak}d',
            color: const Color(0xFFFF6B35),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatChip(
            icon: Icons.calendar_month,
            label: 'Monthly streak',
            value: '${stats.monthlyStreak}mo',
            color: const Color(0xFF6C5CE7),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatChip(
            icon: Icons.fitness_center,
            label: 'This month',
            value: '${stats.currentMonthVisits}',
            color: const Color(0xFF00B894),
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: (AppDefaults.textStyle(context).fontSize ??
                                    16), color: color)),
          Text(label,
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.85)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}