import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class StaggeredListDemo extends StatefulWidget {
  const StaggeredListDemo({super.key});

  @override
  State<StaggeredListDemo> createState() => _StaggeredListDemoState();
}

class _StaggeredListDemoState extends State<StaggeredListDemo>
    with SingleTickerProviderStateMixin {
  static const _items = [
    (Icons.home, 'Home'),
    (Icons.search, 'Search'),
    (Icons.notifications, 'Notifications'),
    (Icons.person, 'Profile'),
    (Icons.settings, 'Settings'),
  ];

  late final AnimationController _c;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _anims = List.generate(_items.length, (i) {
      final start = i * 0.12;        // each item starts a bit later
      final end = start + 0.4;       // and takes 40% of the total time
      return CurvedAnimation(
        parent: _c,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '6. Staggered list',
      description: 'Each row uses the same controller with a shifted Interval.',
      height: 330,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _items.length; i++)
            FadeTransition(
              opacity: _anims[i],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(_anims[i]),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(_items[i].$1, size: 20, color: Colors.indigo),
                      const SizedBox(width: 12),
                      Text(_items[i].$2),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _c.forward(from: 0),
            child: const Text('Replay'),
          ),
        ],
      ),
    );
  }
}