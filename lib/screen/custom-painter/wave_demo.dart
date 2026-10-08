import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class WavePainter extends CustomPainter {
  final Animation<double> phase; // loops 0..1 (the sideways motion)
  final double level; // 0..1 (the water height)

  WavePainter({required this.phase, required this.level})
      : super(repaint: phase);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.save();
    canvas.clipPath(Path()..addOval(rect)); // everything below stays inside the circle

    canvas.drawRect(rect, Paint()..color = Colors.indigo.shade50);

    void wave(double amplitude, double shift, Color color) {
      final baseY = size.height * (1 - level);
      final path = Path()..moveTo(0, size.height);
      for (double x = 0; x <= size.width; x += 2) {
        final y = baseY +
            math.sin(x / size.width * 2 * math.pi +
                    phase.value * 2 * math.pi +
                    shift) *
                amplitude;
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    }

    wave(9, 0, Colors.indigo.withValues(alpha: 0.45)); // back wave
    wave(7, math.pi, Colors.indigo.withValues(alpha: 0.80)); // front wave

    canvas.restore();

    canvas.drawOval(
      rect.deflate(1.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.indigo,
    );
  }

  @override
  bool shouldRepaint(WavePainter old) =>
      old.level != level || old.phase != phase;
}

class WaveDemo extends StatefulWidget {
  const WaveDemo({super.key});

  @override
  State<WaveDemo> createState() => _WaveDemoState();
}

class _WaveDemoState extends State<WaveDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _phase;
  double _level = 0.4;

  @override
  void initState() {
    super.initState();
    _phase = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _phase.dispose();
    super.dispose();
  }

  void _change(double delta) =>
      setState(() => _level = (_level + delta).clamp(0.0, 1.0).toDouble());

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '2. Liquid wave',
      description: 'Waves loop forever. The water level animates to its new value.',
      height: 170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Two animations at once: _phase loops, the level tweens smoothly
          TweenAnimationBuilder<double>(
            tween: Tween(end: _level),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(150, 150),
                      painter: WavePainter(phase: _phase, level: value),
                    ),
                    Text(
                      '${(value * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: () => _change(0.15),
                icon: const Icon(Icons.add),
                label: const Text('Fill'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _change(-0.15),
                icon: const Icon(Icons.remove),
                label: const Text('Drain'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}