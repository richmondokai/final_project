import '../models/task.dart';

class TaskService {
  // This could be replaced with API calls in a real app
  List<Task> filterTasks(List<Task> tasks, String filter) {
    switch (filter) {
      case 'Active':
        return tasks.where((task) => !task.completed).toList();
      case 'Completed':
        return tasks.where((task) => task.completed).toList();
      default:
        return tasks;
    }
  }
}
