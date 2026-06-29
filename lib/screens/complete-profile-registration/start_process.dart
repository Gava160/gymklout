import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:gymklout/screens/bottom-navigation/bottom_nav_bar.dart';
import 'package:gymklout/screens/complete-profile-registration/processes/collect_age.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/gender_selector.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';

Future<void> startCompleteRegistration(BuildContext context) {
  final topPadding = MediaQuery.of(context).padding.top;
  final screenHeight = MediaQuery.of(context).size.height;
  final maxSize = (screenHeight - topPadding) / screenHeight;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent, // 👈 this
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: maxSize,
      minChildSize: maxSize,
      maxChildSize: maxSize,
      builder: (_, scrollController) =>
          ClipRRect(child: _CompleteProfileStarterContainer()),
    ),
  );
}

class _CompleteProfileStarterContainer extends ConsumerStatefulWidget {
  const _CompleteProfileStarterContainer();

  @override
  ConsumerState<_CompleteProfileStarterContainer> createState() =>
      __CompleteProfileStarterContainerState();
}

class __CompleteProfileStarterContainerState
    extends ConsumerState<_CompleteProfileStarterContainer> {
  final TextEditingController emailController = TextEditingController();
  bool isSubmitting = false;
  bool buttonIsEnabled = false;
  String selectedGender = "";

  // ------
  Future<void> _saveProfile({
    String? selectedGender,
    int? selectedAge,
    double? selectedWeight,
    double? selectedHeight,
    String? selectedGoal,
    String? selectedActivityLevel,
    String? selectedFitnessLevel,
    double? selectedTargetWeight,
    int? selectedWorkoutFrequency,
    VoidCallback? nextScreen,
  }) async {
    HapticFeedback.lightImpact();

    final isCompleted =
        selectedGender != null &&
        selectedAge != null &&
        selectedWeight != null &&
        selectedHeight != null &&
        selectedGoal != null &&
        selectedActivityLevel != null &&
        selectedFitnessLevel != null &&
        selectedTargetWeight != null &&
        selectedWorkoutFrequency != null;

    try {
      await ref
          .read(authProvider.notifier)
          .completeProfile(
            gender: selectedGender,
            age: selectedAge,
            weightKg: selectedWeight,
            heightCm: selectedHeight,
            goal: selectedGoal,
            activityLevel: selectedActivityLevel,
            fitnessLevel: selectedFitnessLevel,
            targetWeightKg: selectedTargetWeight,
            workoutFrequency: selectedWorkoutFrequency,
            completedProfileRegistration: isCompleted,
          );

      if (!mounted) return;

      if (isCompleted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const BottomNavBarController()),
          (route) => false,
        );
      } else {
        nextScreen;
      }
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      showTopAlert(context, message: e.toString(), type: AlertType.error);
    }
  }

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
                        onSubmit: selectedGender == ""
                            ? null
                            : () {
                                _saveProfile(
                                  selectedGender: selectedGender,
                                  nextScreen: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CollectAgeScreen(
                                          gender: selectedGender,
                                        ),
                                      ),
                                    );
                                  },
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
