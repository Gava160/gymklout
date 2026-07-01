import 'package:flutter/material.dart';
import 'package:gymklout/screens/find-gym-center/widgets/reuseable_gym_center_wrapper.dart';

class GymCentersNearbyWidget extends StatefulWidget {
  const GymCentersNearbyWidget({super.key});

  @override
  State<GymCentersNearbyWidget> createState() => _GymCentersNearbyWidgetState();
}

class _GymCentersNearbyWidgetState extends State<GymCentersNearbyWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ReuseableGymCenterWrapper(),
          ),
        ),
      ),
    );
  }
}
