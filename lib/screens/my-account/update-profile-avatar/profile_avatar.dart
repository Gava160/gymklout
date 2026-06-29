import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';

class ProfileAvatarSetScreen extends ConsumerStatefulWidget {
  const ProfileAvatarSetScreen({super.key, required this.gender});
  final String gender;

  @override
  ConsumerState<ProfileAvatarSetScreen> createState() => _ProfileAvatarSetScreenState();
}

class _ProfileAvatarSetScreenState extends ConsumerState<ProfileAvatarSetScreen> {
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kTextTabBarHeight + 35),
        child: SafeArea(
          child: Padding(
            padding: AppDefaults.defaultPadding,
            child: CustomAppBar(title: "", actions: []),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: AppDefaults.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProcessheaderWidget(
                          header: "Upload Profile Photo",
                          subHeader:
                              "This is required by gym centers we work with.",
                        ),
                        SizedBox(height: 30),

                        
                        
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: AppDefaults.defaultPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconCustomButtonAuth(
                        noPadding: true,
                        icon: FluentIcons.arrow_left_12_regular,
                        backgroundColor: AppDefaults.textColor.withAlpha(40),
                        foregroundColor: AppDefaults.textColor,
                        onSubmit: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.40,
                      child: AppCustomButton(
                        noPadding: true,
                        setPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 15,
                        ),
                        label: Text(
                          "Upload",
                          style:
                              AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w800,
                              ).copyWith(
                                color: AppDefaults.white,
                                fontSize:
                                    (AppDefaults.textStyle(context).fontSize ??
                                        16) +
                                    4,
                              ),
                        ),
                        icon: Icon(
                          FluentIcons.save_16_regular,
                          size: 20,
                        ),
                        isLoading: isSubmitting,
                        onSubmit: () {
                          HapticFeedback.selectionClick();
                          setState(() => isSubmitting = true);
        
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
