import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.label,
    required this.keyboardType,
    this.passField = false,
    this.pinField = false,
    this.phoneField = false,
    this.controller,
    this.enabled = true,
    this.prefixText = "",
    this.prefixIcon,
    this.onChange,
    this.smaller = false,
    this.otpField = false,
  });

  final String hintText;
  final String? label;
  final TextInputType keyboardType;
  final bool? passField;
  final bool? otpField;
  final bool pinField;
  final bool? enabled;
  final bool? phoneField;
  final TextEditingController? controller;
  final String prefixText;
  final Widget? prefixIcon;
  final ValueChanged? onChange;
  final bool? smaller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != ""
            ? Text(
                widget.label ?? "",
                style: AppDefaults.textStyle(context).copyWith(
                  color: isDark ? AppDefaults.white : AppDefaults.black,
                ),
              )
            : SizedBox.shrink(),
        widget.label != "" ? const SizedBox(height: 8) : SizedBox.shrink(),

        TextField(
          controller: widget.controller,
          onChanged: widget.onChange,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          style: AppDefaults.textStyle(context).copyWith(
            fontSize: AppDefaults.textStyle(context).fontSize,
            color: isDark
                ? AppDefaults.white
                : AppDefaults.textStyle(context).color,
          ),
          obscureText: widget.passField == true || widget.pinField == true
              ? hidePass
              : false,
          inputFormatters: widget.pinField == true || widget.phoneField == true
              ? <TextInputFormatter>[
                  if (widget.phoneField != true)
                    FilteringTextInputFormatter.digitsOnly,
                  if (widget.phoneField == false)
                    LengthLimitingTextInputFormatter(4),
                ]
              : widget.otpField == true
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ]
              : null,
          textAlign: widget.otpField == true
              ? TextAlign.center
              : TextAlign.left,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixText: widget.prefixText,
            prefixStyle: TextStyle(
              color: isDark ? AppDefaults.white : AppDefaults.textColor,
            ),
            prefixIconColor: isDark ? AppDefaults.white : AppDefaults.textColor,
            suffixIconColor: isDark
                ? AppDefaults.white
                : AppDefaults.primaryColor,
            prefixIcon: widget.prefixIcon,
            filled: false,
            suffixIcon: widget.passField == true
                ? Padding(
                    padding: EdgeInsets.only(right: 18),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (hidePass == true) {
                            hidePass = false;
                          } else {
                            hidePass = true;
                          }
                        });
                      },
                      child: hidePass
                          ? Icon(Iconsax.eye, size: 20)
                          : Icon(Iconsax.eye_slash, size: 20),
                    ),
                  )
                : null,
            // spacing inside
            contentPadding: widget.smaller == true
                ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 0, vertical: 18),

            // border style
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: isDark ? AppDefaults.white.withAlpha(100) : Colors.grey,
                width: 1.2,
              ),
            ),

            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: isDark ? AppDefaults.white.withAlpha(100) : Colors.grey,
                width: 1.2,
              ),
            ),

            hintStyle: TextStyle(
              color: isDark ? AppDefaults.white : Colors.grey,
              fontSize: AppDefaults.textStyle(context).fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
