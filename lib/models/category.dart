// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({required this.id, required this.name, required this.color});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color.value,
  };

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'], name: json['name'], color: Color(json['color']));
}
