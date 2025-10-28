import 'package:flutter/material.dart';
import '../services/shared_preferences_service.dart';

/// Centro de configuración global de la app.
class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefsService;

  // Estado interno
  int _size = 16;
  String _paletteKey = 'cian';
  Color _paletteColor = const Color(0xFF009688);

  // opacidad de la imagen de referencia
  double _backgroundOpacity = 0.5;
  double get backgroundOpacity => _backgroundOpacity;

  // lista de creaciones
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
      _applyPaletteFromKey(savedKey, persist: false);
    }

    // Punto 6: cargar opacidad guardada
    final savedOpacity = await _prefsService.getBackgroundOpacity();
    if (savedOpacity != null) _backgroundOpacity = savedOpacity;

    notifyListeners();
  }

  // Setters que actualizan estado, notifican y persisten
  void setSize(int newSize) {
    if (_size == newSize) return;
    _size = newSize;
    notifyListeners();
    _prefsService.setSize(newSize);
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

  //setter de opacidad
  Future<void> setBackgroundOpacity(double value) async {
    if (value == _backgroundOpacity) return;
    _backgroundOpacity = value;
    notifyListeners();
    await _prefsService.setBackgroundOpacity(value);
  }

  // Método para agregar una creación
  void addCreation(String filePath) {
    _creations.add(filePath);
    notifyListeners();
  }
}
