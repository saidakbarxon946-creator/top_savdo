import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'TopSavdo';
  static const String appTagline = "O'zbekistondagi №1 Savdo Maydonchasi";

  // Storage Keys
  static const String keyIntroSeen = 'intro_seen';
  static const String keyThemeMode = 'theme_mode';

  // Default Asset Placeholders / Fallbacks
  static const String defaultUserImage = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80';
  static const String defaultProductImage = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80';

  // Category Models Metadata
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'id': 'electronics',
      'name': 'Elektronika',
      'icon': Icons.devices_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'id': 'vehicles',
      'name': 'Avtomobillar',
      'icon': Icons.directions_car_rounded,
      'color': Color(0xFF3B82F6),
    },
    {
      'id': 'real_estate',
      'name': "Ko'chmas mulk",
      'icon': Icons.home_work_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'id': 'fashion',
      'name': 'Kiyim va Poyabzal',
      'icon': Icons.checkroom_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'id': 'home_garden',
      'name': "Uy va Bog'dosh",
      'icon': Icons.chair_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 'sports',
      'name': 'Sport va Xobbi',
      'icon': Icons.sports_soccer_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'id': 'services',
      'name': 'Xizmatlar',
      'icon': Icons.handshake_rounded,
      'color': Color(0xFF14B8A6),
    },
    {
      'id': 'other',
      'name': 'Boshqalar',
      'icon': Icons.grid_view_rounded,
      'color': Color(0xFF64748B),
    },
  ];

  // Regions of Uzbekistan
  static const List<String> regions = [
    'Toshkent shahri',
    'Toshkent viloyati',
    'Andijon',
    'Buxoro',
    'Farg\'ona',
    'Jizzax',
    'Namangan',
    'Navoiy',
    'Qashqadaryo',
    'Qoraqalpog\'iston R.',
    'Samarqand',
    'Sirdaryo',
    'Surxondaryo',
    'Xorazm',
  ];
}
