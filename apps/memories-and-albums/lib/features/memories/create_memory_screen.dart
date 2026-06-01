import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/memory.dart';
import '../../services/memory_service.dart';
import '../../services/album_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateMemoryScreen extends StatefulWidget {
  const CreateMemoryScreen({super.key});

  @override
  State<CreateMemoryScreen> createState() => _CreateMemoryScreenState();
}

class _CreateMemoryScreenState extends State<CreateMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedAlbumId;
  final List<String> _photoUrls = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _photoUrls.add(image.path));
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_photoUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one photo')));
        return;
      }
      final memory = MemoryModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        date: _selectedDate,
        locationName: _locController.text,
        photoUrls: _photoUrls,
        createdBy: 'u1',
        albumId: _selectedAlbumId,
      );
      context.read<MemoryService>().addMemory(memory);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final albums = context.watch<AlbumService>().albums;

    return Scaffold(
      appBar: AppBar(title: const Text('New Memory'), actions: [
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
                  ..._photoUrls.map((path) => Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: path.startsWith('http') 
                                ? NetworkImage(path) as ImageProvider 
                                : FileImage(File(path)), 
                            fit: BoxFit.cover
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() => _photoUrls.remove(path)),
                          ),
                        ),
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
                child: Text("${_selectedDate.toLocal()}".split(' ')[0]),
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
              decoration: const InputDecoration(labelText: 'Add to Album'),
              items: albums.map((a) => DropdownMenuItem(value: a.id, child: Text(a.title))).toList(),
              onChanged: (v) => setState(() => _selectedAlbumId = v),
            ),
          ],
        ),
      ),
    );
  }
}
