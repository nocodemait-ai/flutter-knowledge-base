import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssistantScreen extends ConsumerWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text('AI Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _MessageBubble(index: index),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.secondary)),
            ),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type a command...'))),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _showVoiceOverlay(context),
                  child: const Icon(Icons.mic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVoiceOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Listening...', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final int index;
  const _MessageBubble({required this.index});

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(100, 100, 100, 100),
        items: const [PopupMenuItem(child: Text('Copy')), PopupMenuItem(child: Text('Delete'))],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: colorScheme.primary.withValues(alpha: 0.1 + (_controller.value * 0.2)), blurRadius: 10)
            ],
          ),
          child: Text('AI Message #${widget.index + 1}', style: TextStyle(color: colorScheme.onSurface)),
        ),
      ),
    );
  }
}