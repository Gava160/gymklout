import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class ReuseableStaticField extends StatefulWidget {
  const ReuseableStaticField({
    super.key,
    required this.fieldValue,
    required this.title,
    this.rightWidget,
  });
  final String title;
  final String fieldValue;
  final Widget? rightWidget;

  @override
  State<ReuseableStaticField> createState() => _ReuseableStaticFieldState();
}

class _ReuseableStaticFieldState extends State<ReuseableStaticField> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            widget.title,
            textAlign: TextAlign.left,
            style: AppDefaults.textStyle(context).copyWith(
              color: isDark
                  ? AppDefaults.white
                  : AppDefaults.headLine3(context).color,
              fontWeight: FontWeight.w100,
              fontSize: (AppDefaults.textStyle(context).fontSize ?? 16),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark
                  ? AppDefaults.primaryColor
                  : AppDefaults.black.withAlpha(30),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.fieldValue,
                textAlign: TextAlign.left,
                style: AppDefaults.textStyle(context).copyWith(
                  color: isDark
                      ? AppDefaults.white.withAlpha(200)
                      : AppDefaults.headLine3(context).color,
                  fontWeight: FontWeight.w100,
                  fontSize: (AppDefaults.textStyle(context).fontSize ?? 16),
                ),
              ),
              widget.rightWidget ?? SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
