import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymklout/app-settings/app_data.dart';

class GradientCircularAvatar extends StatelessWidget {
  final String imagePath;
  final double progress; // 0.0 to 1.0
  final double size;

  const GradientCircularAvatar({
    super.key,
    required this.imagePath,
    required this.progress,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 👇 gradient progress ring
          CustomPaint(
            size: Size(size, size),
            painter: _GradientRingPainter(progress: progress),
          ),

          // 👇 profile image inside
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imagePath,
              cacheKey: imagePath,
              width: size * 0.7,
              height: size * 0.7,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                // print(imagePath);
                return CircleAvatar(
                  radius: size * 0.35,
                  backgroundColor: AppDefaults.textColor.withAlpha(20),
                  child: showSpinner(),
                );
              },
              errorWidget: (context, url, error) => CircleAvatar(
                radius: size * 0.35,
                backgroundColor: AppDefaults.textColor.withAlpha(20),
                child: const Icon(Icons.person, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double progress;

  _GradientRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 3.0;

    // dark background ring
    final bgPaint = Paint()
      ..color = Colors.white.withAlpha(20)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // gradient progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -1.5708, // start from top (-90 degrees in radians)
      endAngle: -1.5708 + (3.1416 * 2), // full circle
      colors: [
        Color(0xFF3B82F6), //
        AppDefaults.primaryColor,
        AppDefaults.primaryColor,
      ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -1.5708, // start from top
      3.1416 * 2 * progress, // sweep angle based on progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_GradientRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
