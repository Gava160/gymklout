import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';

class AccountLinkWrapper extends StatelessWidget {
  const AccountLinkWrapper({
    super.key,
    required this.borderBottom,
    required this.borderTop,
    required this.label,
    this.hideRightIcon = false,
    this.labelColor,
    required this.onClick,
    
  });
  final String label;
  final bool borderTop;
  final bool borderBottom;
  final bool hideRightIcon;
  final Color? labelColor;
  final VoidCallback onClick;
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onClick();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: borderTop ? 0.50 : 0,
              color: borderTop
                  ? AppDefaults.textColor.withAlpha(70)
                  : Colors.transparent,
            ),
            bottom: BorderSide(
              width: borderBottom ? 0.50 : 0,
              color: borderBottom
                  ? AppDefaults.textColor.withAlpha(70)
                  : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppDefaults.textStyle(context, fontWeight: FontWeight.w500)
                  .copyWith(
                    color:
                        labelColor ??
                        getDefaultTextColor(context, lightAlpha: 150),
                    fontSize:
                        (AppDefaults.textStyle(context).fontSize ?? 21) + 2,
                  ),
            ),
            hideRightIcon
                ? SizedBox.shrink()
                : Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: getDefaultTextColor(context, lightAlpha: 150),
                  ),
          ],
        ),
      ),
    );
  }
}
