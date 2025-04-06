import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class AppConstants {
  static const String appName = 'Todo App';
  static const String defaultCategory = 'Uncategorized';

  static const List<String> priorityOptions = ['High', 'Medium', 'Low'];
  static const List<String> statusOptions = ['All', 'Active', 'Completed'];
  static const List<String> dueDateOptions = [
    'All',
    'Today',
    'This Week',
    'This Month',
  ];

  // Changed to non-const map since enum values aren't compile-time constants
  static final Map<Priority, Color> priorityColors = {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };

  // Changed to non-const map since enum values aren't compile-time constants
  static final Map<Priority, String> priorityLabels = {
    Priority.high: 'High',
    Priority.medium: 'Medium',
    Priority.low: 'Low',
  };
}
