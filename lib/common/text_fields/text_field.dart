import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          onChanged: widget.onChange,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          style: AppDefaults.textStyle(context).copyWith(
            fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) + 4,
            fontWeight: FontWeight.w600,
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
            labelText: widget.hintText,
            labelStyle: GoogleFonts.inter(
              color: getDefaultTextColor(context, lightAlpha: 100),
              fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) + 4,
              fontWeight: FontWeight.w500,
            ),
            floatingLabelStyle: GoogleFonts.inter(
              color: _isFocused
                  ? AppDefaults.primaryColor
                  : getDefaultTextColor(context, lightAlpha: 200),
              fontSize: (AppDefaults.textStyle(context).fontSize ?? 16),
              fontWeight: FontWeight.w500,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixText: widget.prefixText,
            prefixStyle: TextStyle(color: getDefaultTextColor(context)),
            prefixIconColor: getDefaultTextColor(context),
            suffixIconColor: isDark
                ? AppDefaults.white
                : AppDefaults.primaryColor,
            prefixIcon: widget.prefixIcon,
            filled: false,
            suffixIcon: widget.passField == true
                ? Padding(
                    padding: EdgeInsets.only(right: 18),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (hidePass == true) {
                            hidePass = false;
                          } else {
                            hidePass = true;
                          }
                        });
                      },
                      child: hidePass
                          ? Icon(
                              Iconsax.eye4,
                              size: 20,
                              color: getDefaultTextColor(
                                context,
                                lightAlpha: 100,
                              ),
                            )
                          : Icon(
                              Iconsax.eye_slash5,
                              size: 20,
                              color: getDefaultTextColor(
                                context,
                                lightAlpha: 100,
                              ),
                            ),
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
                color: isDark ? AppDefaults.white.withAlpha(40) : Colors.grey,
                width: 0.5,
              ),
            ),

            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: isDark ? AppDefaults.white.withAlpha(100) : Colors.grey,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
