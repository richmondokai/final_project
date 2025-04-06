import 'package:flutter/material.dart';

class PriorityChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color color;

  const PriorityChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: color,
      labelStyle: TextStyle(color: selected ? Colors.white : null),
    );
  }
}
