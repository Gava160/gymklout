import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/providers/nearby_gyms_provider.dart';
import 'package:gymklout/screens/home/widgets/recommended_gymcenter_widget.dart';
import 'package:gymklout/services/location_service.dart';
import 'package:gymklout/app-settings/app_data.dart';

class RecommendedGymsSection extends ConsumerStatefulWidget {
  final int maxItems;

  const RecommendedGymsSection({super.key, this.maxItems = 5});

  @override
  ConsumerState<RecommendedGymsSection> createState() =>
      _RecommendedGymsSectionState();
}

class _RecommendedGymsSectionState
    extends ConsumerState<RecommendedGymsSection> {
  bool _checkingPermission = true;
  bool _readyToFetch = false; // true once granted OR user tapped CTA

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
  }

  Future<void> _checkInitialPermission() async {
    final locationService = ref.read(locationServiceProvider);
    final granted = await locationService.hasPermission();
    if (!mounted) return;
    setState(() {
      _readyToFetch = granted;
      _checkingPermission = false;
    });
  }

  void _onFindGymsTapped() {
    setState(() => _readyToFetch = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPermission) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        child:  Center(child: showSpinner()),
      );
    }

    if (!_readyToFetch) {
      return _LocationPrePrompt(onPressed: _onFindGymsTapped);
    }

    return _GymsCarousel(maxItems: widget.maxItems);
  }
}

// Separate widget so the provider is only watched once permission flow has started
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

class _LocationPrePrompt extends StatelessWidget {
  final VoidCallback onPressed;

  const _LocationPrePrompt({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppDefaults.darkBgColor.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on_outlined,
              color: AppDefaults.primaryColor, size: 40),
          const SizedBox(height: 16),
          Text(
            'Find gyms near you',
            style: AppDefaults.headLiner1(
              context,
              fontWeight: FontWeight.w700,
            ).copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We use your location to recommend gyms closest to you. Your location is never shared with other users.',
            style: AppDefaults.textStyle(context).copyWith(
              color: AppDefaults.darkBgColor.withAlpha(180),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppDefaults.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Find Gyms Near Me',
              style: AppDefaults.textStyle(context, fontWeight: FontWeight.w600)
                  .copyWith(color: AppDefaults.white),
            ),
          ),
        ],
      ),
    );
  }
}

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