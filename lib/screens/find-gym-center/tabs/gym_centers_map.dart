import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/index.dart';
import 'package:gymklout/providers/map_gyms_provider.dart';
import 'package:gymklout/screens/find-gym-center/widgets/reuseable_gym_center_wrapper.dart';

class GymCentersMapWidget extends ConsumerStatefulWidget {
  const GymCentersMapWidget({super.key});

  @override
  ConsumerState<GymCentersMapWidget> createState() =>
      _GymCentersMapWidgetState();
}

class _GymCentersMapWidgetState extends ConsumerState<GymCentersMapWidget>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  GymModel? _selectedGym;

  // Animation
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;
  double _currentBearing = 0;
  bool _isTrackingMode = false;

  String? _mapStyle;

  void _startTracking() {
    HapticFeedback.selectionClick();
    setState(() => _isTrackingMode = true);

    // Listen to live location
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, // update every 5 metres
          ),
        ).listen((position) {
          if (!_isTrackingMode || _mapController == null) return;
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 17,
                tilt: 60, // slanted view
                bearing: _currentBearing,
              ),
            ),
          );
        });

    // Listen to compass for bearing
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading == null) return;
      setState(() => _currentBearing = event.heading!);
    });
  }

  void _stopTracking() {
    HapticFeedback.selectionClick();
    setState(() => _isTrackingMode = false);
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    _locationSubscription = null;
    _compassSubscription = null;
  }

  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString(
      'assets/map_styles/dark_map.json',
    );
    setState(() => _mapStyle = style);
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMarkerTapped(GymModel gym) {
    setState(() => _selectedGym = gym);
    _animationController.forward();

    // Pan camera to tapped gym
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(gym.latitude, gym.longitude)),
    );
  }

  void _onMapTapped(LatLng _) {
    _animationController.reverse().then((_) {
      if (mounted) setState(() => _selectedGym = null);
    });
  }

  Set<Marker> _buildMarkers(List<GymModel> gyms, String? closestGymId) {
    return gyms.map((gym) {
      final isClosest = gym.id == closestGymId;
      final isSelected = gym.id == _selectedGym?.id;

      return Marker(
        markerId: MarkerId(gym.id),
        position: LatLng(gym.latitude, gym.longitude),
        icon: isClosest
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            : isSelected
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: gym.name),
        onTap: () => _onMarkerTapped(gym),
      );
    }).toSet();
  }

  void _onMapCreated(
    GoogleMapController controller,
    List<GymModel> gyms,
    String? closestGymId,
  ) {
    _mapController = controller;

    // Auto-select and center on closest gym on load
    if (gyms.isNotEmpty) {
      final closest = gyms.firstWhere(
        (g) => g.id == closestGymId,
        orElse: () => gyms.first,
      );

      // Slight delay lets the map fully render before animating
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(closest.latitude, closest.longitude),
            14,
          ),
        );
        _onMarkerTapped(closest);

        // 👇 Auto-start tracking mode after map loads
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          _startTracking();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapGymsAsync = ref.watch(mapGymsProvider);

    return SizedBox.expand(
      child: mapGymsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 36,
                color: AppDefaults.textColor.withAlpha(150),
              ),
              const SizedBox(height: 12),
              Text(
                'Could not load gyms.\nPlease try again.',
                textAlign: TextAlign.center,
                style: AppDefaults.textStyle(context),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.read(mapGymsProvider.notifier).refresh(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
        data: (state) {
          final markers = _buildMarkers(state.gyms, state.closestGymId);

          return Stack(
            children: [
              // ── Google Map ──────────────────────────────────────────────
              Positioned.fill(
                child: GoogleMap(
                  onMapCreated: (controller) =>
                      _onMapCreated(controller, state.gyms, state.closestGymId),
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(5.5167, 5.7500),
                    zoom: 14,
                  ),
                  style: _mapStyle, // 👈 only this line is new
                  markers: markers,
                  onTap: _onMapTapped,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),

              Positioned(
                right: 10,
                top: 90,
                child: FloatingActionButton.small(
                  backgroundColor: _isTrackingMode
                      ? AppDefaults.primaryColor
                      : Colors.white,
                  onPressed: _isTrackingMode ? _stopTracking : _startTracking,
                  child: Icon(
                    Icons.navigation_rounded,
                    color: _isTrackingMode
                        ? Colors.white
                        : AppDefaults.primaryColor,
                  ),
                ),
              ),

              // ── Gym detail card ─────────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: SafeArea(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _selectedGym != null
                          ? GestureDetector(
                              onTap: () {},
                              child: ReuseableGymCenterWrapper(
                                gym: _selectedGym!,
                              ),
                            )
                          : const SizedBox.shrink(),
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
