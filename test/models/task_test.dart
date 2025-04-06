import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/models/task.dart';

void main() {
  group('Task Model', () {
    test('should create a task with default values', () {
      final task = Task(id: '1', title: 'Test Task');

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.completed, false);
      expect(task.priority, Priority.medium);
      expect(task.category, 'Uncategorized');
    });

    test('should convert to and from JSON', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        completed: true,
        dueDate: DateTime(2023, 1, 1),
        category: 'Work',
        priority: Priority.high,
        notes: 'Test Notes',
      );

      final json = task.toJson();
      final fromJson = Task.fromJson(json);

      expect(fromJson.id, task.id);
      expect(fromJson.title, task.title);
      expect(fromJson.description, task.description);
      expect(fromJson.completed, task.completed);
      expect(fromJson.dueDate, task.dueDate);
      expect(fromJson.category, task.category);
      expect(fromJson.priority, task.priority);
      expect(fromJson.notes, task.notes);
    });

    test('should handle null values in JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'description': null,
        'completed': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'dueDate': null,
        'category': 'Uncategorized',
        'priority': 1,
        'notes': null,
        'userId': null,
      };

      final task = Task.fromJson(json);

      expect(task.description, isNull);
      expect(task.dueDate, isNull);
      expect(task.notes, isNull);
    });
  });
}
