import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/task_provider.dart';
import '../utils/constants.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categories = taskProvider.categories;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: taskProvider._filterStatus,
                    items:
                        AppConstants.statusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setFilterStatus(value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: taskProvider._filterCategory,
                    items: [
                      const DropdownMenuItem<String>(
                        value: 'All',
                        child: Text('All Categories'),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Text(category.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setFilterCategory(value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: taskProvider._filterPriority,
                    items:
                        AppConstants.priorityOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setFilterPriority(value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: taskProvider._filterDueDate,
                    items:
                        AppConstants.dueDateOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        taskProvider.setFilterDueDate(value);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                taskProvider.setSearchQuery(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension on TaskProvider {
  get _filterStatus => null;

  get _filterPriority => null;

  get _filterDueDate => null;

  get _filterCategory => null;
}
