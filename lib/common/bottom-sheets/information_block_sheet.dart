import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/buttons/outline_custom_button.dart';
import 'package:iconsax/iconsax.dart';



Future<String?> showinformationSheet(
  BuildContext context, {
  required String header,
  required String descText,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          // height: 300,
          child: InformationBlockSheet(header: header, descText: descText),
        );
      },
    ),
  );
}



class InformationBlockSheet extends ConsumerStatefulWidget {
  const InformationBlockSheet({super.key, this.descText, this.header});

  final String? header;
  final String? descText;

  @override
  ConsumerState<InformationBlockSheet> createState() =>
      _InformationBlockSheetState();
}

class _InformationBlockSheetState extends ConsumerState<InformationBlockSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: AppDefaults.defaultPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox()),
                Icon(Iconsax.info_circle, size: 40),
                SizedBox(height: 15),
                Text(
                  widget.header ?? "",
                  textAlign: TextAlign.center,
                  style: AppDefaults.headLiner1(context).copyWith(
                    color: isDark
                        ? AppDefaults.white
                        : AppDefaults.headLiner1(context).color,
                    fontSize:
                        (AppDefaults.textStyle(context).fontSize ?? 16) + 4.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Text(
                    widget.descText ?? "",
                    textAlign: TextAlign.center,
                    style: AppDefaults.textStyle(context).copyWith(
                      color: isDark
                          ? AppDefaults.white.withAlpha(200)
                          : AppDefaults.textStyle(context).color,
                    ),
                  ),
                ),
        
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlineCustomButton(
                        onSubmit: () {
                          Navigator.pop(context);
                        },
                        label: "Dismiss",
                        noPadding: true,
                        smallHeight: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
