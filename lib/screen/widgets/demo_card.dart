import 'package:flutter/material.dart';

class DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final double height;

  const DemoCard({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,

      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            SizedBox(
              height: height,
              width: double.infinity,
              child: Center(child: child),
            ),
          ],
        ),
      ),
    );
  }
}
