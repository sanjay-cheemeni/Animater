import 'package:animater/screen/widgets/demo_card.dart';
import 'package:flutter/material.dart';


class AnimatedContainerDemo extends StatefulWidget {
  const AnimatedContainerDemo({super.key});

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool big = false;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '1. AnimatedContainer',
      description: 'Tap the box. Size, color and radius animate together.',
      child: GestureDetector(
        onTap: () => setState(() => big = !big),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: big ? 140 : 80,
          height: big ? 140 : 80,
          decoration: BoxDecoration(
            color: big ? Colors.orange : Colors.blue,
            borderRadius: BorderRadius.circular(big ? 70 : 8),
          ),
        ),
      ),
    );
  }
}