import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storageService;
  List<Task> _tasks = [];
  List<Category> _categories = [
    Category(id: '1', name: 'Personal', color: Colors.blue),
    Category(id: '2', name: 'Work', color: Colors.green),
    Category(id: '3', name: 'Shopping', color: Colors.orange),
  ];

  // Filter states
  String _filterStatus = 'All';
  String _filterCategory = 'All';
  String _filterPriority = 'All';
  String _filterDueDate = 'All';
  String _searchQuery = '';

  TaskProvider(this._storageService) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadTasks();
    await loadCategories();
  }

  List<Task> get tasks => _getFilteredTasks();
  List<Category> get categories => List.unmodifiable(_categories);
  String get currentFilterCategory => _filterCategory;

  Future<void> loadTasks() async {
    try {
      _tasks = await _storageService.loadTasks();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      rethrow;
    }
  }

  Future<void> loadCategories() async {
    try {
      final loadedCategories = await _storageService.loadCategories();
      if (loadedCategories.isNotEmpty) {
        _categories = loadedCategories;
        if (!_categories.any((c) => c.name == AppConstants.defaultCategory)) {
          _categories.insert(
            0,
            Category(
              id: 'default',
              name: AppConstants.defaultCategory,
              color: Colors.grey,
            ),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading categories: $e');
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    try {
      _tasks.add(task);
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        await _storageService.saveTasks(_tasks);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  Future<Task?> deleteTask(String taskId) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final deletedTask = _tasks[taskIndex];
        _tasks.removeAt(taskIndex);
        await _storageService.saveTasks(_tasks);
        notifyListeners();
        return deletedTask;
      }
      return null;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return null;
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          completed: !_tasks[index].completed,
          updatedAt: DateTime.now(),
        );
        await _storageService.saveTasks(_tasks);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      rethrow;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      if (_categories.any((c) => c.name == category.name)) {
        throw Exception('Category name must be unique');
      }
      _categories.add(category);
      await _storageService.saveCategories(_categories);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding category: $e');
      rethrow;
    }
  }

  // Filter methods
  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterCategory(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void setFilterDueDate(String dueDate) {
    _filterDueDate = dueDate;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void resetFilters() {
    _filterStatus = 'All';
    _filterCategory = 'All';
    _filterPriority = 'All';
    _filterDueDate = 'All';
    _searchQuery = '';
    notifyListeners();
  }

  List<Task> _getFilteredTasks() {
    List<Task> filteredTasks = List.from(_tasks);

    // Apply status filter
    if (_filterStatus == 'Active') {
      filteredTasks = filteredTasks.where((task) => !task.completed).toList();
    } else if (_filterStatus == 'Completed') {
      filteredTasks = filteredTasks.where((task) => task.completed).toList();
    }

    // Apply category filter
    if (_filterCategory != 'All') {
      filteredTasks = filteredTasks
          .where((task) => task.category == _filterCategory)
          .toList();
    }

    // Apply priority filter
    if (_filterPriority != 'All') {
      filteredTasks = filteredTasks.where((task) {
        return task.priority.index ==
            Priority.values.indexWhere(
              (p) => p.name == _filterPriority.toLowerCase(),
            );
      }).toList();
    }

    // Apply due date filter
    final now = DateTime.now();
    if (_filterDueDate == 'Today') {
      filteredTasks = filteredTasks.where((task) {
        return task.dueDate != null &&
            task.dueDate!.year == now.year &&
            task.dueDate!.month == now.month &&
            task.dueDate!.day == now.day;
      }).toList();
    } else if (_filterDueDate == 'This Week') {
      final endOfWeek = now.add(Duration(days: 7 - now.weekday));
      filteredTasks = filteredTasks.where((task) {
        return task.dueDate != null &&
            task.dueDate!.isAfter(now) &&
            task.dueDate!.isBefore(endOfWeek);
      }).toList();
    } else if (_filterDueDate == 'This Month') {
      final endOfMonth = DateTime(now.year, now.month + 1, 1);
      filteredTasks = filteredTasks.where((task) {
        return task.dueDate != null &&
            task.dueDate!.isAfter(now) &&
            task.dueDate!.isBefore(endOfMonth);
      }).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (task.description != null &&
                task.description!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Sort by due date (earliest first), then by priority (high first)
    filteredTasks.sort((a, b) {
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      } else if (a.dueDate != null) {
        return -1;
      } else if (b.dueDate != null) {
        return 1;
      }
      return b.priority.index.compareTo(a.priority.index);
    });

    return filteredTasks;
  }
}
