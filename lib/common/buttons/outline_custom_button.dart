import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class OutlineCustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onSubmit;
  final bool noPadding;
  final Widget? icon;
  final Color? setColor;
  final bool smallHeight;
  final bool smallerButton;
  final EdgeInsets? setPadding;

  const OutlineCustomButton({
    super.key,
    required this.onSubmit,
    required this.label,
    this.noPadding = false,
    this.icon,
    this.setColor,
    this.setPadding,
    this.smallHeight = true,
    this.smallerButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: noPadding == false
          ? const EdgeInsets.symmetric(vertical: 20, horizontal: 20)
          : const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onSubmit,
          label: Text(
            label,
            style: AppDefaults.defaultOutlineButtonStyle(context).copyWith(
              fontSize: smallerButton == false ? 16 : 14,
              color: setColor ?? AppDefaults.textColor.withAlpha(140),
              fontWeight: FontWeight.w900,
            ),
          ),
          icon: icon,
          style: OutlinedButton.styleFrom(
            foregroundColor:
                setColor ?? AppDefaults.primaryColor.withAlpha(140),
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: lighten(
              setColor ?? AppDefaults.primaryColor,
              0.2,
            ),
            disabledForegroundColor: setColor ?? AppDefaults.textColor,
            elevation: 0,
            padding: smallHeight == false
                ? EdgeInsets.symmetric(vertical: 14, horizontal: 25)
                : setPadding ??
                      EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            side: BorderSide(
              color: setColor ?? AppDefaults.textColor.withAlpha(140),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
