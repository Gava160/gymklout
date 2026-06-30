import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool? showPop;
  final bool safeAreaTop;
  final Widget? preTitleWidget;
  final Color? backgroundColor;
  final List<Widget>? actions;
  const CustomAppBar({
    super.key,
    this.title,
    this.showPop,
    this.actions,
    this.backgroundColor,
    this.safeAreaTop = true,
    this.preTitleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool canPop = Navigator.of(context).canPop();

    return SafeArea(
      top: safeAreaTop,
      child: AppBar(
        title: Text(
          title ?? "",
          style: AppDefaults.headLiner1(context, fontWeight: FontWeight.w600)
              .copyWith(
                color: getDefaultHeaderColor(context, lightAlpha: 230),
                fontSize: (AppDefaults.headLiner1(context).fontSize ?? 21) - 4,
              ),
        ),
        backgroundColor: backgroundColor ?? Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        actions: actions,
        leading: canPop
            ? IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
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
                    Icons.chevron_left,
                    size: 30,
                    color: isDark ? AppDefaults.white : Colors.black,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
