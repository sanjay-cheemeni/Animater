import 'package:flutter/material.dart';
import 'bubbles_demo.dart';
import 'checkmark_demo.dart';
import 'clock_demo.dart';
import 'donut_demo.dart';
import 'line_chart_demo.dart';
import 'shapes_demo.dart';
import 'wave_demo.dart';

class CustomPainterScreen extends StatelessWidget {
  const CustomPainterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ShapesDemo(),
          WaveDemo(),
          LineChartDemo(),
          DonutDemo(),
          BubblesDemo(),
          ClockDemo(),
          CheckmarkDemo(),
        ],
      ),
    );
  }
}