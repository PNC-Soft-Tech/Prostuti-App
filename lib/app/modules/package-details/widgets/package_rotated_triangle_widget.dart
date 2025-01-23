import 'package:flutter/material.dart';

class RotatedTriangle extends StatelessWidget {
  final double size;
  final double rotationAngle; // Rotation in radians
  final Color color;

  RotatedTriangle({
    required this.size,
    required this.rotationAngle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationAngle,
      child: CustomPaint(
        size: Size(size, size),
        painter: TrianglePainter(color: color),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Define the triangle points
    final path = Path();
    path.moveTo(size.width / 2, 0); // Top center
    path.lineTo(0, size.height); // Bottom left
    path.lineTo(size.width, size.height); // Bottom right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

