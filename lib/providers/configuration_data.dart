import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';

/// Centro de configuración global de la app.
class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefsService;

  // Estado interno
  int _size = 16;
  String _paletteKey = 'cian';
  Color _paletteColor = const Color(0xFF009688);

  //lista de creaciones
  final List<String> _creations = [];
  List<String> get creations => List.unmodifiable(_creations);

  int get size => _size;
  String get paletteKey => _paletteKey;
  Color get paletteColor => _paletteColor;

  ConfigurationData(this._prefsService) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final savedSize = await _prefsService.getSize();
    if (savedSize != null) _size = savedSize;

    final savedKey = await _prefsService.getPaletteKey();
    if (savedKey != null) {
      // usa el setter para mapear color y, de paso, dejar clave coherente
      _applyPaletteFromKey(savedKey, persist: false);
    }

    notifyListeners();
  }

  // Setters que actualizan estado, notifican y persisten
  void setSize(int newSize) {
    if (_size == newSize) return;
    _size = newSize;
    notifyListeners();
    _prefsService.setSize(newSize); // persistir
  }

  void setPalette(String key) => _applyPaletteFromKey(key, persist: true);

  void _applyPaletteFromKey(String key, {required bool persist}) {
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
        _paletteKey = 'cian';
        _paletteColor = const Color(0xFF009688);
        break;
    }
    notifyListeners();
    if (persist) _prefsService.setPaletteKey(_paletteKey);
  }

  //Método para agregar una creación
  void addCreation(String filePath) {
    _creations.add(filePath);
    notifyListeners();
  }
}
