import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class CheckPainter extends CustomPainter {
  final Animation<double> progress; // 0..1

  CheckPainter(this.progress) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.value;

    // Phase 1: 0.0 -> 0.6 draws the circle. Phase 2: 0.6 -> 1.0 draws the check.
    final circleT = (p / 0.6).clamp(0.0, 1.0).toDouble();
    final checkT = ((p - 0.6) / 0.4).clamp(0.0, 1.0).toDouble();

    final w = size.width;
    final h = size.height;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.green;

    // Soft green fill that appears with the check
    canvas.drawCircle(
      size.center(Offset.zero),
      w / 2 - 4,
      Paint()..color = Colors.green.withValues(alpha: 0.12 * checkT),
    );

    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h).deflate(4),
      -math.pi / 2,
      2 * math.pi * circleT,
      false,
      stroke,
    );

    if (checkT > 0) {
      final check = Path()
        ..moveTo(w * 0.28, h * 0.52)
        ..lineTo(w * 0.44, h * 0.68)
        ..lineTo(w * 0.74, h * 0.36);

      final metric = check.computeMetrics().first;
      canvas.drawPath(metric.extractPath(0, metric.length * checkT), stroke);
    }
  }

  @override
  bool shouldRepaint(CheckPainter old) => old.progress != progress;
}

class CheckmarkDemo extends StatefulWidget {
  const CheckmarkDemo({super.key});

  @override
  State<CheckmarkDemo> createState() => _CheckmarkDemoState();
}

class _CheckmarkDemoState extends State<CheckmarkDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '7. Animated checkmark',
      description: 'Tap to replay. Two phases from one controller.',
      height: 150,
      child: GestureDetector(
        onTap: () => _c.forward(from: 0),
        child: SizedBox(
          width: 110,
          height: 110,
          child: CustomPaint(painter: CheckPainter(_c)),
        ),
      ),
    );
  }
}