import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/album.dart';

class AlbumService extends ChangeNotifier {
  List<AlbumModel> _albums = [];

  AlbumService() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString('albums');
    if (jsonStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _albums = decoded.map((item) => AlbumModel.fromJson(item)).toList();
      } catch (e) {
        _albums = _getInitialData();
      }
    } else {
      _albums = _getInitialData();
    }
    notifyListeners();
  }

  List<AlbumModel> _getInitialData() {
    return [
      AlbumModel(id: 'a1', title: 'Family 2024', coverImageUrl: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=400', members: ['u1', 'u2'], privacy: 'shared'),
      AlbumModel(id: 'a2', title: 'Japan Trip', coverImageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=400', members: ['u1'], privacy: 'private'),
    ];
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_albums.map((a) => a.toJson()).toList());
    await prefs.setString('albums', encoded);
  }

  List<AlbumModel> get albums => List.unmodifiable(_albums);

  void addAlbum(AlbumModel album) {
    _albums.add(album);
    _saveToPrefs();
    notifyListeners();
    notifyListeners();
  }

  void deleteAlbum(String id) {
    _albums.removeWhere((a) => a.id == id);
    _saveToPrefs();
    notifyListeners();
  }
}
