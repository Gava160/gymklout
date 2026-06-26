import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';

class CustomTextfieldTwo extends StatefulWidget {
  const CustomTextfieldTwo({
    super.key,
    required this.hintText,
    required this.label,
    required this.keyboardType,
    this.addSubLabel = "",
    this.controller,
    this.suffixIcon,
    this.numbersOnly = false,
    this.disabled = false,
    this.onChange,
    this.onEditingComplete,
    this.maxLength,
    this.prefixText,
    this.hideHeaderLabel = false,
    this.customBorderRadius,
    this.disableFocus = false,
    this.prefixIcon,
    this.passField = false,
  });

  final String hintText;
  final String label;
  final TextInputType keyboardType;
  final String? addSubLabel;
  final Widget? suffixIcon;
  final bool? numbersOnly;
  final bool? passField;
  final bool disabled;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final int? maxLength;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool hideHeaderLabel;
  final BorderRadius? customBorderRadius;
  final bool disableFocus;

  final void Function(String? selectedVTUID)? onChange;

  @override
  State<CustomTextfieldTwo> createState() => _CustomTextfieldTwoState();
}

class _CustomTextfieldTwoState extends State<CustomTextfieldTwo> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.hideHeaderLabel
                ? SizedBox.shrink()
                : Text(
                    widget.label,
                    style: AppDefaults.textStyle(context).copyWith(
                      color: isDark
                          ? AppDefaults.white.withAlpha(250)
                          : AppDefaults.textStyle(context).color,
                    ),
                  ),
            widget.addSubLabel != "" ? Spacer() : SizedBox.shrink(),
            widget.addSubLabel != ""
                ? Text(
                    widget.addSubLabel ?? "",
                    style: AppDefaults.textStyle(
                      context,
                    ).copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                  )
                : SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          onChanged: widget.onChange,
          readOnly: widget.disabled,
          keyboardType: widget.keyboardType,
          onEditingComplete: widget.onEditingComplete,
          obscureText: widget.passField == true || false,
          inputFormatters: widget.numbersOnly == true
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  if (widget.maxLength != null)
                    LengthLimitingTextInputFormatter(widget.maxLength),
                ]
              : null,
          style: AppDefaults.textStyle(context).copyWith(
            fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) + 2,
            color: isDark
                ? AppDefaults.white.withAlpha(200)
                : AppDefaults.textStyle(context).color,
          ),
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            hintText: widget.hintText,
            filled: true,
            prefixIcon: widget.prefixIcon,

            fillColor: isDark
                ? AppDefaults.textColor.withAlpha(40)
                : AppDefaults.textColor.withAlpha(20),

            suffixIcon: widget.suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            enabledBorder: widget.disableFocus
                ? null
                : OutlineInputBorder(
                    borderRadius:
                        widget.customBorderRadius ?? BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppDefaults.textColor.withAlpha(50),
                      width: 0,
                    ),
                  ),

            focusedBorder: widget.disableFocus
                ? null
                : OutlineInputBorder(
                    borderRadius:
                        widget.customBorderRadius ?? BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppDefaults.primaryColor
                          : AppDefaults.black,
                      width: 1.5,
                    ),
                  ),

            hintStyle: TextStyle(
              color: isDark
                  ? AppDefaults.white.withAlpha(200)
                  : AppDefaults.textColor,
              fontSize: AppDefaults.textStyle(context).fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
