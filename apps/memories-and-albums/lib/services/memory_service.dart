import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memory.dart';

class MemoryService extends ChangeNotifier {
  List<MemoryModel> _memories = [];
  bool _isLoaded = false;

  MemoryService() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? memoriesJson = prefs.getString('memories');
    if (memoriesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(memoriesJson);
        _memories = decoded.map((item) => MemoryModel.fromJson(item)).toList();
      } catch (e) {
        _memories = _getInitialData();
      }
    } else {
      _memories = _getInitialData();
    }
    _isLoaded = true;
    notifyListeners();
  }

  List<MemoryModel> _getInitialData() {
    return [
      MemoryModel(
        id: 'm1',
        title: 'Summer Picnic in Central Park',
        description: 'A beautiful sunny afternoon with the whole family.',
        date: DateTime(2024, 6, 15),
        locationName: 'Central Park, NY',
        photoUrls: ['https://images.unsplash.com/photo-1523438885200-e635ba2c371e?q=80&w=800'],
        createdBy: 'u1',
      ),
    ];
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_memories.map((m) => m.toJson()).toList());
    await prefs.setString('memories', encoded);
  }

  List<MemoryModel> get memories => List.unmodifiable([..._memories]..sort((a, b) => b.date.compareTo(a.date)));

  bool get isLoaded => _isLoaded;

  void addMemory(MemoryModel m) {
    _memories.add(m);
    _saveToPrefs();
    notifyListeners();
  }

  void deleteMemory(String id) {
    _memories.removeWhere((m) => m.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void updateMemory(MemoryModel m) {
    final index = _memories.indexWhere((item) => item.id == m.id);
    if (index != -1) {
      _memories[index] = m;
      _saveToPrefs();
      notifyListeners();
    }
  }

  MemoryModel? getById(String id) {
    try {
      return _memories.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MemoryModel> getByAlbum(String albumId) =>
      _memories.where((m) => m.albumId == albumId).toList();

  List<MemoryModel> search(String query) {
    if (query.isEmpty) return memories;
    final q = query.toLowerCase();
    return memories.where((m) => 
      m.title.toLowerCase().contains(q) || 
      (m.description?.toLowerCase().contains(q) ?? false)
    ).toList();
  }
}
