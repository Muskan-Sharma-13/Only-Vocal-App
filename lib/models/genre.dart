import 'package:flutter/material.dart';

class Genre {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final String imageUrl;

  Genre({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.imageUrl,
  });
}
