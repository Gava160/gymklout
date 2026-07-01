import 'package:gymklout/models/visit_stats_model.dart';
import 'package:gymklout/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitsApiService {
  final ApiService _api;

  VisitsApiService(this._api);

  /// Records today's visit for the given gym. Returns true if this was
  /// already checked in today (idempotent — no error, just informational).
  Future<bool> checkIn(String gymId) async {
    final response = await _api.post(
      '/visits/check-in',
      {'gymId': gymId},
      requiresAuth: true,
    );
    return response['alreadyCheckedIn'] as bool? ?? false;
  }

  /// [month] must be in 'YYYY-MM' format. Omit to get full history.
  Future<List<DateTime>> getHistory({String? month}) async {
    final path = month != null ? '/visits/history?month=$month' : '/visits/history';
    final response = await _api.get(path, requiresAuth: true);
    final dates = response['visitedDates'] as List<dynamic>? ?? [];
    return dates.map((d) => DateTime.parse(d as String)).toList();
  }

  Future<VisitStatsModel> getStats() async {
    final response = await _api.get('/visits/stats', requiresAuth: true);
    return VisitStatsModel.fromJson(response);
  }
}

final visitsApiServiceProvider = Provider<VisitsApiService>(
  (ref) => VisitsApiService(ref.watch(apiServiceProvider)),
);