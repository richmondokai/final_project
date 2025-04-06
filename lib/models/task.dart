enum Priority { high, medium, low }

class Task {
  final String id;
  final String title;
  final String? description;
  bool completed;
  final DateTime createdAt;
  DateTime updatedAt;
  DateTime? dueDate;
  String category;
  Priority priority;
  String? notes;
  String? userId;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
    this.category = 'Uncategorized',
    Priority? priority,
    this.notes,
    this.userId,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        priority = priority ?? Priority.medium;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? category,
    Priority? priority,
    String? notes,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'category': category,
      'priority': _priorityToString(priority),
      'notes': notes,
      'userId': userId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString(),
        completed: json['completed'] ?? false,
        createdAt: DateTime.parse(
            json['createdAt']?.toString() ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt']?.toString() ?? DateTime.now().toIso8601String()),
        dueDate: json['dueDate'] != null
            ? DateTime.tryParse(json['dueDate']?.toString() ?? '')
            : null,
        category: json['category']?.toString() ?? 'Uncategorized',
        priority: _stringToPriority(json['priority']),
        notes: json['notes']?.toString(),
        userId: json['userId']?.toString(),
      );
    } catch (e) {
      throw FormatException('Failed to parse Task: $e');
    }
  }

  static String _priorityToString(Priority priority) {
    return priority.toString().split('.').last;
  }

  static Priority _stringToPriority(dynamic priorityValue) {
    if (priorityValue is int) {
      return Priority
          .values[priorityValue.clamp(0, Priority.values.length - 1)];
    } else if (priorityValue is String) {
      return Priority.values.firstWhere(
        (e) => e.toString().split('.').last == priorityValue.toLowerCase(),
        orElse: () => Priority.medium,
      );
    }
    return Priority.medium;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => id.hashCode ^ updatedAt.hashCode;

  bool get isDueSoon {
    if (dueDate == null || completed) return false;
    final now = DateTime.now();
    return dueDate!.isAfter(now) && dueDate!.difference(now).inHours <= 24;
  }

  bool get isOverdue {
    if (dueDate == null || completed) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  Duration? get timeRemaining {
    if (dueDate == null || completed) return null;
    return dueDate!.difference(DateTime.now());
  }
}
