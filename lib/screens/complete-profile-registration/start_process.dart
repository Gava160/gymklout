import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/gender_selector.dart';

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

class _CompleteProfileStarterContainer extends StatefulWidget {
  const _CompleteProfileStarterContainer();

  @override
  State<_CompleteProfileStarterContainer> createState() =>
      __CompleteProfileStarterContainerState();
}

class __CompleteProfileStarterContainerState
    extends State<_CompleteProfileStarterContainer> {
  final TextEditingController emailController = TextEditingController();
  bool isSubmitting = false;
  bool buttonIsEnabled = false;
  String selectedGender = "male";

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
                        SizedBox(
                          width: size.width * 0.90,
                          child: Text(
                            "Tell us about yourself",
                            style:
                                AppDefaults.headLiner1(
                                  context,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(
                                  color: getDefaultHeaderColor(context),
                                  fontSize:
                                      (AppDefaults.headLiner1(
                                        context,
                                      ).fontSize ??
                                      21),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 7),
                        SizedBox(
                          width: size.width * 0.80,
                          child: Text(
                            "To give you better experiences, we need to know your gender",
                            style:
                                AppDefaults.textStyle(
                                  context,
                                  fontWeight: FontWeight.w400,
                                ).copyWith(
                                  color: getDefaultHeaderColor(
                                    context,
                                    lightAlpha: 200,
                                  ),
                                  fontSize:
                                      (AppDefaults.textStyle(
                                        context,
                                      ).fontSize ??
                                      21),
                                ),
                            textAlign: TextAlign.center,
                          ),
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
                        SizedBox(height: 10),
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
                        onSubmit: () {},
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

class CustomButtonAuth {}
