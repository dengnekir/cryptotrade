import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Analiz geçmişini kaydetme
  Future<void> saveAnalysisHistory(String analysisResult) async {
    List<String> history = _prefs.getStringList('analysis_history') ?? [];
    history.insert(0, analysisResult);

    // Son 50 analizi saklayalım
    if (history.length > 50) {
      history = history.sublist(0, 50);
    }

    await _prefs.setStringList('analysis_history', history);
  }

  // Analiz geçmişini getirme
  List<String> getAnalysisHistory() {
    return _prefs.getStringList('analysis_history') ?? [];
  }

  // Kullanıcı tercihlerini kaydetme
  Future<void> setDarkMode(bool isDarkMode) async {
    await _prefs.setBool('dark_mode', isDarkMode);
  }

  bool getDarkMode() {
    return _prefs.getBool('dark_mode') ?? false;
  }

  // Coin tercihlerini kaydetme
  Future<void> saveFavoriteCoin(String coinSymbol) async {
    List<String> favorites = _prefs.getStringList('favorite_coins') ?? [];
    if (!favorites.contains(coinSymbol)) {
      favorites.add(coinSymbol);
      await _prefs.setStringList('favorite_coins', favorites);
    }
  }

  List<String> getFavoriteCoins() {
    return _prefs.getStringList('favorite_coins') ?? [];
  }

  // Belirli bir anahtarı silme
  Future<void> removeKey(String key) async {
    await _prefs.remove(key);
  }

  // Tüm verileri temizleme
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
