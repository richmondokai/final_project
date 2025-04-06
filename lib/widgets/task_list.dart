import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../state/task_provider.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final Function(Task)? onTaskTap;

  const TaskList({super.key, this.onTaskTap});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    final categories = taskProvider.categories;

    if (tasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No tasks found. Add a new task!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final category = categories.firstWhere(
          (c) => c.name == task.category,
          orElse: () => Category(
            id: 'default',
            name: task.category,
            color: Colors.grey,
          ),
        );

        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.horizontal,
          background: _buildDeleteBackground(),
          secondaryBackground: _buildCompleteBackground(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              return await _confirmDelete(context);
            } else {
              taskProvider.toggleTaskCompletion(task.id);
              return false;
            }
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              _handleDelete(context, taskProvider, task);
            }
          },
          child: TaskItem(
            task: task,
            categoryColor: category.color,
            onTap: () => onTaskTap?.call(task),
            onComplete: () => taskProvider.toggleTaskCompletion(task.id),
          ),
        );
      },
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: const Icon(Icons.delete_forever, color: Colors.white, size: 28),
    );
  }

  Widget _buildCompleteBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[400],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.check_circle, color: Colors.white, size: 28),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _handleDelete(
      BuildContext context, TaskProvider taskProvider, Task task) {
    taskProvider.deleteTask(task.id).then((deletedTask) {
      if (deletedTask != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => taskProvider.addTask(deletedTask),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }
}
