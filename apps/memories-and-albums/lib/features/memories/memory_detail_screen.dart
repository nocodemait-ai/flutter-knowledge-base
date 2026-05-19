import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../services/memory_service.dart';
import 'dart:io';

class MemoryDetailScreen extends StatelessWidget {
  final String id;
  const MemoryDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final memory = context.watch<MemoryService>().getById(id);

    if (memory == null) {
      return const Scaffold(body: Center(child: Text('Memory not found')));
    }

    final firstPhoto = memory.photoUrls.first;
    final isFirstLocal = !firstPhoto.startsWith('http');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'memory_${memory.id}',
                child: isFirstLocal 
                    ? Image.file(File(firstPhoto), fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: firstPhoto,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => context.push('/home/edit-memory/${memory.id}'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () => _confirmDelete(context, memory.id),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(memory.title, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _Chip(icon: Icons.calendar_today, label: DateFormat('MMM d, yyyy').format(memory.date)),
                        if (memory.locationName != null) ...[
                          const SizedBox(width: 8),
                          _Chip(icon: Icons.location_on, label: memory.locationName!),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (memory.description != null) ...[
                      Text(
                        memory.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: 32),
                    ],
                    Text('Gallery', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: memory.photoUrls.length,
                      itemBuilder: (context, index) {
                        final url = memory.photoUrls[index];
                        final isLocal = !url.startsWith('http');
                        return GestureDetector(
                          onTap: () => _openGallery(context, memory.photoUrls, index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: isLocal
                                ? Image.file(File(url), fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: const Text('Add a comment...'),
                      onTap: () {},
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Memory?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<MemoryService>().deleteMemory(id);
              Navigator.pop(context); // Close dialog
              context.pop(); // Go back to home
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openGallery(BuildContext context, List<String> urls, int initial) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
          body: PageView.builder(
            itemCount: urls.length,
            controller: PageController(initialPage: initial),
            itemBuilder: (context, index) {
              final url = urls[index];
              final isLocal = !url.startsWith('http');
              return InteractiveViewer(
                child: isLocal
                    ? Image.file(File(url), fit: BoxFit.contain)
                    : CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.contain,
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
