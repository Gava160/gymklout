import 'package:flutter/material.dart';
import 'package:gymklout/screens/complete-profile-registration/processes/collect_gender.dart';

Future<void> startCompleteRegistration(BuildContext context) {
  final topPadding = MediaQuery.of(context).padding.top;
  final screenHeight = MediaQuery.of(context).size.height;
  final maxSize = (screenHeight - topPadding) / screenHeight;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent, // 👈 this
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: maxSize,
      minChildSize: maxSize,
      maxChildSize: maxSize,
      builder: (_, scrollController) =>
          ClipRRect(child: CollectGenderScreen()),
    ),
  );
}
