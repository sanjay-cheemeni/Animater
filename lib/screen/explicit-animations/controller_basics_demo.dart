import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class ControllerBasicsDemo extends StatefulWidget {
  const ControllerBasicsDemo({super.key});

  @override
  State<ControllerBasicsDemo> createState() => _ControllerBasicsDemoState();
}

class _ControllerBasicsDemoState extends State<ControllerBasicsDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Alignment> _position;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _position = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '1. Controller basics',
      description: 'Use the buttons, or drag the slider to scrub manually.',
      height: 280,
      // Rebuilds this whole subtree every frame the controller ticks.
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'value: ${_c.value.toStringAsFixed(2)}    '
                'status: ${_c.status.name}',
              ),
              Slider(
                value: _c.value,
                onChanged: (v) => _c.value = v, // set the clock directly
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Align(
                  alignment: _position.value,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _c.forward(), child: const Text('forward')),
                  ElevatedButton(
                      onPressed: () => _c.reverse(), child: const Text('reverse')),
                  ElevatedButton(
                      onPressed: () => _c.repeat(reverse: true),
                      child: const Text('repeat')),
                  ElevatedButton(
                      onPressed: () => _c.stop(), child: const Text('stop')),
                  ElevatedButton(
                      onPressed: () => _c.reset(), child: const Text('reset')),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}