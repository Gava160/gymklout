import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymklout/app-settings/app_data.dart';

enum AlertType { success, error, info, warning }

void showTopAlert(
  BuildContext context, {
  required String message,
  AlertType type = AlertType.success,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => _TopAlertWidget(
      message: message,
      type: type,
      duration: duration,
    ),
  );

  overlay.insert(entry);

  Future.delayed(duration + const Duration(milliseconds: 350), () {
    if (entry.mounted) entry.remove();
  });
}

class _TopAlertWidget extends StatefulWidget {
  final String message;
  final AlertType type;
  final Duration duration;

  const _TopAlertWidget({
    required this.message,
    required this.type,
    required this.duration,
  });

  @override
  State<_TopAlertWidget> createState() => _TopAlertWidgetState();
}

class _TopAlertWidgetState extends State<_TopAlertWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    // Slide back out before removal
    Future.delayed(widget.duration, () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _AlertConfig get _config => switch (widget.type) {
        AlertType.success => _AlertConfig(
            icon: Icons.check_circle_rounded,
            color: AppDefaults.successColor,
            label: 'Success',
          ),
        AlertType.error => _AlertConfig(
            icon: Icons.cancel_rounded,
            color: AppDefaults.errorColor,
            label: 'Error',
          ),
        AlertType.warning => _AlertConfig(
            icon: Icons.warning_rounded,
            color: AppDefaults.secondaryColor,
            label: 'Warning',
          ),
        AlertType.info => _AlertConfig(
            icon: Icons.info_rounded,
            color: AppDefaults.primaryColor,
            label: 'Info',
          ),
      };

  @override
  Widget build(BuildContext context) {
    final config = _config;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppDefaults.darkBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: config.color.withAlpha(80),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: config.color.withAlpha(40),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      // ── Colored icon pill ──
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: config.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          config.icon,
                          color: config.color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ── Text ──
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              config.label,
                              style: AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w700,
                              ).copyWith(
                                color: config.color,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.message,
                              style: AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w400,
                              ).copyWith(
                                color: AppDefaults.white.withAlpha(200),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ── Accent bar ──
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 36,
                        decoration: BoxDecoration(
                          color: config.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertConfig {
  final IconData icon;
  final Color color;
  final String label;

  const _AlertConfig({
    required this.icon,
    required this.color,
    required this.label,
  });
}