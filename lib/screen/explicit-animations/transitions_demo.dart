import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class TransitionsDemo extends StatefulWidget {
  const TransitionsDemo({super.key});

  @override
  State<TransitionsDemo> createState() => _TransitionsDemoState();
}

class _TransitionsDemoState extends State<TransitionsDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _box(IconData icon, Color color) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _labeled(String label, Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 90, height: 70, child: Center(child: child)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '2. Built-in transitions',
      description: 'Four ready-made widgets driven by the same controller.',
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _labeled(
            'Fade',
            FadeTransition(
              opacity: _c, // a controller IS an Animation<double>
              child: _box(Icons.visibility, Colors.indigo),
            ),
          ),
          _labeled(
            'Slide',
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.3, 0),
                end: const Offset(0.3, 0), // fractions of the widget's own size
              ).animate(_c),
              child: _box(Icons.arrow_forward, Colors.teal),
            ),
          ),
          _labeled(
            'Scale',
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.2).animate(_c),
              child: _box(Icons.zoom_in, Colors.orange),
            ),
          ),
          _labeled(
            'Rotate',
            RotationTransition(
              turns: Tween<double>(begin: 0, end: 0.25).animate(_c),
              child: _box(Icons.refresh, Colors.pink),
            ),
          ),
        ],
      ),
    );
  }
}