import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';

class CustomAlertModal {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryText,
    required String secondaryText,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withAlpha(75),
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, _, _) => _IOSAlertDialog(
          title: title,
          message: message,
          primaryText: primaryText,
          secondaryText: secondaryText,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
        ),
        transitionsBuilder: (_, animation, _, child) {
          final scale = Tween<double>(begin: .82, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          );

          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }
}

class _IOSAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryText;
  final String secondaryText;

  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  const _IOSAlertDialog({
    required this.title,
    required this.message,
    required this.primaryText,
    required this.secondaryText,
    this.onPrimary,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withAlpha(55)),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 340,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(182),
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style:
                            AppDefaults.textStyle(
                              context,
                              fontWeight: FontWeight.w600,
                            ).copyWith(
                              color: Colors.black,
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                      21) +
                                  4,
                            ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style:
                            AppDefaults.textStyle(
                              context,
                              fontWeight: FontWeight.w400,
                            ).copyWith(
                              color: Colors.black.withAlpha(200),
                              fontSize:
                                  (AppDefaults.textStyle(context).fontSize ??
                                  21),
                            ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.pop(context);
                                onSecondary?.call();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                                minimumSize: const Size.fromHeight(46),
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                              child: Text(secondaryText),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.pop(context);
                                onPrimary?.call();
                              },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(46),
                                shape: const StadiumBorder(),
                                backgroundColor: AppDefaults.primaryColor,
                                foregroundColor: Colors.white,

                                elevation: 0,
                              ),
                              child: Text(primaryText),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
