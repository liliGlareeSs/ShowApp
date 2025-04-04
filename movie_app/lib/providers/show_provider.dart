import 'package:flutter/material.dart';
import '../models/show_model.dart';
import '../config/api_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ShowProvider with ChangeNotifier {
  List<Show> _shows = [];
  bool _isLoading = false;
  String? _error;

  List<Show> get shows => _shows;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchShows() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/shows'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _shows = data.map((json) => Show.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load shows: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching shows: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshShows() async {
    await fetchShows();
  }

  void updateShowInList(Show updatedShow) {
    final index = _shows.indexWhere((s) => s.id == updatedShow.id);
    if (index != -1) {
      _shows[index] = updatedShow;
      notifyListeners();
    }
  }

  void addNewShow(Show newShow) {
    _shows.insert(0, newShow);
    notifyListeners();
  }

  void removeShow(int id) {
    _shows.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}