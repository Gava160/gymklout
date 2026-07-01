import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/models/index.dart';
import 'package:iconsax/iconsax.dart';

class ReuseableGymCenterWrapper extends StatelessWidget {
  final GymModel gym;

  const ReuseableGymCenterWrapper({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageUrl = gym.coverUrl ?? gym.logoUrl;

    final addressLine = [
      if (gym.address != null) gym.address,
      if (gym.city != null) gym.city,
      if (gym.state != null) gym.state,
    ].whereType<String>().join(', ');

    return Column(
      children: [
        Container(
          width: size.width * 0.90,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: AppDefaults.textColor.withAlpha(100),
            ),
            borderRadius: BorderRadius.circular(20),
            color: isDark ? AppDefaults.darkBgColor : Colors.white,
          ),
          child: Padding(
            padding: AppDefaults.defaultPadding,
            child: Row(
              children: [
                // Gym image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppDefaults.textColor.withAlpha(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            AppMedia.avatar,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            AppMedia.avatar,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(AppMedia.avatar, fit: BoxFit.cover),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              gym.name,
                              style: AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w700,
                              ).copyWith(
                                color: isDark
                                    ? Colors.white.withAlpha(200)
                                    : Colors.black,
                                fontSize:
                                    (AppDefaults.textStyle(context).fontSize ??
                                        14) +
                                    2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Dummy rating — replace when model supports it
                          Row(
                            children: [
                              Icon(
                                Iconsax.star,
                                color: AppDefaults.secondaryColor,
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.6 (120+)',
                                style: AppDefaults.textStyle(
                                  context,
                                  fontWeight: FontWeight.w400,
                                ).copyWith(
                                  color: isDark
                                      ? Colors.white.withAlpha(150)
                                      : Colors.black.withAlpha(150),
                                  fontSize:
                                      (AppDefaults.textStyle(context).fontSize ??
                                          14) -
                                      1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              addressLine.isNotEmpty
                                  ? addressLine
                                  : 'Address not available',
                              style: AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w400,
                              ).copyWith(
                                color: isDark
                                    ? Colors.white.withAlpha(150)
                                    : Colors.black.withAlpha(150),
                                fontSize:
                                    (AppDefaults.textStyle(context).fontSize ??
                                        14) -
                                    1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Dummy price tier — replace when model supports it
                          Text(
                            '\$\$\$',
                            style: AppDefaults.textStyle(
                              context,
                              fontWeight: FontWeight.w400,
                            ).copyWith(
                              color: isDark
                                  ? Colors.white.withAlpha(150)
                                  : Colors.black.withAlpha(150),
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                      14) -
                                  1,
                            ),
                          ),
                        ],
                      ),

                      // Distance label
                      if (gym.distanceLabel.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            gym.distanceLabel,
                            style: AppDefaults.textStyle(context).copyWith(
                              color: AppDefaults.primaryColor,
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                      14) -
                                  2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}