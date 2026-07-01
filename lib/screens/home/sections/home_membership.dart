import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/bottom-sheets/information_block_sheet.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/models/membership_model.dart';
import 'package:gymklout/providers/membership_provider.dart';
import 'package:gymklout/screens/home/sections/widgets/visits_calendar.dart';
import 'package:gymklout/screens/home/sections/widgets/visits_charts.dart';
import 'package:gymklout/screens/home/widgets/reuseable_header.dart';
import 'package:iconsax/iconsax.dart';

class HomeMembershipWidget extends ConsumerStatefulWidget {
  final MembershipModel membership;
  final MembershipSessionStatus status;

  const HomeMembershipWidget({
    super.key,
    required this.membership,
    required this.status,
  });

  @override
  ConsumerState<HomeMembershipWidget> createState() =>
      _NoGymMembershipHomeScreenState();
}

class _NoGymMembershipHomeScreenState
    extends ConsumerState<HomeMembershipWidget> {
  final List<Widget> activeHistoryViewType = [
    VisitCalendarWidget(),
    VisitsBarChartWidget(),
  ];

  int _selectedViewHistoryType = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gymMembership = widget.membership.gym!;
    // final profile = ref.watch(currentProfileProvider);

    final hasImage =
        gymMembership.coverUrl != null || gymMembership.logoUrl != null;
    final imageProvider = hasImage
        ? CachedNetworkImageProvider(
                gymMembership.coverUrl ?? "",
                cacheKey: gymMembership.coverUrl ?? gymMembership.logoUrl,
              )
              as ImageProvider
        : const AssetImage('assets/images/gym_placeholder.png');

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: size.height * 0.10,
          pinned: false,
          stretch: true,
          backgroundColor: getDefaultBgColor(context),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            background: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(180),
                    ),
                  ),
                ),
              ],
            ),
            collapseMode: CollapseMode.parallax,
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: AppDefaults.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      gymMembership.name,
                      style:
                          AppDefaults.headLiner1(
                            context,
                            fontWeight: FontWeight.w600,
                          ).copyWith(
                            color: getDefaultHeaderColor(context),
                            fontSize:
                                AppDefaults.headLiner1(context).fontSize ?? 21,
                          ),
                    ),
                    Spacer(),
                    Text(
                      "Active Membership",
                      style:
                          AppDefaults.headLiner1(
                            context,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            color: AppDefaults.successColor,
                            fontSize:
                                (AppDefaults.headLiner1(context).fontSize ??
                                    21) -
                                14,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      gymMembership.address ?? "",
                      style:
                          AppDefaults.textStyle(
                            context,
                            fontWeight: FontWeight.w400,
                          ).copyWith(
                            color: getDefaultHeaderColor(context),
                            fontSize:
                                AppDefaults.textStyle(context).fontSize ?? 21,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(
                        context,
                        label: "Scan",
                        icon: Iconsax.scan_barcode,
                        onClick: () {
                          HapticFeedback.selectionClick();
                        },
                      ),
                      _buildButton(
                        context,
                        label: "Account",
                        icon: Iconsax.user,
                        onClick: () {
                          HapticFeedback.selectionClick();
                        },
                      ),
                      _buildButton(
                        context,
                        label: "Refer",
                        icon: Iconsax.share,
                        onClick: () {
                          HapticFeedback.selectionClick();
                        },
                      ),
                      _buildButton(
                        context,
                        label: "Membership",
                        icon: Iconsax.profile_add,
                        onClick: () {
                          HapticFeedback.selectionClick();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      showinformationSheet(
                        context,
                        header: "Currently",
                        descText: "The gym is currently closed.",
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text(
                        //   "currently ",
                        //   style:
                        //       AppDefaults.textStyle(
                        //         context,
                        //         fontWeight: FontWeight.w600,
                        //       ).copyWith(
                        //         color: AppDefaults.textColor,
                        //         fontSize:
                        //             (AppDefaults.textStyle(context).fontSize ??
                        //                 21) -
                        //             4,
                        //       ),
                        // ),
                        // SizedBox(width: 5),
                        FaIcon(
                          FontAwesomeIcons.doorOpen,
                          size: 20,
                          color: AppDefaults.successColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "OPEN",
                          style:
                              AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w900,
                              ).copyWith(
                                color: AppDefaults.successColor,
                                fontSize:
                                    (AppDefaults.textStyle(context).fontSize ??
                                    16),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ReuseableBlockHeader(
                  title: "My Visit History",
                  actions: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedViewHistoryType = 0;
                        });
                      },
                      child: Icon(
                        Iconsax.calendar,
                        color: AppDefaults.primaryColor,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedViewHistoryType = 1;
                        });
                      },
                      child: Icon(
                        Iconsax.trend_up,
                        color: AppDefaults.primaryColor,
                        size: 28,
                      ),
                    ),
                    //  SizedBox(width: 25,),
                  ],
                ),
                activeHistoryViewType[_selectedViewHistoryType],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildButton(
  BuildContext context, {
  required String label,
  required VoidCallback onClick,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 70,
        height: 70,
        child: IconCustomButtonAuth(
          noPadding: true,
          icon: icon,
          backgroundColor: AppDefaults.primaryColor,
          foregroundColor: Colors.white,
          onSubmit: onClick,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        label,
        style: AppDefaults.textStyle(context, fontWeight: FontWeight.w400)
            .copyWith(
              color: getDefaultHeaderColor(context),
              fontSize: (AppDefaults.textStyle(context).fontSize ?? 21) - 1,
            ),
      ),
    ],
  );
}
