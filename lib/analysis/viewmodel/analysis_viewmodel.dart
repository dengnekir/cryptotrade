import 'dart:io';
import 'package:flutter/material.dart';
import '../model/analysis_model.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class AnalysisViewModel extends ChangeNotifier {
  AnalysisResult? _analysisResult;
  bool _isLoading = false;
  String? _error;

  AnalysisResult? get analysisResult => _analysisResult;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> analyzeImage(File imageFile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Görüntüyü ML Kit ile işleme
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Metin analizi sonuçlarını işleme
      final String text = recognizedText.text.toLowerCase();

      // Basit bir analiz algoritması (gerçek uygulamada daha gelişmiş olmalı)
      double buyProb =
          _calculateProbability(text, ['yükseliş', 'al', 'pozitif']);
      double sellProb =
          _calculateProbability(text, ['düşüş', 'sat', 'negatif']);
      double longProb = _calculateProbability(text, ['uzun vadeli', 'long']);
      double shortProb = _calculateProbability(text, ['kısa vadeli', 'short']);

      _analysisResult = AnalysisResult(
        buyProbability: buyProb,
        sellProbability: sellProb,
        longProbability: longProb,
        shortProbability: shortProb,
        recommendation: _generateRecommendation(buyProb, sellProb),
        confidenceLevel: _calculateConfidenceLevel(buyProb, sellProb),
      );

      await textRecognizer.close();
    } catch (e) {
      _error = 'Görüntü analizi sırasında bir hata oluştu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double _calculateProbability(String text, List<String> keywords) {
    int matches = 0;
    for (var keyword in keywords) {
      matches += RegExp(keyword).allMatches(text).length;
    }
    return (matches / keywords.length).clamp(0.0, 1.0) * 100;
  }

  String _generateRecommendation(double buyProb, double sellProb) {
    if (buyProb > sellProb && buyProb > 60) {
      return 'ALIŞ TAVSİYESİ';
    } else if (sellProb > buyProb && sellProb > 60) {
      return 'SATIŞ TAVSİYESİ';
    }
    return 'BEKLEYİNİZ';
  }

  String _calculateConfidenceLevel(double buyProb, double sellProb) {
    double maxProb =
        [buyProb, sellProb].reduce((max, value) => max > value ? max : value);
    if (maxProb > 80) return 'YÜKSEK';
    if (maxProb > 60) return 'ORTA';
    return 'DÜŞÜK';
  }

  void resetAnalysis() {
    _analysisResult = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
