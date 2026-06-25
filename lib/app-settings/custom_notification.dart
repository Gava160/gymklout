import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';

void customSuccessNotification({
  BuildContext? context,
  String? text,
  String type = "success",
}) {
  HapticFeedback.selectionClick();

  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(
        text!,
        style: AppDefaults.textStyle(
          context,
        ).copyWith(color: AppDefaults.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: type == "success"
          ? AppDefaults.successColor
          : type == "info"
          ? Colors.lightBlue
          : AppDefaults.errorColor,
      showCloseIcon: true,
    ),
  );
}
