import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/helpers.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                if (task.description != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(task.description!),
                  ),
                const Divider(),
                Row(
                  children: [
                    const Icon(Icons.category, size: 16),
                    const SizedBox(width: 8),
                    Text(task.category),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 16,
                      color: Helpers.getPriorityColor(task.priority),
                    ),
                    const SizedBox(width: 8),
                    Text(Helpers.getPriorityLabel(task.priority)),
                  ],
                ),
                const SizedBox(height: 8),
                if (task.dueDate != null)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(Helpers.formatDate(task.dueDate)),
                      if (Helpers.isTaskDueSoon(task))
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Chip(
                            label: Text('Due Soon'),
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      if (Helpers.isTaskOverdue(task))
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Chip(
                            label: Text('Overdue'),
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 8),
                if (task.notes != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const Text(
                        'Notes:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(task.notes!),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
