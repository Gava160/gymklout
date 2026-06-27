import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/screens/my-account/widgets/gradient_image.dart';

class ProfileHeaderWidget extends StatefulWidget {
  const ProfileHeaderWidget({
    super.key,
    required this.joined,
    this.anyMembership = false,
  });
  final String joined;
  final bool anyMembership;

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 0.50,
                    color: AppDefaults.textColor.withAlpha(70),
                  ),
                ),
              ),
              child: GradientCircularAvatar(
                imagePath: AppMedia.avatar,
                progress: 0.75, // 75% of the ring filled
                size: 130,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 140,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Joined",
                    style:
                        AppDefaults.headLiner1(
                          context,
                          fontWeight: FontWeight.w200,
                        ).copyWith(
                          color: getDefaultHeaderColor(
                            context,
                            lightAlpha: 100,
                          ),
                          fontSize:
                              (AppDefaults.headLiner1(context).fontSize ?? 21) -
                              10,
                        ),
                  ),
                  Text(
                    widget.joined,
                    style:
                        AppDefaults.headLiner1(
                          context,
                          fontWeight: FontWeight.w800,
                        ).copyWith(
                          color: getDefaultHeaderColor(
                            context,
                            lightAlpha: 150,
                          ),
                          fontSize:
                              (AppDefaults.headLiner1(context).fontSize ?? 21) -
                              7,
                        ),
                  ),

                  if (widget.anyMembership) ...[
                    SizedBox(height: 12),
                    Text(
                      "iFitness Membership",
                      style:
                          AppDefaults.headLiner1(
                            context,
                            fontWeight: FontWeight.w400,
                          ).copyWith(
                            color: AppDefaults.primaryColor,
                            fontSize:
                                (AppDefaults.headLiner1(context).fontSize ??
                                    21) -
                                14,
                          ),
                    ),
                    Text(
                      "Until 22 July, 2026",
                      style:
                          AppDefaults.headLiner1(
                            context,
                            fontWeight: FontWeight.w800,
                          ).copyWith(
                            color: getDefaultHeaderColor(
                              context,
                              lightAlpha: 150,
                            ),
                            fontSize:
                                (AppDefaults.headLiner1(context).fontSize ??
                                    21) -
                                7,
                          ),
                    ),
                    Text(
                      "12 Months SubScription",
                      style:
                          AppDefaults.headLiner1(
                            context,
                            fontWeight: FontWeight.w300,
                          ).copyWith(
                            color: getDefaultHeaderColor(
                              context,
                              lightAlpha: 80,
                            ),
                            fontSize:
                                (AppDefaults.headLiner1(context).fontSize ??
                                    21) -
                                12,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
