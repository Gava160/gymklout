import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class GetMembershipAlertWidget extends StatelessWidget {
  const GetMembershipAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: darken(AppDefaults.secondaryColor, 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Membership",
                  style:
                      AppDefaults.headLiner1(
                        context,
                        fontWeight: FontWeight.w700,
                      ).copyWith(
                        color: getDefaultHeaderColor(context),
                        fontSize:
                            (AppDefaults.headLiner1(context).fontSize ?? 21) -
                            12,
                      ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Get Membership",
                style:
                    AppDefaults.headLiner1(
                      context,
                      fontWeight: FontWeight.w700,
                    ).copyWith(
                      color: getDefaultHeaderColor(context, lightAlpha: 230),
                      fontSize:
                          (AppDefaults.headLiner1(context).fontSize ?? 21) - 5,
                    ),
              ),
              SizedBox(height: 5),
              Text(
                "Find a gym center close to you \nand unlock all features in ${AppDefaults.appName}.",
                style:
                    AppDefaults.headLiner1(
                      context,
                      fontWeight: FontWeight.w400,
                    ).copyWith(
                      color: getDefaultHeaderColor(context, lightAlpha: 150),
                      fontSize:
                          (AppDefaults.headLiner1(context).fontSize ?? 21) - 12,
                    ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            size: 26,
            color: getDefaultTextColor(context, lightAlpha: 150),
          ),
        ],
      ),
    );
  }
}
