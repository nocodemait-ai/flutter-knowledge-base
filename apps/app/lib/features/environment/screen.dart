import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ParticleController extends StateNotifier<Offset> {
  ParticleController() : super(Offset.zero);
  void updateFlow(Offset offset) => state = offset;
}

final particleProvider = StateNotifierProvider<ParticleController, Offset>((ref) => ParticleController());

class AmbientVisualizationScreen extends ConsumerWidget {
  const AmbientVisualizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(particleProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: GestureDetector(
        onPanUpdate: (details) => ref.read(particleProvider.notifier).updateFlow(details.localPosition),
        child: Stack(
          children: [
            CustomPaint(painter: ParticlePainter(flow), size: Size.infinite),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['Temp: 22°C', 'Hum: 45%', 'Lux: 400'].map((val) => GestureDetector(
                        onTap: () => _showAnalytics(context, val),
                        child: Chip(label: Text(val, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.white12),
                      )).toList(),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ['Focus', 'Relax', 'Energy'].map((mood) => ElevatedButton(onPressed: () {}, child: Text(mood))).toList()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAnalytics(BuildContext context, String sensor) {
    showModalBottomSheet(context: context, builder: (_) => SizedBox(height: 300, child: Center(child: Text('Analytics for $sensor', style: const TextStyle(color: Colors.white)))));
  }
}

class ParticlePainter extends CustomPainter {
  final Offset flow;
  ParticlePainter(this.flow);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF38BDF8).withOpacity(0.5);
    final rng = math.Random(42);
    for (int i = 0; i < 50; i++) {
      final dx = (rng.nextDouble() * size.width + flow.dx * 0.1) % size.width;
      final dy = (rng.nextDouble() * size.height + flow.dy * 0.1) % size.height;
      canvas.drawCircle(Offset(dx, dy), 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => oldDelegate.flow != flow;
}