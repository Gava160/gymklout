import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/models/membership_model.dart';
import 'package:gymklout/providers/membership_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gymMembership = widget.membership.gym!;

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
          expandedHeight: size.height * 0.05,
          pinned: true,
          backgroundColor: getDefaultBgColor(context),
          flexibleSpace: FlexibleSpaceBar(
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
                      color: Colors.black.withAlpha(180)
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
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 15,),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
