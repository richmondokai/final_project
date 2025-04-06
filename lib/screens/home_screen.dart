import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/task_list.dart';
import '../widgets/filter_widget.dart';
import '../widgets/task_form.dart';
import '../state/task_provider.dart';
import '../state/auth_provider.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFormVisible = false;
  Task? _taskToEdit;

  void _showTaskForm([Task? task]) {
    setState(() {
      _isFormVisible = true;
      _taskToEdit = task;
    });
  }

  void _hideTaskForm() {
    setState(() {
      _isFormVisible = false;
      _taskToEdit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ = Provider.of<TaskProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Application'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const FilterWidget(),
              Expanded(child: TaskList(onTaskTap: _showTaskForm)),
            ],
          ),
          if (_isFormVisible)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TaskForm(
                        task: _taskToEdit,
                        onSave: _hideTaskForm,
                        onCancel: _hideTaskForm,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          _isFormVisible
              ? null
              : FloatingActionButton(
                onPressed: () => _showTaskForm(),
                child: const Icon(Icons.add),
              ),
    );
  }
}
