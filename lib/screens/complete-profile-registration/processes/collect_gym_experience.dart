import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/processes/collect_workout_frequency.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/custom_text_selector.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_appbar.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';

class CollectGymExperienceScreen extends ConsumerStatefulWidget {
  const CollectGymExperienceScreen({
    super.key,
    required this.gender,
    required this.age,
    required this.weight,
    required this.gymGoal,
    required this.height,
    required this.targetWeight,
  });
  final String gender;
  final String gymGoal;
  final int height;
  final int age;
  final double weight;
  final double targetWeight;

  @override
  ConsumerState<CollectGymExperienceScreen> createState() =>
      _CollectGymExperienceScreenState();
}

class _CollectGymExperienceScreenState
    extends ConsumerState<CollectGymExperienceScreen> {
  String selectedLevel = 'Intermediate';
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
            child:  ProcessAppbar(
              title: "",
              progressValue: 84,
              progressPreviousValue: 75,
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
                  child: SizedBox(
                    height: size.height * 0.60,
                    child: Padding(
                      padding: AppDefaults.defaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProcessheaderWidget(
                            header:
                                "What's your regular fitness activity level?",
                            subHeader: "This helps personalize your plan.",
                          ),
                          SizedBox(height: 30),
                          Spacer(),
                          SizedBox(
                            width: size.width * 0.80,
                            child: Center(
                              child: CustomTextSelectorWidget(
                                goals: const [
                                  'Rookie',
                                  'Beginner',
                                  'Intermediate',
                                  'Advance',
                                  'True Beast',
                                ],
                                initialIndex: 0,
                                onChanged: (goal) {
                                  HapticFeedback.lightImpact();
                                  setState(() => selectedLevel = goal);
                                },
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
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
                          HapticFeedback.selectionClick();
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
                        onSubmit: () {
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CollectWorkoutFrequencyScreen(
                                    gender: widget.gender,
                                    age: widget.age,
                                    weight: widget.weight,
                                    height: widget.height,
                                    gymGoal: widget.gymGoal,
                                    targetWeight: widget.targetWeight,
                                    activityLevel: selectedLevel,
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
