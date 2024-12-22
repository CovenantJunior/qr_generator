import 'package:flutter/material.dart';
class Themes {
  final List<Map<String, dynamic>> themes = [
    {
      'id': 1,
      'name': 'Royal',
      'color': [
        const Color.fromARGB(255, 43, 0, 50),
        const Color.fromARGB(255, 15, 0, 15),
      ],
    },
    {
      'id': 2,
      'name': 'Neon Dream',
      'color': [
        const Color.fromARGB(255, 0, 191, 255),
        const Color.fromARGB(255, 0, 100, 150),
      ],
    },
    {
      'id': 3,
      'name': 'Lime Fresh',
      'color': [
        const Color.fromARGB(255, 0, 255, 0),
        const Color.fromARGB(255, 0, 150, 0),
      ],
    },
    {
      'id': 4,
      'name': 'Midnight Sky',
      'color': [
        const Color.fromARGB(255, 0, 0, 255),
        const Color.fromARGB(255, 0, 0, 150),
      ],
    },
    {
      'id': 5,
      'name': 'Sunset Glow',
      'color': [
        const Color.fromARGB(255, 255, 128, 0),
        const Color.fromARGB(255, 150, 60, 0),
      ],
    },
  ];
}