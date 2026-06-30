import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResolvedLocation {
  final double latitude;
  final double longitude;
  final String? state;
  final String? city;
  final String? country;

  const ResolvedLocation({
    required this.latitude,
    required this.longitude,
    this.state,
    this.city,
    this.country,
  });
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}

class LocationService {
  Future<ResolvedLocation> getCurrentLocation() async {
    final permission = await _ensurePermission();
    if (!permission) {
      throw const LocationException(
        'Location permission is required to find gyms near you.',
      );
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are turned off. Please enable them.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );

    String? state;
    String? city;
    String? country;

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        state = place.administrativeArea;
        city = place.locality;
        country = place.country;
      }
    } catch (_) {
      // Reverse geocoding failed — fall back to coords-only.
      // Caller decides whether to proceed without state.
    }

    return ResolvedLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      state: state,
      city: city,
      country: country,
    );
  }

  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.denied ? false : true;
  }
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);