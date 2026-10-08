import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class AnimatedAlignDemo extends StatefulWidget {
  const AnimatedAlignDemo({super.key});

  @override
  State<AnimatedAlignDemo> createState() => _AnimatedAlignDemoState();
}

class _AnimatedAlignDemoState extends State<AnimatedAlignDemo> {
  bool atRight = false;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '3. AnimatedAlign',
      description: 'Tap the grey area. The circle slides left and right.',
      child: GestureDetector(
        onTap: () => setState(() => atRight = !atRight),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceOut,
            alignment: atRight ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}