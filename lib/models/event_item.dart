import 'package:flutter/material.dart';

class EventItem {
  final String id;
  final String title;
  final String category; // AI, Mobile, IoT, Cybersecurity
  final String speaker;
  final String date;
  final String venue;
  final Color color; // warna atas gradasi (sama dengan poster)
  final Color colorEnd; // warna bawah gradasi
  final IconData icon;
  final String poster; // path gambar poster

  const EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.speaker,
    required this.date,
    required this.venue,
    required this.color,
    required this.colorEnd,
    required this.icon,
    required this.poster,
  });
}