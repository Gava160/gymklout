import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class AppCustomButton extends StatelessWidget {
  final Widget label;
  final VoidCallback? onSubmit;
  final bool noPadding;
  final Widget? icon;
  final Color? bgColor;
  final Color? foregroundColor;
  final double? height;
  final EdgeInsets? setPadding;

  const AppCustomButton({
    super.key,
    required this.onSubmit,
    required this.label,
    this.noPadding = false,
    this.icon,
    this.height,
    this.setPadding,
    this.bgColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        width: double.infinity,
        // height: height ?? 55,
        child: ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppDefaults.white,
            backgroundColor: bgColor ?? AppDefaults.primaryColor,
            disabledBackgroundColor: lighten(
              bgColor ?? AppDefaults.primaryColor,
              0.2,
            ),
            disabledForegroundColor: foregroundColor ?? Colors.white,
            elevation: 0,
            padding:
                setPadding ??
                EdgeInsets.symmetric(vertical: 17, horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(130),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              label,
              icon != null ? SizedBox(width: 10) : SizedBox.shrink(),
              icon ?? SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
