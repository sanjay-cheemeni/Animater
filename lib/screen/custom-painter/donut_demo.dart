import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

typedef Segment = (String label, double value, Color color);

class DonutPainter extends CustomPainter {
  final Animation<double> progress;
  final List<Segment> segments;

  DonutPainter(this.progress, this.segments) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 26.0;
    const gap = 0.05; // radians of space between segments
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - stroke) / 2,
    );

    final total = segments.fold<double>(0, (sum, s) => sum + s.$2);

    // Track behind the segments
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.grey.shade200,
    );

    var start = -math.pi / 2; // 12 o'clock
    var remaining = 2 * math.pi * progress.value; // how much of the circle is revealed

    for (final s in segments) {
      final full = s.$2 / total * 2 * math.pi;
      final shown = math.min(full, math.max(remaining, 0.0));
      final sweep = shown - gap;

      if (sweep > 0) {
        canvas.drawArc(
          rect,
          start + gap / 2,
          sweep,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..strokeCap = StrokeCap.butt
            ..color = s.$3,
        );
      }
      remaining -= full;
      start += full;
    }
  }

  @override
  bool shouldRepaint(DonutPainter old) =>
      old.progress != progress || old.segments != segments;
}

class DonutDemo extends StatefulWidget {
  const DonutDemo({super.key});

  @override
  State<DonutDemo> createState() => _DonutDemoState();
}

class _DonutDemoState extends State<DonutDemo>
    with SingleTickerProviderStateMixin {
  static const List<Segment> _segments = [
    ('Rent', 800, Colors.indigo),
    ('Food', 450, Colors.orange),
    ('Travel', 300, Colors.teal),
    ('Fun', 250, Colors.pink),
  ];

  late final AnimationController _c;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _progress = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _segments.fold<double>(0, (s, e) => s + e.$2);

    return DemoCard(
      title: '4. Donut chart',
      description: 'Segments sweep around one after another. Tap the chart to replay.',
      height: 170,
      child: GestureDetector(
        onTap: () => _c.forward(from: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(150, 150),
                    painter: DonutPainter(_progress, _segments),
                  ),
                  // Counting number in the middle
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${(total * _progress.value).round()}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('spent',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final s in _segments)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(color: s.$3, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text('${s.$1}  ₹${s.$2.round()}'),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}