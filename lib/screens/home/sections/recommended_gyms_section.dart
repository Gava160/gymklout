import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/alerts/alerts_custom.dart';
import 'package:gymklout/providers/nearby_gyms_provider.dart';
import 'package:gymklout/screens/home/widgets/recommended_gymcenter_widget.dart';
import 'package:gymklout/services/location_service.dart';

enum LocationState {
  checking,
  ready,
  denied,
}

class RecommendedGymsSection extends ConsumerStatefulWidget {
  final int maxItems;

  const RecommendedGymsSection({super.key, this.maxItems = 5});

  @override
  ConsumerState<RecommendedGymsSection> createState() =>
      _RecommendedGymsSectionState();
}

class _RecommendedGymsSectionState
    extends ConsumerState<RecommendedGymsSection> {
 LocationState _locationState = LocationState.checking;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

Future<void> _checkInitialPermission() async {
  final locationService = ref.read(locationServiceProvider);
  final granted = await locationService.hasPermission();

  if (!mounted) return;

  if (granted) {
    setState(() {
      _locationState = LocationState.ready;
    });
  } else {
    setState(() {
      _locationState = LocationState.denied;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showLocationModal();
      }
    });
  }
}

Future<void> _showLocationModal() async {
  CustomAlertModal.show(
    context: context,
    title: 'Enable Location',
    message:
        'GymKlout uses your location to find the gyms closest to you and sort them by distance. Your location is only used for discovery and is never shared with other users.',
    primaryText: 'Enable Location',
    secondaryText: 'Maybe Later',
    onPrimary: () async {
      final locationService = ref.read(locationServiceProvider);

      final granted = await locationService.requestPermission();

      if (!mounted) return;

      // Navigator.of(context).pop();

      setState(() {
        _locationState =
            granted ? LocationState.ready : LocationState.denied;
      });
    },
    onSecondary: () {
      // Navigator.of(context).pop();

      setState(() {
        _locationState = LocationState.denied;
      });
    },
  );
}

 @override
Widget build(BuildContext context) {
  switch (_locationState) {
    case LocationState.checking:
      return _GymCarouselSkeleton();

    case LocationState.ready:
      return _GymsCarousel(
        maxItems: widget.maxItems,
      );

    case LocationState.denied:
      return _LocationPermissionRequired(
        onEnable: _showLocationModal,
      );
  }
}
}


class _LocationPermissionRequired extends StatelessWidget {
  final VoidCallback onEnable;

  const _LocationPermissionRequired({
    required this.onEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppDefaults.darkBgColor.withAlpha(12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withAlpha(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_rounded,
            size: 42,
            color: AppDefaults.primaryColor,
          ),
          const SizedBox(height: 14),
          Text(
            'Location permission required',
            style: AppDefaults.textStyle(
              context,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enable location to discover gyms closest to you.',
            textAlign: TextAlign.center,
            style: AppDefaults.textStyle(context).copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onEnable,
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
  }
}

// ─── Skeleton placeholder shown behind the modal ──────────────────────────────
class _GymCarouselSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.50;
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.82,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 10,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: AppDefaults.darkBgColor.withAlpha(15),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

// ─── Carousel (only mounted after permission granted) ─────────────────────────
class _GymsCarousel extends ConsumerWidget {
  final int maxItems;

  const _GymsCarousel({required this.maxItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyGymsAsync = ref.watch(nearbyGymsProvider);

    return nearbyGymsAsync.when(
      loading: () => SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        child:  Center(child: showSpinner()),
      ),
      error: (error, stackTrace) => _ErrorState(
        message: error is LocationException
            ? error.message
            : 'Could not load gyms near you. Please try again.',
        onRetry: () => ref.read(nearbyGymsProvider.notifier).refresh(),
      ),
      data: (state) {
        if (state.gyms.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Center(
              child: Text(
                'No gyms found near you yet.',
                style: AppDefaults.textStyle(context),
              ),
            ),
          );
        }

        return RecommendedGymCenters(
          gyms: state.gyms,
          maxItems: maxItems,
          closestGymId: state.closestGymId,
          onTap: (gym) {
          },
        );
      },
    );
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined,
                color: AppDefaults.darkBgColor.withAlpha(150), size: 36),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppDefaults.textStyle(context),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}