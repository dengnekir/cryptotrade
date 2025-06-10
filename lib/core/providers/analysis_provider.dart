import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/gemini_analysis_service.dart';
import '../../core/services/preferences_service.dart';
import '../../analysis/model/analysis_model.dart';

// Gemini Analysis Service Provider
final geminiAnalysisServiceProvider =
    Provider((ref) => GeminiAnalysisService());

// Preferences Service Provider
final preferencesServiceProvider = Provider((ref) => PreferencesService());

// Analysis State
class AnalysisState {
  final File? selectedImage;
  final AnalysisResult? analysisResult;
  final bool isLoading;
  final String? error;

  AnalysisState({
    this.selectedImage,
    this.analysisResult,
    this.isLoading = false,
    this.error,
  });

  AnalysisState copyWith({
    File? selectedImage,
    AnalysisResult? analysisResult,
    bool? isLoading,
    String? error,
  }) {
    return AnalysisState(
      selectedImage: selectedImage ?? this.selectedImage,
      analysisResult: analysisResult ?? this.analysisResult,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
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

  Future<void> analyzeImage() async {
    if (state.selectedImage == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final analysisService = ref.read(geminiAnalysisServiceProvider);
      final preferencesService = ref.read(preferencesServiceProvider);

      final result =
          await analysisService.analyzeCoinImage(state.selectedImage!);

      // Analiz sonucunu geçmişe kaydet
      await preferencesService.saveAnalysisHistory(
          '${result.recommendation} - ${result.confidenceLevel}');

      state = state.copyWith(
        analysisResult: result,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
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
