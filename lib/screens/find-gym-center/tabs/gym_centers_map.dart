import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/screens/find-gym-center/widgets/reuseable_gym_center_wrapper.dart';

class GymCentersMapWidget extends StatefulWidget {
  const GymCentersMapWidget({super.key});

  @override
  State<GymCentersMapWidget> createState() => _GymCentersMapWidgetState();
}

class _GymCentersMapWidgetState extends State<GymCentersMapWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppMedia.updateAppBG2, fit: BoxFit.cover),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: SafeArea(child: ReuseableGymCenterWrapper()),
          ),
        ],
      ),
    );
  }
}
