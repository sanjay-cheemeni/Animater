import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class _Bubble {
  final double x; // 0..1 across the width
  final double radius;
  final int cycles; // whole number of rises per loop (keeps the loop seamless)
  final double phase; // 0..1 starting offset
  final double sway; // pixels of side-to-side drift
  const _Bubble(this.x, this.radius, this.cycles, this.phase, this.sway);
}

class BubblesPainter extends CustomPainter {
  final Animation<double> t;
  final List<_Bubble> bubbles;

  BubblesPainter(this.t, this.bubbles) : super(repaint: t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      // p goes 0 -> 1 as the bubble rises from the bottom to the top
      final p = (t.value * b.cycles + b.phase) % 1.0;

      final y = size.height + b.radius - p * (size.height + b.radius * 2);
      final x = b.x * size.width +
          math.sin(p * 2 * math.pi * 2 + b.phase * 10) * b.sway;

      // Fade in at the bottom and out at the top
      final fade = math.sin(p * math.pi);

      final center = Offset(x, y);
      canvas.drawCircle(
        center,
        b.radius,
        Paint()..color = Colors.white.withValues(alpha: 0.18 * fade),
      );
      canvas.drawCircle(
        center,
        b.radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = Colors.white.withValues(alpha: 0.55 * fade),
      );
      // Little highlight
      canvas.drawCircle(
        center + Offset(-b.radius * 0.35, -b.radius * 0.35),
        b.radius * 0.18,
        Paint()..color = Colors.white.withValues(alpha: 0.7 * fade),
      );
    }
  }

  @override
  bool shouldRepaint(BubblesPainter old) => false; // repaint is driven by `t`
}

class BubblesDemo extends StatefulWidget {
  const BubblesDemo({super.key});

  @override
  State<BubblesDemo> createState() => _BubblesDemoState();
}

class _BubblesDemoState extends State<BubblesDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..repeat();

    // Generated ONCE. Never create random objects inside paint().
    final r = math.Random(3);
    _bubbles = List.generate(3, (_) {
      return _Bubble(
        r.nextDouble(),
        3 + r.nextDouble() * 12,
        1 + r.nextInt(3),
        r.nextDouble(),
        4 + r.nextDouble() * 14,
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '5. Floating bubbles',
      description: '40 particles from one controller, no per-bubble widgets.',
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF283593), Color(0xFF00ACC1)],
            ),
          ),
          child: RepaintBoundary(
            child: CustomPaint(painter: BubblesPainter(_c, _bubbles)),
          ),
        ),
      ),
    );
  }
}