import 'package:gymklout/models/visit_stats_model.dart';
import 'package:gymklout/services/visits_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitsState {
  final List<DateTime> visitedDates;
  final VisitStatsModel stats;
  final DateTime focusedMonth;

  const VisitsState({
    required this.visitedDates,
    required this.stats,
    required this.focusedMonth,
  });

  bool isVisited(DateTime day) {
    return visitedDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  VisitsState copyWith({
    List<DateTime>? visitedDates,
    VisitStatsModel? stats,
    DateTime? focusedMonth,
  }) {
    return VisitsState(
      visitedDates: visitedDates ?? this.visitedDates,
      stats: stats ?? this.stats,
      focusedMonth: focusedMonth ?? this.focusedMonth,
    );
  }
}

class VisitsNotifier extends AsyncNotifier<VisitsState> {
  @override
  Future<VisitsState> build() async {
    return _loadMonth(DateTime.now());
  }

  String _monthKey(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}';

  Future<VisitsState> _loadMonth(DateTime month) async {
    final api = ref.read(visitsApiServiceProvider);

    // Fire both requests before awaiting either — runs in parallel.
    final historyFuture = api.getHistory(month: _monthKey(month));
    final statsFuture = api.getStats();

    final visitedDates = await historyFuture;
    final stats = await statsFuture;

    return VisitsState(
      visitedDates: visitedDates,
      stats: stats,
      focusedMonth: month,
    );
  }

  /// Call when the calendar's visible month changes (e.g. table_calendar's
  /// onPageChanged).
  Future<void> changeMonth(DateTime month) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadMonth(month));
  }

  /// Call after a successful QR scan. Returns true if the user had already
  /// checked in today — useful for showing a different toast/snackbar.
  Future<bool> checkIn(String gymId) async {
  final api = ref.read(visitsApiServiceProvider);
  final alreadyCheckedIn = await api.checkIn(gymId);

  final currentMonth = state.when(
    data: (s) => s.focusedMonth,
    loading: () => DateTime.now(),
    error: (_, _) => DateTime.now(),
  );

  state = const AsyncLoading();
  state = await AsyncValue.guard(() => _loadMonth(currentMonth));

  return alreadyCheckedIn;
}
}

final visitsProvider = AsyncNotifierProvider<VisitsNotifier, VisitsState>(
  VisitsNotifier.new,
);