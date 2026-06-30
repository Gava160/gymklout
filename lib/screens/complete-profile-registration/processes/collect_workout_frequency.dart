import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/custom_text_selector.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_appbar.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/save_details.dart';

class CollectWorkoutFrequencyScreen extends ConsumerStatefulWidget {
  const CollectWorkoutFrequencyScreen({
    super.key,
    required this.gender,
    required this.age,
    required this.weight,
    required this.gymGoal,
    required this.height,
    required this.targetWeight,
    required this.activityLevel,
  });
  final String gender;
  final String gymGoal;
  final int height;
  final int age;
  final double weight;
  final double targetWeight;
  final String activityLevel;

  @override
  ConsumerState<CollectWorkoutFrequencyScreen> createState() =>
      _CollectWorkoutFrequencyScreenState();
}

class _CollectWorkoutFrequencyScreenState
    extends ConsumerState<CollectWorkoutFrequencyScreen> {
  late String selectedFrequency;
  bool isSubmitting = false;

  int workoutFrequencyFromString(String value) {
    const map = {
      '1 day a week': 1,
      '2 days a week': 2,
      '3 days a week': 3,
      '4 days a week': 4,
      '5 days a week': 5,
      '6 days a week': 6,
      'Every day': 7,
    };
    return map[value] ?? 1;
  }

  @override
  void initState() {
    super.initState();
    selectedFrequency = '3 days a week';
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
              progressValue: 91,
              progressPreviousValue: 84,
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
                            header: "How many days a week do you train?",
                            subHeader:
                                "Whether it's your first week or your fifth year, \nwe'll build around your schedule.",
                          ),
                          SizedBox(height: 30),
                          Spacer(),
                          SizedBox(
                            width: size.width * 0.80,
                            child: Center(
                              child: CustomTextSelectorWidget(
                                goals: const [
                                  '1 day a week',
                                  '2 days a week',
                                  '3 days a week',
                                  '4 days a week',
                                  '5 days a week',
                                  '6 days a week',
                                  'Every day',
                                ],
                                initialIndex: 0,
                                onChanged: (goal) {
                                  HapticFeedback.lightImpact();
                                  setState(() => selectedFrequency = goal);
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
                          setState(() => isSubmitting = true);
                          saveProfile(
                            ref: ref,
                            context: context,
                            selectedGender: widget.gender,
                            selectedAge: widget.age,
                            selectedWeight: widget.weight,
                            selectedTargetWeight: widget.targetWeight,
                            selectedHeight: widget.height.toDouble(),
                            selectedActivityLevel: null,
                            selectedFitnessLevel: fitnessLevelToBackendValue(
                              widget.activityLevel,
                            ),
                            selectedGoal: goalToBackendValue(widget.gymGoal),
                            selectedWorkoutFrequency:
                                workoutFrequencyFromString(selectedFrequency),
                            onDone: () => setState(() => isSubmitting = false),
                            nextScreen: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CollectWorkoutFrequencyScreen(
                                    gender: widget.gender,
                                    age: widget.age,
                                    weight: widget.weight,
                                    height: widget.height,
                                    gymGoal: widget.gymGoal,
                                    targetWeight: widget.targetWeight,
                                    activityLevel: widget.activityLevel,
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
