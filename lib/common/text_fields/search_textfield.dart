import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({
    super.key,
    required this.hintText,
    this.label,
    required this.keyboardType,
    this.controller,
    this.enabled = true,
    this.onChange,
    this.smaller = false,
  });

  final String hintText;
  final String? label;
  final TextInputType keyboardType;
  final bool? enabled;
  final TextEditingController? controller;
  final ValueChanged? onChange;
  final bool? smaller;

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          onChanged: widget.onChange,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          style: AppDefaults.textStyle(context).copyWith(
            color: isDark ? AppDefaults.white : AppDefaults.black,
            fontWeight: FontWeight.w600,
            fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) - 3,
          ),

          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixStyle: TextStyle(
              color: isDark ? AppDefaults.white : AppDefaults.textColor,
            ),
            filled: false,

            // border style
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),

            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),

            hintStyle: AppDefaults.textStyle(context).copyWith(
              color: isDark ? AppDefaults.white : AppDefaults.black,
              fontWeight: FontWeight.w600,
              fontSize: (AppDefaults.textStyle(context).fontSize ?? 16) - 3,
            ),
          ),
        ),
      ],
    );
  }
}
