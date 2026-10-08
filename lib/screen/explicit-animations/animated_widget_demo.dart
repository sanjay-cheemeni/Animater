import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

/// A reusable widget that pulses according to any Animation<double> you give it.
class PulsingDot extends AnimatedWidget {
  final Color color;

  const PulsingDot({
    super.key,
    required Animation<double> animation,
    this.color = Colors.green,
  }) : super(listenable: animation);

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final t = _animation.value; // 0.0 -> 1.0
    return Container(
      width: 20 + 20 * t,
      height: 20 + 20 * t,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 1.0 - 0.6 * t),
      ),
    );
  }
}

class AnimatedWidgetDemo extends StatefulWidget {
  const AnimatedWidgetDemo({super.key});

  @override
  State<AnimatedWidgetDemo> createState() => _AnimatedWidgetDemoState();
}

class _AnimatedWidgetDemoState extends State<AnimatedWidgetDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeInOut);

    return DemoCard(
      title: '7. AnimatedWidget',
      description: 'One reusable widget, three different colors, one controller.',
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PulsingDot(animation: curved, color: Colors.green),
          PulsingDot(animation: curved, color: Colors.orange),
          PulsingDot(animation: curved, color: Colors.purple),
        ],
      ),
    );
  }
}