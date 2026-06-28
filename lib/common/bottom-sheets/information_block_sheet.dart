// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:teedeefoods/app-settings/app_data.dart';
// import 'package:teedeefoods/common/buttons/outline_custom_button.dart';
// import 'package:iconsax/iconsax.dart';

// class InformationBlockSheet extends ConsumerStatefulWidget {
//   const InformationBlockSheet({super.key, this.descText, this.header});

//   final String? header;
//   final String? descText;

//   @override
//   ConsumerState<InformationBlockSheet> createState() =>
//       _InformationBlockSheetState();
// }

// class _InformationBlockSheetState extends ConsumerState<InformationBlockSheet> {
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30),
//         topRight: Radius.circular(30),
//       ),
//       child: Container(
//         width: double.infinity,
//         padding: AppDefaults.defaultPadding,
//         decoration: BoxDecoration(
//           color: isDark
//               ? lighten(AppDefaults.darkBgColor, 0.05)
//               : AppDefaults.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(child: SizedBox()),
//               Icon(Iconsax.info_circle, size: 40),
//               SizedBox(height: 15),
//               Text(
//                 widget.header ?? "",
//                 textAlign: TextAlign.center,
//                 style: AppDefaults.headLiner1(context).copyWith(
//                   color: isDark
//                       ? AppDefaults.white
//                       : AppDefaults.headLiner1(context).color,
//                   fontSize:
//                       (AppDefaults.textStyle(context).fontSize ?? 16) + 4.5,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               SizedBox(height: 7),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.70,
//                 child: Text(
//                   widget.descText ?? "Click confirm to continue",
//                   textAlign: TextAlign.center,
//                   style: AppDefaults.textStyle(context).copyWith(
//                     color: isDark
//                         ? AppDefaults.white.withAlpha(200)
//                         : AppDefaults.textStyle(context).color,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlineCustomButton(
//                       onSubmit: () {
//                         Navigator.pop(context);
//                       },
//                       label: "Dismiss",
//                       noPadding: true,
//                       smallHeight: false,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
