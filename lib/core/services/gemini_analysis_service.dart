import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../analysis/model/analysis_model.dart';
import '../constants/api_constants.dart';

class GeminiAnalysisService {
  Future<AnalysisResult> analyzeCoinImage(File imageFile) async {
    try {
      // Resmi base64'e çevir
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Gemini API isteği
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.geminiApiUrl}?key=${ApiConstants.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'inlineData': {'mimeType': 'image/jpeg', 'data': base64Image}
                },
                {
                  'text':
                      'Bu coin grafik görüntüsünü analiz et. Kesin olarak AL, SAT, LONG, SHORT için yüzdelik tahminler ver. Sadece kripto para grafikleri için analiz yap. Cevabı şu formatta ver: AL: X%, SAT: Y%, LONG: Z%, SHORT: W%'
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.4,
            'topK': 32,
            'topP': 1,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Gemini'den gelen yanıtı parse et
        final responseText =
            data['candidates'][0]['content']['parts'][0]['text'];

        // Yanıttan yüzdelikleri çıkar
        final buyMatch = RegExp(r'AL:\s*(\d+)%').firstMatch(responseText);
        final sellMatch = RegExp(r'SAT:\s*(\d+)%').firstMatch(responseText);
        final longMatch = RegExp(r'LONG:\s*(\d+)%').firstMatch(responseText);
        final shortMatch = RegExp(r'SHORT:\s*(\d+)%').firstMatch(responseText);

        final buyProbability =
            buyMatch != null ? double.parse(buyMatch.group(1)!) : 0.0;
        final sellProbability =
            sellMatch != null ? double.parse(sellMatch.group(1)!) : 0.0;
        final longProbability =
            longMatch != null ? double.parse(longMatch.group(1)!) : 0.0;
        final shortProbability =
            shortMatch != null ? double.parse(shortMatch.group(1)!) : 0.0;

        return AnalysisResult(
          buyProbability: buyProbability,
          sellProbability: sellProbability,
          longProbability: longProbability,
          shortProbability: shortProbability,
          recommendation: _generateRecommendation(buyProbability,
              sellProbability, longProbability, shortProbability),
          confidenceLevel: _calculateConfidenceLevel(buyProbability,
              sellProbability, longProbability, shortProbability),
        );
      } else {
        // Hata detaylarını yazdır
        print('API Yanıt Kodu: ${response.statusCode}');
        print('API Yanıt Gövdesi: ${response.body}');
        throw Exception('API yanıtı başarısız: ${response.statusCode}');
      }
    } catch (e) {
      print('Analiz sırasında hata: $e');
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
