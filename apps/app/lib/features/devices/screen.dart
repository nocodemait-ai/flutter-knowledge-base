import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Device {
  final String id;
  final String name;
  final String type;
  final bool isOnline;
  final int battery;
  Device({required this.id, required this.name, required this.type, required this.isOnline, required this.battery});
}

final deviceProvider = StateProvider<List<Device>>((ref) => List.generate(15, (i) => Device(
  id: 'dev_$i',
  name: 'Device ${i + 1}',
  type: i % 2 == 0 ? 'ESP32' : 'Raspberry Pi',
  isOnline: i % 3 != 0,
  battery: (i * 7) % 100,
)));

class DeviceManagementScreen extends ConsumerWidget {
  const DeviceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Devices'),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(deviceProvider),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: devices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final device = devices[index];
            return Card(
              color: theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () => context.push('/devices/${device.id}'),
                onLongPress: () => _showActionDialog(context, device),
                leading: Icon(Icons.circle, color: device.isOnline ? Colors.green : Colors.red, size: 12),
                title: Text(device.name, style: TextStyle(color: theme.colorScheme.onSecondary)),
                subtitle: Text('${device.type} • ${device.battery}%'),
                trailing: IconButton(
                  icon: const Icon(Icons.update),
                  onPressed: () => _showFirmwareModal(context, device),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFirmwareModal(BuildContext context, Device device) {
    showModalBottomSheet(context: context, builder: (_) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Update Firmware', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Device: ${device.name}'),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Confirm Update'))
      ]),
    ));
  }

  void _showActionDialog(BuildContext context, Device device) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Bulk Actions'),
      content: Text('Manage ${device.name}'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ));
  }
}