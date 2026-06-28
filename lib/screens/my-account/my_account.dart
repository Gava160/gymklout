import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/authentication/signin/signin.dart';
import 'package:gymklout/screens/complete-profile-registration/start_process.dart';
import 'package:gymklout/screens/my-account/widgets/account_todo_widget.dart';
import 'package:gymklout/screens/my-account/widgets/link_wrapper.dart';
import 'package:gymklout/screens/my-account/widgets/profile_header.dart';

class MyAccountScreen extends ConsumerStatefulWidget {
  const MyAccountScreen({super.key});

  @override
  ConsumerState<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  bool _isLoadingCompleteRegState = false;
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    

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
                if (profile?.completedProfileRegistration == false) ...[
                  AccountTODOWidget(
                    tagText: "Not done",
                    showTag: true,
                    labelHeader: "Complete Your Profile",
                    isLoading: _isLoadingCompleteRegState,
                    desc:
                        "Submit your personal information, we collect these information once, so signup with gym centers becomes easier.",
                    onClick: () async {
                      HapticFeedback.selectionClick();
                      setState(() => _isLoadingCompleteRegState = true);
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() => _isLoadingCompleteRegState = false);
                      if (!context.mounted) return;
                      startCompleteRegistration(context);
                    },
                  ),
                ],

                AccountLinkWrapper(
                  label: "Sign Out",
                  borderBottom: true,
                  borderTop: true,
                  labelColor: AppDefaults.errorColor,
                  hideRightIcon: true,
                  onClick: () {
                    HapticFeedback.selectionClick();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
