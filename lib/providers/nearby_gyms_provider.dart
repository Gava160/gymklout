import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/models/index.dart';
import 'package:gymklout/services/gyms_api_service.dart';
import 'package:gymklout/services/location_service.dart';

class NearbyGymsState {
  final List<GymModel> gyms;
  final String? closestGymId;

  const NearbyGymsState({
    required this.gyms,
    this.closestGymId,
  });
}

class NearbyGymsNotifier extends AsyncNotifier<NearbyGymsState> {
  @override
  Future<NearbyGymsState> build() async {
    return _fetch();
  }

  Future<NearbyGymsState> _fetch() async {
    final locationService = ref.read(locationServiceProvider);
    final gymsApi = ref.read(gymsApiServiceProvider);

    final location = await locationService.getCurrentLocation();

    final result = await gymsApi.getNearbyGyms(
      latitude: location.latitude,
      longitude: location.longitude,
      state: location.state,
    );

    return NearbyGymsState(
      gyms: result.gyms,
      closestGymId: result.closestGymId,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final nearbyGymsProvider =
    AsyncNotifierProvider<NearbyGymsNotifier, NearbyGymsState>(
  NearbyGymsNotifier.new,
);