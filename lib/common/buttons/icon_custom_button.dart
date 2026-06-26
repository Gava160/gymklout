import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';

class IconCustomButtonAuth extends StatelessWidget {
  final VoidCallback? onSubmit;
  final bool noPadding;
  final IconData? icon;
  final bool light;
  final FaIconData? fontAwesomeIcon;
  final double iconSize;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const IconCustomButtonAuth({
    super.key,
    required this.onSubmit,
    this.foregroundColor,
    this.backgroundColor,
    this.noPadding = false,
     this.icon,
    this.light = false,
     this.fontAwesomeIcon,
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
          icon: fontAwesomeIcon == null ?  Icon(icon, size: iconSize) : FaIcon(fontAwesomeIcon, size: iconSize),
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
