import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/services/ai_analysis_service.dart';
import '../model/analysis_model.dart';

class AnalysisViewModel extends ChangeNotifier {
  AIAnalysisService _aiService;
  AnalysisResult? _analysisResult;
  bool _isLoading = false;
  String? _error;
  File? _selectedImage;

  AnalysisViewModel({
    required AIAnalysisService aiService,
  }) : _aiService = aiService;

  AnalysisResult? get analysisResult => _analysisResult;
  bool get isLoading => _isLoading;
  String? get error => _error;
  File? get selectedImage => _selectedImage;

  void updateService(AIAnalysisService aiService) {
    _aiService = aiService;
  }

  Future<void> analyzeImage(File imageFile) async {
    try {
      _isLoading = true;
      _error = null;
      _selectedImage = imageFile;
      notifyListeners();

      // Yapay zeka servisi çağrısı
      _analysisResult = await _aiService.analyzeImage(imageFile);
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
    _selectedImage = null;
    notifyListeners();
  }
}
