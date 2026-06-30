import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressBadge extends StatefulWidget {
  final double progress; // 0.0 to 100.0
  final double previousProgress; // value to animate from
  final double size;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;
  final TextStyle? textStyle;
  final Duration duration;

  const CircularProgressBadge({
    super.key,
    required this.progress,
    this.previousProgress = 0,
    this.size = 80,
    this.progressColor = Colors.green,
    this.trackColor = Colors.grey,
    this.strokeWidth = 5,
    this.textStyle,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<CircularProgressBadge> createState() => _CircularProgressBadgeState();
}

class _CircularProgressBadgeState extends State<CircularProgressBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.previousProgress,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularProgressBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              progress: _animation.value / 100,
              progressColor: widget.progressColor,
              trackColor: widget.trackColor,
              strokeWidth: widget.strokeWidth,
            ),
            child: Center(
              child: Text(
                '${_animation.value.toInt()}%',
                style: widget.textStyle ??
                    TextStyle(
                      fontSize: widget.size * 0.22,
                      fontWeight: FontWeight.w700,
                      color: widget.progressColor,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    // ── Track ──
    final trackPaint = Paint()
      ..color = trackColor.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // ── Progress arc ──
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor;
}