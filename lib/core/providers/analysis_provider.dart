import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/gemini_analysis_service.dart';
import '../../core/services/preferences_service.dart';
import '../../analysis/model/analysis_model.dart';
import '../../core/auth/providers/auth_provider.dart';
import '../../history/provider/analysis_history_provider.dart';

// Gemini Analysis Service Provider
final geminiAnalysisServiceProvider =
    Provider((ref) => GeminiAnalysisService());

// Preferences Service Provider
final preferencesServiceProvider = Provider((ref) => PreferencesService());

// Analiz modları için enum
enum AnalysisMode { buy, sell, long, short }

// Analysis State
class AnalysisState {
  final File? selectedImage;
  final AnalysisResult? analysisResult;
  final bool isLoading;
  final String? error;
  final AnalysisMode selectedMode;
  final String coinPair;

  AnalysisState({
    this.selectedImage,
    this.analysisResult,
    this.isLoading = false,
    this.error,
    this.selectedMode = AnalysisMode.buy, // Varsayılan mod
    this.coinPair = 'ETH/USDT', // Varsayılan coin çifti
  });

  AnalysisState copyWith({
    File? selectedImage,
    AnalysisResult? analysisResult,
    bool? isLoading,
    String? error,
    AnalysisMode? selectedMode,
    String? coinPair,
  }) {
    return AnalysisState(
      selectedImage: selectedImage ?? this.selectedImage,
      analysisResult: analysisResult ?? this.analysisResult,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedMode: selectedMode ?? this.selectedMode,
      coinPair: coinPair ?? this.coinPair,
    );
  }
}

// Analysis Notifier
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final Ref ref;

  AnalysisNotifier(this.ref) : super(AnalysisState());

  Future<void> selectImage(File image) async {
    state = state.copyWith(selectedImage: image, analysisResult: null);
  }

  void selectMode(AnalysisMode mode) {
    state = state.copyWith(selectedMode: mode);
  }

  void setCoinPair(String newCoinPair) {
    state = state.copyWith(coinPair: newCoinPair);
  }

  Future<void> analyzeImage() async {
    if (state.selectedImage == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final analysisService = ref.read(geminiAnalysisServiceProvider);
      final preferencesService = ref.read(preferencesServiceProvider);

      // Geçmiş analizler ve auth sağlayıcıları için ref kullan
      final analysisHistoryNotifier =
          ref.read(analysisHistoryProvider.notifier);
      final authState = ref.read(authStateProvider);

      // Analiz sonucunu al
      final result = await analysisService.analyzeCoinImage(
          state.selectedImage!, state.selectedMode);

      // Coin çiftini güncelle
      state = state.copyWith(coinPair: result.coinPair);

      // Analiz sonucunu geçmişe kaydet
      await preferencesService.saveAnalysisHistory(
          '${result.recommendation} - ${result.confidenceLevel}');

      // Firestore'a geçmiş analiz olarak kaydet
      if (authState.currentUser != null) {
        await analysisHistoryNotifier.saveAnalysisToHistory(
            result, state.coinPair // Dinamik coin çifti
            );
      }

      state = state.copyWith(
        analysisResult: result,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        analysisResult: null,
        error: 'Analiz yapılamadı: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  // Yardımcı metodlar
  String _generateRecommendation(
      double buyProb, double sellProb, double longProb, double shortProb) {
    List<MapEntry<String, double>> probabilities = [
      MapEntry('AL', buyProb),
      MapEntry('SAT', sellProb),
      MapEntry('LONG', longProb),
      MapEntry('SHORT', shortProb),
    ];

    probabilities.sort((a, b) => b.value.compareTo(a.value));

    if (probabilities[0].value > 60) {
      return '${probabilities[0].key} TAVSİYESİ';
    }
    return 'BEKLEYİNİZ';
  }

  String _calculateConfidenceLevel(
      double buyProb, double sellProb, double longProb, double shortProb) {
    double maxProb = [buyProb, sellProb, longProb, shortProb]
        .reduce((max, value) => max > value ? max : value);

    if (maxProb > 80) return 'YÜKSEK';
    if (maxProb > 60) return 'ORTA';
    return 'DÜŞÜK';
  }

  void resetAnalysis() {
    state = AnalysisState();
  }
}

// Analysis Provider
final analysisProvider =
    StateNotifierProvider<AnalysisNotifier, AnalysisState>((ref) {
  return AnalysisNotifier(ref);
});
