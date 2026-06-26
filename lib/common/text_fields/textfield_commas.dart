import 'package:flutter/services.dart';

class NumberWithCommasFormatter extends TextInputFormatter {
  final String prefix;

  NumberWithCommasFormatter({this.prefix = '₦ '});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Strip prefix and commas to get raw digits
    String raw = newValue.text.replaceAll(prefix, '').replaceAll(',', '');

    if (raw.isEmpty) return newValue.copyWith(text: prefix);

    // Format with commas
    final formatted = prefix + _addCommas(raw);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addCommas(String value) {
    // Handle decimal part if needed
    final parts = value.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    final result = intPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );

    return result + decPart;
  }
}
