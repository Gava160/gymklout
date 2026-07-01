import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class ReuseableBlockHeader extends StatelessWidget {
  const ReuseableBlockHeader({
    super.key,
    required this.title,
    required this.actions,
    this.smallerText = false,
  });

  final String title;
  final List<Widget> actions;
  final bool smallerText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppDefaults.textStyle(context).copyWith(
            color: isDark ? AppDefaults.white : AppDefaults.black,
            fontWeight: FontWeight.w700,
            fontSize: smallerText
                ? (AppDefaults.textStyle(context).fontSize ?? 16)
                : (AppDefaults.textStyle(context).fontSize ?? 16) + 6,
          ),
        ),
        Row(
          children: actions,
        )
      ],
    );
  }
}
