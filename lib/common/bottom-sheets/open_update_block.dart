import 'package:flutter/material.dart';
import 'package:gymklout/screens/update-app/update_app.dart';

Future<void> openUpdateSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent, // 👈 this
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 1,
      maxChildSize: 1,
      builder: (_, scrollController) =>
          ClipRRect(child: UpdateAppScreen()),
    ),
  );
}
