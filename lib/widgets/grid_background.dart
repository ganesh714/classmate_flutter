import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  final Color lineColor;
  final double gridSize;

  const GridBackground({
    super.key,
    this.lineColor = const Color(0xFFCCCCCC),
    this.gridSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(lineColor: lineColor, gridSize: gridSize),
      size: Size.infinite,
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color lineColor;
  final double gridSize;

  _GridPainter({required this.lineColor, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
