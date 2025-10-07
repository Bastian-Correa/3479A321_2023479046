import 'package:flutter/material.dart';

/// Centro de configuración global de la app.
class ConfigurationData extends ChangeNotifier {
  int _size = 16;
  int get size => _size;
  void setSize(int newSize) {
    _size = newSize;
    notifyListeners();
  }

  // Usamos una clave para guardarlo y un color visible.
  String _paletteKey = 'cian';
  String get paletteKey => _paletteKey;

  Color _paletteColor = const Color(0xFF009688);
  Color get paletteColor => _paletteColor;

  void setPalette(String key) {
    _paletteKey = key;
    switch (key) {
      case 'magenta':
        _paletteColor = const Color(0xFFE91E63);
        break;
      case 'amber':
        _paletteColor = const Color(0xFFFFC107);
        break;
      case 'purple':
        _paletteColor = const Color(0xFF9C27B0);
        break;
      case 'cian':
      default:
        _paletteColor = const Color(0xFF009688);
        _paletteKey = 'cian';
        break;
    }
    notifyListeners();
  }
}
