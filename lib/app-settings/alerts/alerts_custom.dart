import 'dart:ui';

import 'package:flutter/material.dart';

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
          final scale = Tween<double>(
            begin: .82,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
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
              filter: ImageFilter.blur(
                sigmaX: 12,
                sigmaY: 12,
              ),
              child: Container(
                color: Colors.black.withAlpha(65),
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onSecondary?.call();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                                minimumSize: const Size.fromHeight(56),
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
                                Navigator.pop(context);
                                onPrimary?.call();
                              },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: const StadiumBorder(),
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

// IOSAlert.show(
//   context: context,
//   title: 'Allow "R↧Download" to connect to "snapvid.net"?',
//   message:
//       'This might allow "R↧Download" to share content with "snapvid.net" and potentially other websites.',
//   primaryText: 'Allow',
//   secondaryText: "Don't Allow",
//   onPrimary: () {
//     debugPrint('Allowed');
//   },
//   onSecondary: () {
//     debugPrint('Denied');
//   },
// );