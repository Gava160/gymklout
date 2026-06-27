import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/my-account/widgets/get_membership_alert.dart';
import 'package:gymklout/screens/my-account/widgets/link_wrapper.dart';
import 'package:gymklout/screens/my-account/widgets/profile_header.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: AppDefaults.defaultPadding,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileHeaderWidget(
                  joined: "3 months ago",
                  anyMembership: true,
                ),
                SizedBox(height: 8),
                Text(
                  "Jephthah",
                  style:
                      AppDefaults.headLiner1(
                        context,
                        fontWeight: FontWeight.w600,
                      ).copyWith(
                        color: getDefaultHeaderColor(context, lightAlpha: 230),
                        fontSize:
                            (AppDefaults.headLiner1(context).fontSize ?? 21) +
                            15,
                      ),
                ),
                Text(
                  "Ezekiel",
                  style:
                      AppDefaults.headLiner1(
                        context,
                        fontWeight: FontWeight.w200,
                      ).copyWith(
                        color: getDefaultHeaderColor(context, lightAlpha: 100),
                        fontSize:
                            (AppDefaults.headLiner1(context).fontSize ?? 21) +
                            15,
                      ),
                ),

                SizedBox(height: 35),
                AccountLinkWrapper(
                  label: "Edit Profile",
                  borderBottom: true,
                  borderTop: true,
                  onClick: () {},
                ),
                AccountLinkWrapper(
                  label: "Privacy Policy",
                  borderBottom: true,
                  borderTop: false,
                  onClick: () {},
                ),
                AccountLinkWrapper(
                  label: "Account Settings",
                  borderBottom: true,
                  borderTop: false,
                  onClick: () {},
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                  },
                  child: GetMembershipAlertWidget(),
                ),
                AccountLinkWrapper(
                  label: "Sign Out",
                  borderBottom: true,
                  borderTop: true,
                  labelColor: AppDefaults.errorColor,
                  hideRightIcon: true,
                  onClick: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
