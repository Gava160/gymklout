import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class IconCustomButtonAuth extends StatelessWidget {
  final VoidCallback? onSubmit;
  final bool noPadding;
  final IconData icon;
  final bool light;
  final double iconSize;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const IconCustomButtonAuth({
    super.key,
    required this.onSubmit,
    this.foregroundColor,
    this.backgroundColor,
    this.noPadding = false,
    required this.icon,
    this.light = false,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          onPressed: onSubmit,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(icon, size: iconSize),
          style: ElevatedButton.styleFrom(
            foregroundColor: foregroundColor ?? AppDefaults.white,
            backgroundColor: backgroundColor ?? AppDefaults.primaryColor,
            disabledBackgroundColor: light
                ? lighten(AppDefaults.errorColor, 0.2)
                : lighten(AppDefaults.primaryColor, 0.2),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
