import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _kSize = 'size';
  static const _kPaletteKey = 'paletteKey';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<int?> getSize() async => (await _prefs).getInt(_kSize);
  Future<void> setSize(int v) async => (await _prefs).setInt(_kSize, v);

  Future<String?> getPaletteKey() async =>
      (await _prefs).getString(_kPaletteKey);
  Future<void> setPaletteKey(String key) async =>
      (await _prefs).setString(_kPaletteKey, key);
}
