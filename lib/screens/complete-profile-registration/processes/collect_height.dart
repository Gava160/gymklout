import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/processes/collect_goal.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/num_picker_drum.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/save_details.dart';

class CollectHeightScreen extends ConsumerStatefulWidget {
  const CollectHeightScreen({
    super.key,
    required this.gender,
    required this.age,
    required this.weight,
    required this.targetWeight,
  });
  final String gender;
  final int age;
  final double weight;
  final double targetWeight;

  @override
  ConsumerState<CollectHeightScreen> createState() =>
      _CollectHeightScreenState();
}

class _CollectHeightScreenState extends ConsumerState<CollectHeightScreen> {
  int selectedHeight = 100;

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
                  child: SizedBox(
                    height: size.height * 0.70,
                    child: Padding(
                      padding: AppDefaults.defaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProcessheaderWidget(
                            header: "What's your height?",
                            subHeader: "You can always change this later.",
                          ),
                          SizedBox(height: 30),

                          NumberPickerDrum(
                            minValue: 50,
                            maxValue: 350,
                            label: "cm",
                            initialValue: selectedHeight,
                            onChanged: (value) {
                              HapticFeedback.lightImpact();
                              setState(() => selectedHeight = value);
                            },
                          ),
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
                        onSubmit: () {
                          HapticFeedback.selectionClick();
                          saveProfile(
                            ref: ref,
                            context: context,
                            selectedGender: widget.gender,
                            selectedAge: widget.age,
                            selectedWeight: widget.weight,
                            selectedTargetWeight: widget.targetWeight,
                            selectedHeight: selectedHeight.toDouble(),
                            onDone: () {},
                            nextScreen: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CollectGoalScreen(
                                    gender: widget.gender,
                                    age: widget.age,
                                    weight: widget.weight,
                                    targetWeight: widget.targetWeight,
                                    height: selectedHeight,
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
