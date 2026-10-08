import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class ShapesPainter extends CustomPainter {
  final Animation<double> t; // 0..1, loops

  // `repaint: t` = "call paint() every time t changes"
  ShapesPainter(this.t) : super(repaint: t);

  Path _star(double outer, double inner, int points) {
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outer : inner;
      final angle = -math.pi / 2 + i * math.pi / points;
      final p = Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Filled circle
    canvas.drawCircle(
      Offset(w * 0.14, h * 0.28),
      24,
      Paint()..color = Colors.indigo,
    );

    // 2. Stroked rounded rectangle
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.14, h * 0.74), width: 64, height: 34),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.teal,
    );

    // 3. A divider line
    canvas.drawLine(
      Offset(w * 0.28, h * 0.1),
      Offset(w * 0.28, h * 0.9),
      Paint()
        ..color = Colors.grey.shade400
        ..strokeWidth = 1.5,
    );

    // 4. Spinning, pulsing star
    final center = Offset(w * 0.6, h * 0.5);
    canvas.save(); // remember the canvas state
    canvas.translate(center.dx, center.dy); // move the origin to the star center
    canvas.rotate(t.value * 2 * math.pi);
    canvas.scale(1 + 0.15 * math.sin(t.value * 4 * math.pi));
    canvas.drawPath(
      _star(44, 20, 5),
      Paint()
        ..shader = const LinearGradient(
          colors: [Colors.orange, Colors.pink],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 44)),
    );
    canvas.restore(); // undo translate, rotate and scale

    // 5. A dot orbiting the star (drawn after restore, so normal coordinates)
    final a = -t.value * 2 * math.pi;
    canvas.drawCircle(
      center + Offset(math.cos(a), math.sin(a)) * 62,
      6,
      Paint()..color = Colors.amber,
    );
  }

  @override
  bool shouldRepaint(ShapesPainter old) => old.t != t;
}

class ShapesDemo extends StatefulWidget {
  const ShapesDemo({super.key});

  @override
  State<ShapesDemo> createState() => _ShapesDemoState();
}

class _ShapesDemoState extends State<ShapesDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '1. Shapes and transforms',
      description: 'Circle, rounded rect, line, and a star using save/rotate/restore.',
      height: 170,
      child: SizedBox(
        width: double.infinity,
        height: 170,
        child: CustomPaint(painter: ShapesPainter(_c)),
      ),
    );
  }
}