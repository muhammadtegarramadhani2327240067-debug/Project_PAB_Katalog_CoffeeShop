import 'package:flutter/material.dart';

class CoffeLogo extends StatelessWidget {
  final Color color;
  final double width;

  const CoffeLogo({
    super.key,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.78,
      child: CustomPaint(
        painter: _CoffeeLogoPainter(color: color),
      ),
    );
  }
}

class _CoffeeLogoPainter extends CustomPainter {
  final Color color;
  const _CoffeeLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    void steam(double x) {
      final p = Path()
        ..moveTo(x, size.height * 0.18)
        ..cubicTo(
          x - size.width * 0.05,
          size.height * 0.28,
          x + size.width * 0.06,
          size.height * 0.32,
          x,
          size.height * 0.42,
        );
      canvas.drawPath(p, stroke);
    }

    steam(size.width * 0.40);
    steam(size.width * 0.52);
    steam(size.width * 0.64);

    final cup = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.46,
        size.width * 0.58,
        size.height * 0.40,
      ),
      Radius.circular(size.width * 0.10),
    );

    final handleOuter = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.72,
        size.height * 0.52,
        size.width * 0.20,
        size.height * 0.22,
      ),
      Radius.circular(size.width * 0.12),
    );

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRRect(cup, fill);
    canvas.drawRRect(handleOuter, fill);

    final holePaint = Paint()..blendMode = BlendMode.clear;
    final hole = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.76,
        size.height * 0.56,
        size.width * 0.12,
        size.height * 0.14,
      ),
      Radius.circular(size.width * 0.10),
    );
    canvas.drawRRect(hole, holePaint);
    canvas.restore();

    final base = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.88,
        size.width * 0.70,
        size.height * 0.08,
      ),
      Radius.circular(size.width * 0.06),
    );
    canvas.drawRRect(base, fill);
  }

  @override
  bool shouldRepaint(covariant _CoffeeLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
