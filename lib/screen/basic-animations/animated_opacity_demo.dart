import 'package:animater/screen/widgets/demo_card.dart';
import 'package:flutter/material.dart';


class AnimatedOpacityDemo extends StatefulWidget {
  const AnimatedOpacityDemo({super.key});

  @override
  State<AnimatedOpacityDemo> createState() => _AnimatedOpacityDemoState();
}

class _AnimatedOpacityDemoState extends State<AnimatedOpacityDemo> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '2. AnimatedOpacity',
      description: 'Fades a widget between invisible (0.0) and visible (1.0).',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: const FlutterLogo(size: 70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => visible = !visible),
            child: Text(visible ? 'Fade out' : 'Fade in'),
          ),
        ],
      ),
    );
  }
}