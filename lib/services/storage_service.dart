import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import '../models/task.dart';
import '../models/category.dart';

class StorageService {
  final SharedPreferences _prefs;
  static const String _tasksKey = 'tasks';
  static const String _categoriesKey = 'categories';
  final _logger = Logger('StorageService');

  StorageService(this._prefs);

  Future<List<Task>> loadTasks() async {
    try {
      final tasksJson = _prefs.getStringList(_tasksKey) ?? [];
      return tasksJson.map((json) {
        try {
          return Task.fromJson(jsonDecode(json));
        } catch (e) {
          _logger.warning('Error parsing task', e);
          return Task(
            id: 'error-${DateTime.now().millisecondsSinceEpoch}',
            title: 'Invalid Task',
          );
        }
      }).toList();
    } catch (e) {
      _logger.severe('Error loading tasks', e);
      return [];
    }
  }

  Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      return await _prefs.setStringList(_tasksKey, tasksJson);
    } catch (e) {
      _logger.severe('Error saving tasks', e);
      return false;
    }
  }

  Future<List<Category>> loadCategories() async {
    try {
      final categoriesJson = _prefs.getStringList(_categoriesKey) ?? [];
      return categoriesJson.map((json) {
        try {
          return Category.fromJson(jsonDecode(json));
        } catch (e) {
          _logger.warning('Error parsing category', e);
          return Category(
            id: 'error',
            name: 'Invalid Category',
            color: Colors.grey,
          );
        }
      }).toList();
    } catch (e) {
      _logger.severe('Error loading categories', e);
      return [];
    }
  }

  Future<bool> saveCategories(List<Category> categories) async {
    try {
      final categoriesJson =
          categories.map((cat) => jsonEncode(cat.toJson())).toList();
      return await _prefs.setStringList(_categoriesKey, categoriesJson);
    } catch (e) {
      _logger.severe('Error saving categories', e);
      return false;
    }
  }

  Future<void> clearAllData() async {
    await _prefs.remove(_tasksKey);
    await _prefs.remove(_categoriesKey);
  }
}
