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
  final bool isLoading;
  final bool isDisabled;

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
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppDefaults.white,
            backgroundColor: isDisabled == true
                ? bgColor != null
                      ? lighten(bgColor!, 0.05)
                      : lighten(AppDefaults.primaryColor, 0.05)
                : bgColor ?? AppDefaults.primaryColor,
            disabledBackgroundColor: lighten(
              bgColor ?? AppDefaults.primaryColor,
              0.2,
            ),
            disabledForegroundColor: foregroundColor ?? Colors.white,
            elevation: 0,
            padding:
                setPadding ??
                const EdgeInsets.symmetric(vertical: 17, horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(130),
            ),
          ),
          child: isLoading
              ? showSpinner()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    label,
                    icon != null
                        ? const SizedBox(width: 10)
                        : const SizedBox.shrink(),
                    icon ?? const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}
