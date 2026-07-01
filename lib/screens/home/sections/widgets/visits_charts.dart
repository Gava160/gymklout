import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/providers/visits_provider.dart';

class VisitsBarChartWidget extends ConsumerWidget {
  const VisitsBarChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(visitsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const accent = Color(0xFF6C5CE7);
    final cardColor = isDark ? const Color(0xFF1E1E22) : Colors.white;
    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final mutedBarColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final axisLabelColor = isDark ? Colors.grey.shade500 : Colors.grey.shade500;

    return visitsAsync.when(
      loading: () => const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SizedBox(
        height: 220,
        child: Center(child: Text('Failed to load chart: $err')),
      ),
      data: (state) {
        final month = state.focusedMonth;
        final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

        final barGroups = List.generate(daysInMonth, (index) {
          final day = DateTime(month.year, month.month, index + 1);
          final visited = state.isVisited(day);

          return BarChartGroupData(
            x: index + 1,
            barRods: [
              BarChartRodData(
                toY: visited ? 1 : 0,
                width: 6,
                borderRadius: BorderRadius.circular(3),
                color: visited ? accent : mutedBarColor,
              ),
            ],
          );
        });

        return Container(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This month',
                style: TextStyle(
                  fontSize: (AppDefaults.textStyle(context).fontSize ??
                                    16),
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.stats.currentMonthVisits} day${state.stats.currentMonthVisits == 1 ? '' : 's'} attended',
                style: TextStyle(fontSize: (AppDefaults.textStyle(context).fontSize ??
                                    16) - 2, color: secondaryText),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: BarChart(
                  BarChartData(
                    maxY: 1,
                    minY: 0,
                    alignment: BarChartAlignment.spaceEvenly,
                    barGroups: barGroups,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            final day = value.toInt();
                            if (day != 1 && day % 5 != 0 && day != daysInMonth) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('$day',
                                  style: TextStyle(fontSize: 10, color: axisLabelColor)),
                            );
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final visited = rod.toY == 1;
                          return BarTooltipItem(
                            'Day ${group.x}\n${visited ? 'Attended' : 'No visit'}',
                            const TextStyle(color: Colors.white, fontSize: 11),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}