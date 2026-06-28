import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class AccountTODOWidget extends StatefulWidget {
  const AccountTODOWidget({
    super.key,
    required this.desc,
    required this.labelHeader,
    required this.showTag,
    this.tagColor,
    required this.tagText,
    required this.onClick,
    required this.isLoading,
  });

  final String tagText;
  final Color? tagColor;
  final bool showTag;
  final bool isLoading;
  final String labelHeader;
  final String desc;
  final AsyncCallback onClick;

  @override
  State<AccountTODOWidget> createState() => _AccountTODOWidgetState();
}

class _AccountTODOWidgetState extends State<AccountTODOWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await widget.onClick();
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: AppDefaults.textColor.withAlpha(50),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.showTag) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: darken(
                          widget.tagColor ?? AppDefaults.secondaryColor,
                          0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.tagText,
                        style:
                            AppDefaults.headLiner1(
                              context,
                              fontWeight: FontWeight.w700,
                            ).copyWith(
                              color: getDefaultHeaderColor(context),
                              fontSize:
                                  (AppDefaults.headLiner1(context).fontSize ??
                                      21) -
                                  12,
                            ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],

                  Text(
                    widget.labelHeader,
                    style:
                        AppDefaults.headLiner1(
                          context,
                          fontWeight: FontWeight.w700,
                        ).copyWith(
                          color: getDefaultHeaderColor(
                            context,
                            lightAlpha: 230,
                          ),
                          fontSize:
                              (AppDefaults.headLiner1(context).fontSize ?? 21) -
                              5,
                        ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.desc,
                    style:
                        AppDefaults.headLiner1(
                          context,
                          fontWeight: FontWeight.w400,
                        ).copyWith(
                          color: getDefaultHeaderColor(
                            context,
                            lightAlpha: 150,
                          ),
                          fontSize:
                              (AppDefaults.headLiner1(context).fontSize ?? 21) -
                              12,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 40),
            widget.isLoading
                ? showSpinner()
                : Icon(
                    Icons.chevron_right,
                    size: 26,
                    color: getDefaultTextColor(context, lightAlpha: 150),
                  ),
          ],
        ),
      ),
    );
  }
}
