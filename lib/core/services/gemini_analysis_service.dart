import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../analysis/model/analysis_model.dart';
import '../constants/api_constants.dart';
import '../../core/providers/analysis_provider.dart';

class GeminiAnalysisService {
  Future<AnalysisResult> analyzeCoinImage(
      File imageFile, AnalysisMode selectedMode) async {
    try {
      // Resmi base64'e çevir
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Seçilen moda göre özel prompt
      String modeSpecificPrompt = _generateModeSpecificPrompt(selectedMode);

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
                {'text': modeSpecificPrompt}
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

        print('Gemini Response Text: $responseText');

        // Yanıttan yüzdelikleri çıkar
        final probabilityMatch =
            RegExp(r'(\w+):\s*(\d+)%').allMatches(responseText);

        if (probabilityMatch.isEmpty) {
          throw Exception('Yapay zeka geçerli yüzde hesaplayamadı');
        }

        // Yüzdeleri dinamik olarak al
        Map<String, double> probabilities = {};
        for (var match in probabilityMatch) {
          probabilities[match.group(1)!] = double.parse(match.group(2)!);
        }

        // Seçilen moda göre sonuç oluştur
        return _createAnalysisResult(selectedMode, probabilities, responseText);
      } else {
        throw Exception('API yanıtı başarısız: ${response.statusCode}');
      }
    } catch (e) {
      print('Analiz sırasında hata: $e');
      throw Exception('Görüntü analizi sırasında hata: $e');
    }
  }

  // Seçilen moda göre özel prompt oluştur
  String _generateModeSpecificPrompt(AnalysisMode mode) {
    switch (mode) {
      case AnalysisMode.buy:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
AL için kesin ve net yüzde tahmini yap.
Grafikteki alım sinyallerini detaylı incele.

Cevabı mutlaka şu formatta ver:
AL: X%
SAT: Y%

Yüzdelerin toplamı 100 olmak zorunda DEĞİL. 
Gerçekçi ve net bir tahmin yap.

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi
* RSI (Görelilik Güç Endeksi)
* MACD (Hareketli Ortalama Yakınsama-Uzaklaşma)
* Hareketli Ortalamalar (MA)
* Destek-Direnç Seviyeleri
''';
      case AnalysisMode.sell:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
SAT için kesin ve net yüzde tahmini yap.
Grafikteki satım sinyallerini detaylı incele.

Cevabı mutlaka şu formatta ver:
AL: X%
SAT: Y%

Yüzdelerin toplamı 100 olmak zorunda DEĞİL. 
Gerçekçi ve net bir tahmin yap.

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi
* RSI (Görelilik Güç Endeksi)
* MACD (Hareketli Ortalama Yakınsama-Uzaklaşma)
* Hareketli Ortalamalar (MA)
* Destek-Direnç Seviyeleri
''';
      case AnalysisMode.long:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
LONG için kesin ve net yüzde tahmini yap.
Grafikteki uzun pozisyon alma sinyallerini detaylı incele.

Cevabı mutlaka şu formatta ver:
LONG: X%
SHORT: Y%

Yüzdelerin toplamı 100 olmak zorunda DEĞİL. 
Gerçekçi ve net bir tahmin yap.

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi
* RSI (Görelilik Güç Endeksi)
* MACD (Hareketli Ortalama Yakınsama-Uzaklaşma)
* Hareketli Ortalamalar (MA)
* Destek-Direnç Seviyeleri
''';
      case AnalysisMode.short:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
SHORT için kesin ve net yüzde tahmini yap.
Grafikteki kısa pozisyon alma sinyallerini detaylı incele.

Cevabı mutlaka şu formatta ver:
LONG: X%
SHORT: Y%

Yüzdelerin toplamı 100 olmak zorunda DEĞİL. 
Gerçekçi ve net bir tahmin yap.

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi
* RSI (Görelilik Güç Endeksi)
* MACD (Hareketli Ortalama Yakınsama-Uzaklaşma)
* Hareketli Ortalamalar (MA)
* Destek-Direnç Seviyeleri
''';
    }
  }

  // Seçilen moda göre analiz sonucu oluştur
  AnalysisResult _createAnalysisResult(AnalysisMode mode,
      Map<String, double> probabilities, String responseText) {
    switch (mode) {
      case AnalysisMode.buy:
        return AnalysisResult(
          buyProbability: probabilities['AL'] ?? 0.0,
          sellProbability: probabilities['SAT'] ?? 0.0,
          longProbability: 0.0,
          shortProbability: 0.0,
          recommendation:
              probabilities['AL']! > probabilities['SAT']! ? 'AL' : 'SAT',
          confidenceLevel: _calculateConfidenceLevel(probabilities['AL'] ?? 0.0,
              probabilities['SAT'] ?? 0.0, 0.0, 0.0),
          analysisDetails: responseText,
        );
      case AnalysisMode.sell:
        return AnalysisResult(
          buyProbability: probabilities['AL'] ?? 0.0,
          sellProbability: probabilities['SAT'] ?? 0.0,
          longProbability: 0.0,
          shortProbability: 0.0,
          recommendation:
              probabilities['SAT']! > probabilities['AL']! ? 'SAT' : 'AL',
          confidenceLevel: _calculateConfidenceLevel(probabilities['AL'] ?? 0.0,
              probabilities['SAT'] ?? 0.0, 0.0, 0.0),
          analysisDetails: responseText,
        );
      case AnalysisMode.long:
        return AnalysisResult(
          buyProbability: 0.0,
          sellProbability: 0.0,
          longProbability: probabilities['LONG'] ?? 0.0,
          shortProbability: probabilities['SHORT'] ?? 0.0,
          recommendation: probabilities['LONG']! > probabilities['SHORT']!
              ? 'LONG'
              : 'SHORT',
          confidenceLevel: _calculateConfidenceLevel(0.0, 0.0,
              probabilities['LONG'] ?? 0.0, probabilities['SHORT'] ?? 0.0),
          analysisDetails: responseText,
        );
      case AnalysisMode.short:
        return AnalysisResult(
          buyProbability: 0.0,
          sellProbability: 0.0,
          longProbability: probabilities['LONG'] ?? 0.0,
          shortProbability: probabilities['SHORT'] ?? 0.0,
          recommendation: probabilities['SHORT']! > probabilities['LONG']!
              ? 'SHORT'
              : 'LONG',
          confidenceLevel: _calculateConfidenceLevel(0.0, 0.0,
              probabilities['LONG'] ?? 0.0, probabilities['SHORT'] ?? 0.0),
          analysisDetails: responseText,
        );
    }
  }

  String _calculateConfidenceLevel(
      double buyProb, double sellProb, double longProb, double shortProb) {
    // Seçilen kategorinin maksimum olasılığına göre güven seviyesi
    final maxProb = [buyProb, sellProb, longProb, shortProb]
        .reduce((max, value) => max > value ? max : value);

    if (maxProb > 80) return 'YÜKSEK';
    if (maxProb > 60) return 'ORTA';
    return 'DÜŞÜK';
  }
}
