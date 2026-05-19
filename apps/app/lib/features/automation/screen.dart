import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutomationBlock {
  final String id;
  final String type;
  Offset position;
  AutomationBlock(this.id, this.type, this.position);
}

class Connection {
  final String fromId;
  final String toId;
  Connection(this.fromId, this.toId);
}

class AutomationScreen extends ConsumerStatefulWidget {
  const AutomationScreen({super.key});

  @override
  ConsumerState<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends ConsumerState<AutomationScreen> {
  List<AutomationBlock> blocks = [
    AutomationBlock('1', 'Trigger', const Offset(50, 50)),
    AutomationBlock('2', 'Action', const Offset(300, 200)),
  ];
  List<Connection> connections = [Connection('1', '2')];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Automation Builder'),
        actions: [
          IconButton(icon: const Icon(Icons.play_arrow), onPressed: () {}),
          IconButton(icon: const Icon(Icons.save), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 120,
            color: theme.colorScheme.surface,
            child: Column(
              children: ['Trigger', 'Action'].map((type) => Draggable<String>(
                data: type,
                feedback: Material(color: Colors.transparent, child: Chip(label: Text(type))), 
                child: ListTile(title: Text(type), leading: const Icon(Icons.add)),
              )).toList(),
            ),
          ),
          Expanded(
            child: DragTarget<String>(
              onAcceptWithDetails: (details) {
                setState(() => blocks.add(AutomationBlock(DateTime.now().toString(), details.data, details.offset)));
              },
              builder: (ctx, _, __) => InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(1000),
                minScale: 0.5,
                maxScale: 2.0,
                child: CustomPaint(
                  painter: ConnectionPainter(blocks, connections),
                  child: Stack(
                    children: blocks.map((b) => Positioned(
                      left: b.position.dx,
                      top: b.position.dy,
                      child: GestureDetector(
                        onPanUpdate: (d) => setState(() => b.position += d.delta),
                        child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(b.type))),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final List<AutomationBlock> blocks;
  final List<Connection> connections;
  ConnectionPainter(this.blocks, this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke;
    for (var conn in connections) {
      final start = blocks.firstWhere((b) => b.id == conn.fromId).position;
      final end = blocks.firstWhere((b) => b.id == conn.toId).position;
      final path = Path()..moveTo(start.dx + 50, start.dy + 25)..cubicTo(start.dx + 150, start.dy, end.dx - 50, end.dy, end.dx, end.dy + 25);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}