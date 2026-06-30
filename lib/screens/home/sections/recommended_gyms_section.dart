import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/providers/nearby_gyms_provider.dart';
import 'package:gymklout/screens/home/widgets/recommended_gymcenter_widget.dart';
import 'package:gymklout/services/location_service.dart';
import 'package:gymklout/app-settings/app_data.dart';

class RecommendedGymsSection extends ConsumerWidget {
  final int maxItems;

  const RecommendedGymsSection({super.key, this.maxItems = 5});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyGymsAsync = ref.watch(nearbyGymsProvider);

    return nearbyGymsAsync.when(
      loading: () => SizedBox(
        height: MediaQuery.of(context).size.height * 0.50,
        child: const Center(child: CircularProgressIndicator()),
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
           
            // Navigator.push(context, MaterialPageRoute(builder: (_) => GymDetailScreen(gymId: gym.id)));
          },
        );
      },
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