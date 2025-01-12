import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurvedCircularProgress extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color color;
  final double textSize;

  const CurvedCircularProgress({
    super.key,
    required this.progress,
    required this.strokeWidth,
    required this.color,
    this.textSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(30.w, 30.w),
      painter: _ProgressPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        color: color,
        textSize: textSize,
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final double textSize;

  _ProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.textSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Circle bounds
    final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    // Draw the background circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        backgroundPaint);

    // Draw the progress arc
    final double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
        rect, -3.141592653589793 / 2, sweepAngle, false, progressPaint);

    // Add the percentage text inside the circle
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          fontSize: textSize.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint if the progress is static
  }
}
