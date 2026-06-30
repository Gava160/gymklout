import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/alerts/alerts_custom.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/progress_badge.dart';

class ProcessAppbar extends StatelessWidget {
  final String? title;
  final bool? showPop;
  final bool safeAreaTop;
  final Widget? preTitleWidget;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final double progressValue;
  final double progressPreviousValue;

  const ProcessAppbar({
    super.key,
    this.title,
    this.showPop,
    this.actions,
    this.backgroundColor,
    this.safeAreaTop = true,
    this.preTitleWidget,
    required this.progressPreviousValue,
    required this.progressValue
  });

  void _closeProcess(BuildContext context) {
    CustomAlertModal.show(
      context: context,
      title: 'Leave Setup?',
      message:
          'Your progress won\'t be saved if you leave now. You can complete your profile anytime from your account settings.',
      primaryText: 'Continue Setup',
      secondaryText: 'Leave',
      onPrimary: () {
        // stay — do nothing
      },
      onSecondary: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: safeAreaTop,
      child: AppBar(
        title: Text(
          title ?? "",
          style: AppDefaults.headLine3(context).copyWith(
            color: isDark
                ? AppDefaults.white
                : AppDefaults.headLine3(context).color,
            fontSize: (AppDefaults.textStyle((context)).fontSize ?? 16) + 2,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: backgroundColor ?? Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        actions: [
          CircularProgressBadge(
            previousProgress: progressPreviousValue,
            progress: progressValue,
            size: 50,
            progressColor: AppDefaults.primaryColor,
            trackColor: AppDefaults.textColor,
            strokeWidth: 5,
          ),
        ],
        leading: IconButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            _closeProcess(context);
          },
          icon: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isDark
                  ? AppDefaults.white.withAlpha(20)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                strokeAlign: 1,
                color: Colors.black.withAlpha(20),
              ),
            ),
            child: Icon(
              Icons.close,
              size: 30,
              color: isDark ? AppDefaults.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
