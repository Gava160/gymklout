import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/processes/collect_age.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/gender_selector.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_appbar.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';

class CollectGenderScreen extends ConsumerStatefulWidget {
  const CollectGenderScreen({super.key});

  @override
  ConsumerState<CollectGenderScreen> createState() =>
      _CollectGenderScreenState();
}

class _CollectGenderScreenState extends ConsumerState<CollectGenderScreen> {
  String selectedGender = "";
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

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
            child: ProcessAppbar(
              title: "",
              progressValue: 10,
              progressPreviousValue: 0,
            ),
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
                          header: "Tell us about yourself",
                          subHeader:
                              "To give you better experiences, we need to know your gender",
                        ),

                        SizedBox(height: 30),
                        GenderSelectorWidget(
                          label: "Male",
                          value: "male",
                          isSelected: selectedGender == "male" ? true : false,
                          onSelect: () {
                            HapticFeedback.selectionClick();
                            setState(() => selectedGender = "male");
                          },
                        ),
                        SizedBox(height: 25),
                        GenderSelectorWidget(
                          label: "Female",
                          value: "female",
                          isSelected: selectedGender == "female" ? true : false,
                          onSelect: () {
                            HapticFeedback.selectionClick();
                            setState(() => selectedGender = "female");
                          },
                        ),
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
                    SizedBox(),
                    SizedBox(
                      width: size.width * 0.40,
                      child: AppCustomButton(
                        noPadding: true,
                        setPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 15,
                        ),
                        label: Text(
                          "Next",
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
                          FluentIcons.arrow_right_12_regular,
                          size: 20,
                        ),
                        isLoading: isSubmitting,
                        onSubmit: selectedGender == ""
                            ? null
                            : () {
                                HapticFeedback.selectionClick();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CollectAgeScreen(
                                      gender: selectedGender,
                                    ),
                                  ),
                                );
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
