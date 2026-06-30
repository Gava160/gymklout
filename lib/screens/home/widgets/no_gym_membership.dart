import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:iconsax/iconsax.dart';

class NoGymMembershipWidget extends StatelessWidget {
  const NoGymMembershipWidget({
    super.key,
    required this.desc,
    required this.onClick,
    required this.title,
  });
  final String title;
  final String desc;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(angle: -10, child: Image.asset(AppMedia.gymDumbellColoredIcon, width: 70,)),
          SizedBox(height: 15),
          Text(
            title,
            style: AppDefaults.headLiner1(context, fontWeight: FontWeight.w400)
                .copyWith(
                  color: getDefaultHeaderColor(context),
                  fontSize: (AppDefaults.headLiner1(context).fontSize ?? 21) - 1,
                ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: screenWidth * 0.80,
            child: Text(
              desc,
              style: AppDefaults.textStyle(context, fontWeight: FontWeight.w300)
                  .copyWith(
                    color: getDefaultHeaderColor(context, lightAlpha: 180),
                    fontSize: (AppDefaults.textStyle(context).fontSize ?? 21),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            width: screenWidth * 0.50,
            child: AppCustomButton(
              noPadding: true,
              setPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 25),
              label: Text(
                "Find Club",
                style:
                    AppDefaults.textStyle(
                      context,
                      fontWeight: FontWeight.w800,
                    ).copyWith(
                      color: AppDefaults.white,
                      fontSize:
                          (AppDefaults.textStyle(context).fontSize ?? 16) + 4,
                    ),
              ),
              icon: Icon(Iconsax.search_normal, size: 20),
              onSubmit: onClick,
            ),
          ),
        ],
      ),
    );
  }
}
