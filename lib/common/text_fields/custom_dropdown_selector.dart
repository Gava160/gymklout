import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:gymklout/app-settings/app_data.dart';

class DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;

  const DropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDefaults.textStyle(
            context,
          ).copyWith(color: isDark ? AppDefaults.white : AppDefaults.black),
        ),
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: (value == null || value!.isEmpty) ? null : value,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDark ? AppDefaults.white : Colors.grey,
              fontSize: AppDefaults.textStyle(context).fontSize,
              fontWeight: AppDefaults.textStyle(context).fontWeight,
            ),
          ),
          icon: Icon(Iconsax.arrow_down_1, size: 18),
          dropdownColor: isDark ? AppDefaults.black : AppDefaults.white,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppDefaults.primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
