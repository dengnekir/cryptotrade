import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../analysis/model/analysis_model.dart';

class AIAnalysisService {
  final String _apiKey;
  final String _apiUrl;

  AIAnalysisService({
    required String apiKey,
    required String apiUrl,
  })  : _apiKey = apiKey,
        _apiUrl = apiUrl;

  Future<AnalysisResult> analyzeImage(File imageFile) async {
    try {
      // Resmi base64'e çevir
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // API isteği gönder
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'image': base64Image,
          'model': 'crypto-analysis',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // API yanıtını modele çevir
        return AnalysisResult(
          buyProbability: data['buy_probability'] ?? 0.0,
          sellProbability: data['sell_probability'] ?? 0.0,
          longProbability: data['long_probability'] ?? 0.0,
          shortProbability: data['short_probability'] ?? 0.0,
          recommendation: _generateRecommendation(
            data['buy_probability'] ?? 0.0,
            data['sell_probability'] ?? 0.0,
            data['long_probability'] ?? 0.0,
            data['short_probability'] ?? 0.0,
          ),
          confidenceLevel: _calculateConfidenceLevel(
            data['buy_probability'] ?? 0.0,
            data['sell_probability'] ?? 0.0,
            data['long_probability'] ?? 0.0,
            data['short_probability'] ?? 0.0,
          ),
        );
      } else {
        throw Exception('API yanıtı başarısız: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Görüntü analizi sırasında hata: $e');
    }
  }

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
}
