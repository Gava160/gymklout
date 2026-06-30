import 'package:gymklout/models/index.dart';
import 'package:gymklout/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NearbyGymsResult {
  final List<GymModel> gyms;
  final int total;
  final String? closestGymId;

  const NearbyGymsResult({
    required this.gyms,
    required this.total,
    this.closestGymId,
  });
}

class GymsApiService {
  final ApiService _api;

  GymsApiService(this._api);

  Future<NearbyGymsResult> getNearbyGyms({
    required double latitude,
    required double longitude,
    String? state,
    double radiusKm = 10,
    int limit = 20,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radiusKm': radiusKm.toString(),
      'limit': limit.toString(),
      'offset': offset.toString(),
      if (state != null && state.isNotEmpty) 'state': state,
    };

    final query = Uri(queryParameters: queryParams).query;
    final response = await _api.get('/gyms/nearby?$query', requiresAuth: true);

    final gymsJson = response['gyms'] as List<dynamic>? ?? [];

    return NearbyGymsResult(
      gyms: gymsJson
          .map((json) => GymModel.fromJson(json as Map<String, dynamic>))
          .toList(),
      total: response['total'] as int? ?? 0,
      closestGymId: response['closestGymId'] as String?,
    );
  }
}

final gymsApiServiceProvider = Provider<GymsApiService>(
  (ref) => GymsApiService(ref.watch(apiServiceProvider)),
);