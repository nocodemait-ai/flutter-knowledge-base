import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/memory.dart';
import '../../services/memory_service.dart';
import '../../services/album_service.dart';

class EditMemoryScreen extends StatefulWidget {
  final String id;
  const EditMemoryScreen({super.key, required this.id});

  @override
  State<EditMemoryScreen> createState() => _EditMemoryScreenState();
}

class _EditMemoryScreenState extends State<EditMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locController;
  late DateTime _selectedDate;
  String? _selectedAlbumId;
  late List<String> _photoUrls;
  bool _initialized = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final memory = context.read<MemoryService>().getById(widget.id);
      if (memory != null) {
        _titleController = TextEditingController(text: memory.title);
        _descController = TextEditingController(text: memory.description);
        _locController = TextEditingController(text: memory.locationName);
        _selectedDate = memory.date;
        _selectedAlbumId = memory.albumId;
        _photoUrls = List.from(memory.photoUrls);
      } else {
        // Fallback or pop
        Navigator.pop(context);
      }
      _initialized = true;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final memory = MemoryModel(
        id: widget.id,
        title: _titleController.text,
        description: _descController.text,
        date: _selectedDate,
        locationName: _locController.text,
        photoUrls: _photoUrls,
        createdBy: 'u1',
        albumId: _selectedAlbumId,
      );
      context.read<MemoryService>().updateMemory(memory);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const Scaffold();
    final albums = context.watch<AlbumService>().albums;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Memory'), actions: [
        TextButton(onPressed: _save, child: const Text('Save')),
      ]),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Photos', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._photoUrls.map((url) => Stack(
                        children: [
                          Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: url.startsWith('http') 
                                    ? NetworkImage(url) as ImageProvider 
                                    : FileImage(File(url)), 
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => setState(() => _photoUrls.remove(url)),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locController,
              decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on_outlined)),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime.now());
                if (date != null) setState(() => _selectedDate = date);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Date', prefixIcon: Icon(Icons.calendar_month_outlined)),
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedAlbumId,
              decoration: const InputDecoration(labelText: 'Album'),
              items: albums.map((a) => DropdownMenuItem(value: a.id, child: Text(a.title))).toList(),
              onChanged: (v) => setState(() => _selectedAlbumId = v),
            ),
          ],
        ),
      ),
    );
  }
}
