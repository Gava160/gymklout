import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:iconsax/iconsax.dart';

class ReuseableGymCenterWrapper extends StatelessWidget {
  const ReuseableGymCenterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: size.width * 0.90,
          decoration: BoxDecoration(
            border: BoxBorder.all(
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppMedia.avatar)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'iFitness Gym Center',
                            style:
                                AppDefaults.textStyle(
                                  context,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(
                                  color: isDark ? Colors.white.withAlpha(200) : Colors.black,
                                  fontSize:
                                      (AppDefaults.textStyle(
                                            context,
                                          ).fontSize ??
                                          21) +
                                      2,
                                ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                Iconsax.star,
                                color: AppDefaults.secondaryColor,
                                size: 15,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '4.6 (120+)',
                                style:
                                    AppDefaults.textStyle(
                                      context,
                                      fontWeight: FontWeight.w400,
                                    ).copyWith(
                                      color: isDark ? Colors.white.withAlpha(150) : Colors.black.withAlpha(150),
                                      fontSize:
                                          (AppDefaults.textStyle(
                                                context,
                                              ).fontSize ??
                                              21) -
                                          1,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Airport Road, Warri, Delta state.',
                            style:
                                AppDefaults.textStyle(
                                  context,
                                  fontWeight: FontWeight.w400,
                                ).copyWith(
                                  color: isDark ? Colors.white.withAlpha(150) : Colors.black.withAlpha(150),
                                  fontSize:
                                      (AppDefaults.textStyle(
                                            context,
                                          ).fontSize ??
                                          21) -
                                      1,
                                ),
                          ),
                          Spacer(),
                          Text(
                            '\$\$\$',
                            style:
                                AppDefaults.textStyle(
                                  context,
                                  fontWeight: FontWeight.w400,
                                ).copyWith(
                                  color: isDark ? Colors.white.withAlpha(150) : Colors.black.withAlpha(150),
                                  fontSize:
                                      (AppDefaults.textStyle(
                                            context,
                                          ).fontSize ??
                                          21) -
                                      1,
                                ),
                          ),
                        ],
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
