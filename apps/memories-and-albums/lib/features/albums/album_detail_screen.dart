import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/album_service.dart';
import '../../services/memory_service.dart';
import '../../shared/widgets/memory_card.dart';

class AlbumDetailScreen extends StatelessWidget {
  final String id;
  const AlbumDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final album = context.watch<AlbumService>().albums.firstWhere((a) => a.id == id);
    final memories = context.watch<MemoryService>().getByAlbum(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(album.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<AlbumService>().deleteAlbum(id);
              context.pop();
            },
          )
        ],
      ),
      body: memories.isEmpty
          ? const Center(child: Text('No photos in this album yet.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: memories.length,
              itemBuilder: (context, index) => MemoryCard(memory: memories[index], onTap: () => context.push('/home/memory/${memories[index].id}')),
            ),
    );
  }
}