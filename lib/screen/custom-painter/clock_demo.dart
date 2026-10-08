import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class ClockPainter extends CustomPainter {
  ClockPainter(Listenable tick) : super(repaint: tick);

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 4;

    // Face
    canvas.drawCircle(c, r, Paint()..color = Colors.white);
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.indigo,
    );

    // 60 tick marks (longer and thicker every 5th)
    for (var i = 0; i < 60; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / 60;
      final dir = Offset(math.cos(a), math.sin(a));
      final major = i % 5 == 0;
      canvas.drawLine(
        c + dir * (r - (major ? 14 : 8)),
        c + dir * (r - 3),
        Paint()
          ..strokeWidth = major ? 3 : 1.2
          ..strokeCap = StrokeCap.round
          ..color = major ? Colors.indigo : Colors.grey,
      );
    }

    // Numbers: text on a canvas needs a TextPainter
    for (final n in [12, 3, 6, 9]) {
      final a = -math.pi / 2 + n * 2 * math.pi / 12;
      final pos = c + Offset(math.cos(a), math.sin(a)) * (r - 28);
      final tp = TextPainter(
        text: TextSpan(
          text: '$n',
          style: const TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }

    // Time as fractions, so the hands move smoothly (not in jumps)
    final sec = now.second + now.millisecond / 1000;
    final min = now.minute + sec / 60;
    final hour = (now.hour % 12) + min / 60;

    void hand(double fraction, double length, double width, Color color,
        {double tail = 0}) {
      final a = -math.pi / 2 + fraction * 2 * math.pi;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
        c - dir * tail,
        c + dir * length,
        Paint()
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }

    hand(hour / 12, r * 0.50, 6, Colors.black87);
    hand(min / 60, r * 0.75, 4, Colors.black87);
    hand(sec / 60, r * 0.85, 2, Colors.red, tail: 14);

    canvas.drawCircle(c, 6, Paint()..color = Colors.red);
    canvas.drawCircle(c, 2.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(ClockPainter old) => false;
}

class ClockDemo extends StatefulWidget {
  const ClockDemo({super.key});

  @override
  State<ClockDemo> createState() => _ClockDemoState();
}

class _ClockDemoState extends State<ClockDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tick;

  @override
  void initState() {
    super.initState();
    // The value is ignored. We only use the controller as a 60 fps heartbeat.
    _tick = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _tick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '6. Analog clock',
      description: 'Reads DateTime.now() every frame. Smooth second hand.',
      height: 200,
      child: SizedBox(
        width: 200,
        height: 200,
        child: RepaintBoundary(
          child: CustomPaint(painter: ClockPainter(_tick)),
        ),
      ),
    );
  }
}