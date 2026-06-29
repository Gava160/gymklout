import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/media.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/authentication/signin/signin.dart';
import 'package:gymklout/screens/bottom-navigation/bottom_nav_bar.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';
import 'package:gymklout/screens/my-account/update-profile-avatar/profile_avatar.dart';

class UpdateAppScreen extends ConsumerStatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  ConsumerState<UpdateAppScreen> createState() => _CollectGenderScreenState();
}

class _CollectGenderScreenState extends ConsumerState<UpdateAppScreen> {
  bool isLoading = false;
  Future<void> _remindMeLater() async {
    final authState = await ref.read(authProvider.future);

    if (authState is AuthAuthenticated) {
      final profile = authState.data.user.profile;

      // No profile at all
      if (profile == null) {
        _navigateTo(const SignInScreen());
        return;
      }

      // No avatar — must set profile photo first
      if (profile.avatarUrl == null || profile.avatarUrl!.isEmpty) {
        _navigateTo(const ProfileAvatarSetScreen());
        return;
      }

      // Fully set up — go home
      _navigateTo(const BottomNavBarController());
      return;
    } else {
      _navigateTo(const SignInScreen());
      return;
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage(AppMedia.updateAppBG1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black87,
                    Colors.black54,
                    Colors.black26,
                    Colors.black26,
                  ],
                  stops: [0.0, 0.6, 0.7, 0.80, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(child: SizedBox()),
                Padding(
                  padding: AppDefaults.defaultPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProcessheaderWidget(
                        setTextColor: Colors.white,
                        header: "Update Available",
                        subHeader:
                            "Update the app to enjoy the latest features",
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: size.width * 0.40,
                              child: AppCustomButton(
                                noPadding: true,
                                setPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 15,
                                ),
                                setBorder: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                bgColor: Colors.transparent,
                                label: Text(
                                  "Remind me later",
                                  style:
                                      AppDefaults.textStyle(
                                        context,
                                        fontWeight: FontWeight.w800,
                                      ).copyWith(
                                        color: Colors.white,
                                        fontSize:
                                            (AppDefaults.textStyle(
                                                  context,
                                                ).fontSize ??
                                                16) +
                                            2,
                                      ),
                                ),

                                isLoading: isLoading,
                                onSubmit: () async {
                                  setState(() => isLoading = true);
                                  HapticFeedback.selectionClick();
                                  await _remindMeLater();
                                  setState(() => isLoading = false);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              width: size.width * 0.40,
                              child: AppCustomButton(
                                noPadding: true,
                                setPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 15,
                                ),
                                label: Text(
                                  "Update Now",
                                  style:
                                      AppDefaults.textStyle(
                                        context,
                                        fontWeight: FontWeight.w800,
                                      ).copyWith(
                                        color: AppDefaults.white,
                                        fontSize:
                                            (AppDefaults.textStyle(
                                                  context,
                                                ).fontSize ??
                                                16) +
                                            2,
                                      ),
                                ),

                                isLoading: false,
                                onSubmit: () {
                                  HapticFeedback.selectionClick();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 55),
                      Image(
                        image: AssetImage(AppMedia.logoTextWithCaption),
                        width: 140,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
