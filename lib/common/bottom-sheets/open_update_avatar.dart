import 'package:flutter/material.dart';
import 'package:gymklout/screens/my-account/update-profile-avatar/profile_avatar.dart';

Future<void> openUpdateAvatarSheet(
  BuildContext context, {
  required bool popAfterSuccess,
}) {
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
      builder: (_, scrollController) => ClipRRect(
        child: ProfileAvatarSetScreen(popAfterSuccess: popAfterSuccess),
      ),
    ),
  );
}
