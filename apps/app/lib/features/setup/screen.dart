import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _playerCountController = TextEditingController();
  bool _rotationMode = false;

  @override
  void dispose() {
    _playerCountController.dispose();
    super.dispose();
  }

  void _generateMatches() {
    final count = int.tryParse(_playerCountController.text);
    if (count != null && count >= 2) {
      context.push('/matchmaking');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid player count (min 2)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Setup')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _playerCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Player Count',
                      prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable Rotation Mode'),
                    value: _rotationMode,
                    onChanged: (val) => setState(() => _rotationMode = val),
                  ),
                  const SizedBox(height: 24),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, val, child) => Transform.scale(scale: val, child: child),
                    child: ElevatedButton.icon(
                      onPressed: _generateMatches,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Generate Matches'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateMatches,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}