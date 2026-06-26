// import 'package:flutter/material.dart';
// import 'package:gymklout/tools/app_theme.dart';
// // import 'package:gymklout/tools/app_theme.dart';

// class CustomDropdownField extends StatefulWidget {
//   final bool noPadding;
//   final String? hintText;
//   final String label;
//   final List<String>? listValues;
//   final Function(String value) onChanged;
//   final String? initialValue;

//   const CustomDropdownField({
//     super.key,
//     this.noPadding = false,
//     this.hintText,
//     this.listValues,
//     this.label = "",
//     this.initialValue,
//     required this.onChanged
//   });

//   @override
//   State<CustomDropdownField> createState() => _CustomDropdownFieldState();
// }

// class _CustomDropdownFieldState extends State<CustomDropdownField> {

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//       child: SizedBox(
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.label,
//               style: AppDefaults.textStyle(context).copyWith(color: AppDefaults.black87),
//             ),
//             const SizedBox(height: 8),
//             DropdownButtonFormField(
//               initialValue: widget.initialValue,
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//               ),
//               items: [widget.listValues]
//                   .map(
//                     (e) =>
//                         DropdownMenuItem(value: e, child: Text(e.toString())),
//                   )
//                   .toList(),
//               onChanged: widget.listValues == null
//                   ? null
//                   : widget.onChanged,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
