import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/task.dart';
import '../utils/helpers.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Color categoryColor; // New parameter for category color
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final bool showCompleteButton;

  const TaskItem({
    super.key,
    required this.task,
    required this.categoryColor, // Required parameter
    this.onTap,
    this.onComplete,
    this.showCompleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priority = task.priority;
    final isOverdue = task.isOverdue;
    final isDueSoon = task.isDueSoon;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isOverdue
              ? Colors.red.withAlpha(128)
              : isDueSoon
                  ? Colors.orange.withAlpha(77)
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                        color: task.completed
                            ? theme.disabledColor
                            : theme.textTheme.titleMedium?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (task.dueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        Helpers.formatDate(task.dueDate),
                        style: TextStyle(
                          color: isOverdue
                              ? Colors.red
                              : isDueSoon
                                  ? Colors.orange
                                  : theme.textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              if (task.description?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    task.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration:
                          task.completed ? TextDecoration.lineThrough : null,
                      color: task.completed
                          ? theme.disabledColor
                          : theme.textTheme.bodyMedium?.color,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (task.category.isNotEmpty)
                    Chip(
                      label: Text(
                        task.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white, // White text for better contrast
                        ),
                      ),
                      backgroundColor: categoryColor, // Use the passed color
                      visualDensity: VisualDensity.compact,
                    ),
                  if (task.category.isNotEmpty) const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      Helpers.getPriorityLabel(priority),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Helpers.getPriorityColor(priority),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  if (showCompleteButton)
                    IconButton(
                      icon: Icon(
                        task.completed
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.circle,
                        color: task.completed ? Colors.green : Colors.grey,
                      ),
                      onPressed: onComplete,
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
