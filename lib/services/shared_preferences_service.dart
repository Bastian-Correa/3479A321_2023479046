import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _kSize = 'size';
  static const _kPaletteKey = 'paletteKey';
  static const _kBackgroundOpacity =
      'background_opacity'; // opacidad persistente

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  //size
  Future<int?> getSize() async => (await _prefs).getInt(_kSize);
  Future<void> setSize(int v) async => (await _prefs).setInt(_kSize, v);

  //palette
  Future<String?> getPaletteKey() async =>
      (await _prefs).getString(_kPaletteKey);
  Future<void> setPaletteKey(String key) async =>
      (await _prefs).setString(_kPaletteKey, key);

  //background opacity (0.0 - 1.0)
  Future<double?> getBackgroundOpacity() async =>
      (await _prefs).getDouble(_kBackgroundOpacity);

  Future<void> setBackgroundOpacity(double value) async {
    final v = value.clamp(0.0, 1.0);
    await (await _prefs).setDouble(_kBackgroundOpacity, v);
  }
}
