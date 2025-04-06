import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/task.dart';

class AppConstants {
  static const Map<Priority, Color> priorityColors = {
    Priority.high: Color.fromARGB(255, 188, 0, 0),
    Priority.medium: Color.fromARGB(255, 218, 59, 11),
    Priority.low: Color.fromARGB(255, 19, 113, 5),
  };

  static const Map<Priority, String> priorityLabels = {
    Priority.high: 'High',
    Priority.medium: 'Medium',
    Priority.low: 'Low',
  };

  static const List<String> defaultCategories = [
    'Personal',
    'Work',
    'Shopping',
    'Health',
    'Finance',
    'Other'
  ];
}

class Helpers {
  static String formatDate(DateTime? date, {bool withTime = false}) {
    if (date == null) return 'No date';
    final dateStr = '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    if (!withTime) return dateStr;

    return '$dateStr at ${formatTime(date)}';
  }

  static String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  static Color getPriorityColor(Priority priority) {
    return AppConstants.priorityColors[priority] ?? Colors.grey;
  }

  static String getPriorityLabel(Priority priority) {
    return AppConstants.priorityLabels[priority] ?? 'Medium';
  }

  static bool isTaskDueSoon(Task task) => task.isDueSoon;

  static bool isTaskOverdue(Task task) => task.isOverdue;

  static String getTimeRemainingText(Task task) {
    if (task.dueDate == null || task.completed) return '';

    final remaining = task.timeRemaining;
    if (remaining == null) return '';

    if (remaining.isNegative) {
      return 'Overdue by ${formatDuration(remaining.abs())}';
    }
    return 'Due in ${formatDuration(remaining)}';
  }

  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return 'Less than a minute';
  }

  static Color getTaskStatusColor(Task task) {
    if (task.completed) return Colors.green;
    if (task.isOverdue) return Colors.red;
    if (task.isDueSoon) return Colors.orange;
    return Colors.grey;
  }

  static IconData getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.high:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case Priority.medium:
        return CupertinoIcons.exclamationmark_circle_fill;
      case Priority.low:
        return CupertinoIcons.checkmark_circle_fill;
    }
  }
}
