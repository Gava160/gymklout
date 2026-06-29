import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/screens/my-account/widgets/gradient_image.dart';

class ProfileHeaderWidget extends ConsumerStatefulWidget {
  const ProfileHeaderWidget({
    super.key,
    required this.joined,
    this.anyMembership = false,
    required this.profileAvatar
  });
  final String joined;
  final bool anyMembership;
  final String profileAvatar;

  @override
  ConsumerState<ProfileHeaderWidget> createState() =>
      _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends ConsumerState<ProfileHeaderWidget> {
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
              child: Stack(
                children: [
                  GradientCircularAvatar(
                    imagePath: widget.profileAvatar,
                    progress: 0.75, // 75% of the ring filled
                    size: 130,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: darken(AppDefaults.secondaryColor, 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "GymRat",
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
                  ),
                ],
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
                      "12 months subscription",
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
