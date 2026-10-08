import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class ExplicitSpinnerDemo extends StatefulWidget {
  const ExplicitSpinnerDemo({super.key});

  @override
  State<ExplicitSpinnerDemo> createState() => _ExplicitSpinnerDemoState();
}

class _ExplicitSpinnerDemoState extends State<ExplicitSpinnerDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Tween maps the controller's 0.0 -> 1.0 into 0 -> 2π radians (one full turn)
    _rotation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // always clean up the controller
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_controller.isAnimating) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '7. Explicit: AnimationController',
      description: 'You control it: start, stop, repeat.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _rotation,
            builder: (context, child) =>
                Transform.rotate(angle: _rotation.value, child: child),
            child: const FlutterLogo(size: 70), // built once, reused every frame
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _toggle,
            child: Text(_controller.isAnimating ? 'Stop' : 'Start'),
          ),
        ],
      ),
    );
  }
}