import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class LineChartPainter extends CustomPainter {
  final Animation<double> progress; // 0..1
  final List<double> data; // each value 0..1

  LineChartPainter(this.progress, this.data) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 12.0;
    final chart = Rect.fromLTWH(pad, pad, size.width - pad * 2, size.height - pad * 2);

    // Grid
    final grid = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), grid);
    }

    // Data values -> pixel positions
    final pts = [
      for (var i = 0; i < data.length; i++)
        Offset(
          chart.left + chart.width * i / (data.length - 1),
          chart.bottom - chart.height * data[i],
        ),
    ];

    // Smooth curve through the points
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final a = pts[i];
      final b = pts[i + 1];
      final midX = (a.dx + b.dx) / 2;
      path.cubicTo(midX, a.dy, midX, b.dy, b.dx, b.dy);
    }

    if (progress.value <= 0.001) return;

    // Measure the path, then keep only the first `progress` part of it
    final metric = path.computeMetrics().first;
    final length = metric.length * progress.value;
    final drawn = metric.extractPath(0, length);
    final tip = metric.getTangentForOffset(length);

    if (tip != null) {
      // Gradient fill under the visible part of the line
      final fill = Path.from(drawn)
        ..lineTo(tip.position.dx, chart.bottom)
        ..lineTo(pts.first.dx, chart.bottom)
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.withValues(alpha: 0.35),
              Colors.indigo.withValues(alpha: 0.0),
            ],
          ).createShader(chart),
      );
    }

    canvas.drawPath(
      drawn,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.indigo,
    );

    // Dot at the tip
    if (tip != null) {
      canvas.drawCircle(tip.position, 8, Paint()..color = Colors.indigo.withValues(alpha: 0.25));
      canvas.drawCircle(tip.position, 5, Paint()..color = Colors.white);
      canvas.drawCircle(
        tip.position,
        5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.indigo,
      );
    }
  }

  @override
  bool shouldRepaint(LineChartPainter old) =>
      old.data != data || old.progress != progress;
}

class LineChartDemo extends StatefulWidget {
  const LineChartDemo({super.key});

  @override
  State<LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends State<LineChartDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _progress;
  final _rand = math.Random();
  List<double> _data = [0.2, 0.5, 0.35, 0.7, 0.55, 0.9, 0.65];

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _progress = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _newData() {
    setState(() {
      _data = List.generate(7, (_) => 0.15 + _rand.nextDouble() * 0.8);
    });
    _c.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '3. Line chart that draws itself',
      description: 'PathMetric extracts the first N% of the curve each frame.',
      height: 230,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CustomPaint(painter: LineChartPainter(_progress, _data)),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _newData,
            icon: const Icon(Icons.refresh),
            label: const Text('New data'),
          ),
        ],
      ),
    );
  }
}