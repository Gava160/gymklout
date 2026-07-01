import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/providers/nearby_gyms_provider.dart';
import 'package:gymklout/screens/find-gym-center/widgets/reuseable_gym_center_wrapper.dart';

const int _pageSize = 15;

class GymCentersNearbyWidget extends ConsumerStatefulWidget {
  const GymCentersNearbyWidget({super.key});

  @override
  ConsumerState<GymCentersNearbyWidget> createState() =>
      _GymCentersNearbyWidgetState();
}

class _GymCentersNearbyWidgetState
    extends ConsumerState<GymCentersNearbyWidget> {
  int _visibleCount = _pageSize;

  @override
  Widget build(BuildContext context) {
    final nearbyGymsAsync = ref.watch(nearbyGymsProvider);

    return nearbyGymsAsync.when(
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
              onPressed: () =>
                  ref.read(nearbyGymsProvider.notifier).refresh(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
      data: (state) {
        if (state.gyms.isEmpty) {
          return Center(
            child: Text(
              'No gyms found near you.',
              style: AppDefaults.textStyle(context),
            ),
          );
        }

        final visibleGyms = state.gyms.take(_visibleCount).toList();
        final hasMore = _visibleCount < state.gyms.length;

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 32),
          itemCount: visibleGyms.length + 1, // +1 for load more / end label
          itemBuilder: (context, index) {
            // Load more button / end label
            if (index == visibleGyms.length) {
              if (hasMore) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _visibleCount += _pageSize);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppDefaults.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Load More',
                      style: AppDefaults.textStyle(
                        context,
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: AppDefaults.primaryColor),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'You\'ve seen all gyms near you',
                    style: AppDefaults.textStyle(context).copyWith(
                      color: AppDefaults.textColor.withAlpha(150),
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }

            final gym = visibleGyms[index];
            final isClosest = gym.id == state.closestGymId;

            return Padding(
              padding: AppDefaults.defaultPadding.copyWith(bottom: 0),
              child: GestureDetector(
                onTap: () {
                  // HapticFeedback.selectionClick();
                },
                child: ReuseableGymCenterWrapper(gym: gym, isClosestGym: isClosest),
              ),
            );
          },
        );
      },
    );
  }
}