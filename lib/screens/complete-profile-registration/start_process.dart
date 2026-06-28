import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';

Future<void> startCompleteRegistration(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 1,
      maxChildSize: 1,
      builder: (_, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
        child: _ForgotPasswordContainer(),
      ),
    ),
  );
}

class _ForgotPasswordContainer extends StatefulWidget {
  const _ForgotPasswordContainer();

  @override
  State<_ForgotPasswordContainer> createState() =>
      _ForgotPasswordContainerState();
}

class _ForgotPasswordContainerState extends State<_ForgotPasswordContainer> {
  final TextEditingController emailController = TextEditingController();
  bool isSubmitting = false;
  bool buttonIsEnabled = false;

  @override
  void initState() {
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
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
                        
                       
                      ],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: AppDefaults.defaultPadding,
              //   child: CustomButtonAuth(
              //     noPadding: true,
              //     onSubmit: isSubmitting
              //         ? null
              //         : buttonIsEnabled == false
              //         ? null
              //         : () async {
              //             HapticFeedback.selectionClick();
              //             FocusScope.of(context).unfocus();
              //             // await loginAccount();
              //           },
              //     label: isSubmitting
              //         ? AppDefaults.myButtonLoading
              //         : Text(
              //             "Send OTP",
              //             style: AppDefaults.defaultButtonStyle(context),
              //           ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonAuth {
}
