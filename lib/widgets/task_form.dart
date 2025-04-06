import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../state/task_provider.dart';
import '../utils/constants.dart';
import 'priority_chip.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const TaskForm({
    super.key,
    this.task,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String? _description;
  late String _category;
  late Priority _priority;
  late DateTime? _dueDate;
  late String? _notes;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    _title = task?.title ?? '';
    _description = task?.description;
    _priority = task?.priority ?? Priority.medium;
    _dueDate = task?.dueDate;
    _notes = task?.notes;

    _category = task?.category ??
        (taskProvider.categories.isNotEmpty
            ? taskProvider.categories.first.name
            : AppConstants.defaultCategory);
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = _dueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
    );

    if (pickedTime != null && mounted) {
      setState(() {
        _dueDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final task = widget.task;

      if (task == null) {
        taskProvider.addTask(Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _title,
          description: _description,
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
          notes: _notes,
        ));
      } else {
        taskProvider.updateTask(Task(
          id: task.id,
          title: _title,
          description: _description,
          completed: task.completed,
          createdAt: task.createdAt,
          updatedAt: DateTime.now(),
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
          notes: _notes,
          userId: task.userId,
        ));
      }
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categories = taskProvider.categories;
    final screenWidth = MediaQuery.of(context).size.width;

    final categoryItems = [
      ...categories.map((category) => DropdownMenuItem<String>(
            value: category.name,
            child: Text(category.name),
          )),
      const DropdownMenuItem<String>(
        value: 'Add New Category',
        child: Text('Add New Category...'),
      ),
    ];

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task == null ? 'Add New Task' : 'Edit Task',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _description = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: categoryItems,
                  onChanged: (value) {
                    if (value == 'Add New Category') {
                      _showAddCategoryDialog();
                    } else if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),
                const Text('Priority',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PriorityChip(
                        label: 'High',
                        selected: _priority == Priority.high,
                        onSelected: () =>
                            setState(() => _priority = Priority.high),
                        color: const Color.fromARGB(255, 198, 17, 4),
                      ),
                      const SizedBox(width: 8),
                      PriorityChip(
                        label: 'Medium',
                        selected: _priority == Priority.medium,
                        onSelected: () =>
                            setState(() => _priority = Priority.medium),
                        color: const Color.fromARGB(255, 255, 102, 0),
                      ),
                      const SizedBox(width: 8),
                      PriorityChip(
                        label: 'Low',
                        selected: _priority == Priority.low,
                        onSelected: () =>
                            setState(() => _priority = Priority.low),
                        color: const Color.fromARGB(255, 0, 116, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Due Date',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: screenWidth * 0.5),
                          child: Text(
                            _dueDate == null
                                ? 'No due date set'
                                : DateFormat('MMM d, y h:mm a')
                                    .format(_dueDate!),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.tonal(
                          onPressed: () => _selectDate(context),
                          child: const Text('Set Date'),
                        ),
                        if (_dueDate != null) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => setState(() => _dueDate = null),
                            child: const Text('Clear'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _notes,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _notes = value,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: _saveTask,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final categoryController = TextEditingController();
    Color selectedColor = Colors.blue;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Select Color'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Colors.primaries
                    .map((color) => ChoiceChip(
                          label: const SizedBox.shrink(),
                          selected: selectedColor == color,
                          onSelected: (_) {
                            selectedColor = color;
                            Navigator.of(context).pop(false);
                            if (mounted) {
                              _showAddCategoryDialog();
                            }
                          },
                          backgroundColor: color,
                          selectedColor: color,
                          shape: const CircleBorder(),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(categoryController.text.isNotEmpty),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final newCategory = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: categoryController.text,
        color: selectedColor,
      );
      taskProvider.addCategory(newCategory);
      setState(() => _category = newCategory.name);
    }
  }
}
