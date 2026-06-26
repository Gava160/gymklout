import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class NoGymMembershipWidget extends StatelessWidget {
  const NoGymMembershipWidget({super.key});

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
          Text(
            "Find Gym Membership",
            style: AppDefaults.headLiner1(context, fontWeight: FontWeight.w400)
                .copyWith(
                  color: getDefaultHeaderColor(context),
                  fontSize:
                      (AppDefaults.headLiner1(context).fontSize ?? 21) - 1,
                ),
          ),
          SizedBox(
            width: screenWidth * 0.80,
            child: Text(
              "You need a gym membership to unlock all the features of ${AppDefaults.appName}",
              style: AppDefaults.textStyle(context, fontWeight: FontWeight.w300)
                  .copyWith(
                    color: getDefaultHeaderColor(context, lightAlpha: 180),
                    fontSize: (AppDefaults.textStyle(context).fontSize ?? 21),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
