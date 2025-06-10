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

      // Coin ve para birimini tespit etmek için ek prompt
      String coinDetectionPrompt = '''
Görüntüdeki kripto para birimini ve işlem çiftini (örneğin BTC/USDT, ETH/TRY) kesin olarak belirle.
Eğer birden fazla coin varsa, analiz için en uygun olanı seç.
Cevabı şu formatta ver:
Coin: [Coin Adı]
Para Birimi: [Para Birimi]
''';

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
                {'text': coinDetectionPrompt}
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

        // Coin ve para birimi tespiti
        final coinDetectionText =
            data['candidates'][0]['content']['parts'][0]['text'];

        print('Coin Tespit Sonucu: $coinDetectionText');

        // Coin ve para birimini çıkart (daha esnek regex)
        final coinMatch =
            RegExp(r'Coin:\s*([A-Z]+)').firstMatch(coinDetectionText);
        final currencyMatch =
            RegExp(r'Para Birimi:\s*([A-Z]+)').firstMatch(coinDetectionText);

        // Desteklenen para birimleri listesi
        final supportedCurrencies = ['USDT', 'TRY', 'USD', 'EUR', 'BTC'];

        final detectedCoin = coinMatch?.group(1) ?? 'BTC';
        final detectedCurrency = currencyMatch?.group(1) ?? 'USDT';

        // Para birimini doğrula, desteklenmiyorsa USDT'ye çevir
        final finalCurrency = supportedCurrencies.contains(detectedCurrency)
            ? detectedCurrency
            : 'USDT';

        final coinPair = '$detectedCoin/$finalCurrency';

        print('Algılanan Coin: $detectedCoin');
        print('Algılanan Para Birimi: $detectedCurrency');
        print('Son Coin Çifti: $coinPair');

        // Analiz için ikinci API çağrısı
        final analysisResponse = await http.post(
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
                    'inlineData': {
                      'mimeType': 'image/jpeg',
                      'data': base64Image
                    }
                  },
                  {
                    'text':
                        '$modeSpecificPrompt\n\nAnaliz edilen coin: $coinPair'
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

        if (analysisResponse.statusCode == 200) {
          final analysisData = jsonDecode(analysisResponse.body);

          // Gemini'den gelen yanıtı parse et
          final responseText =
              analysisData['candidates'][0]['content']['parts'][0]['text'];

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
          return _createAnalysisResult(
              selectedMode, probabilities, responseText, coinPair);
        } else {
          throw Exception(
              'Analiz API yanıtı başarısız: ${analysisResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Coin tespit API yanıtı başarısız: ${response.statusCode}');
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
Kesin ve net yüzde tahminleri yap.
Grafikteki alım sinyallerini detaylı incele.

ÖNEMLİ KURALLAR:
1. Yüzdelerin toplamı 100 olmak ZORUNDA DEĞİL
2. Gerçekçi ve net tahminler yap
3. Yüzdeleri 5'er 10'ar artır (örn. 35%, 65%, 72%, 28%)
4. Aşırı kesin ve net yüzdeler ver

Cevabı mutlaka şu formatta ver:
AL: X%
SAT: Y%

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi Trendi
* RSI Yorumu
* MACD Sinyalleri
* Destek-Direnç Seviyeleri
* Genel Piyasa Yorumu
''';
      case AnalysisMode.sell:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
Kesin ve net yüzde tahminleri yap.
Grafikteki satım sinyallerini detaylı incele.

ÖNEMLİ KURALLAR:
1. Yüzdelerin toplamı 100 olmak ZORUNDA DEĞİL
2. Gerçekçi ve net tahminler yap
3. Yüzdeleri 5'er 10'ar artır (örn. 35%, 65%, 72%, 28%)
4. Aşırı kesin ve net yüzdeler ver

Cevabı mutlaka şu formatta ver:
AL: X%
SAT: Y%

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi Trendi
* RSI Yorumu
* MACD Sinyalleri
* Destek-Direnç Seviyeleri
* Genel Piyasa Yorumu
''';
      case AnalysisMode.long:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
Kesin ve net yüzde tahminleri yap.
Grafikteki uzun pozisyon alma sinyallerini detaylı incele.

ÖNEMLİ KURALLAR:
1. Yüzdelerin toplamı 100 olmak ZORUNDA DEĞİL
2. Gerçekçi ve net tahminler yap
3. Yüzdeleri 5'er 10'ar artır (örn. 35%, 65%, 72%, 28%)
4. Aşırı kesin ve net yüzdeler ver

Cevabı mutlaka şu formatta ver:
LONG: X%
SHORT: Y%

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi Trendi
* RSI Yorumu
* MACD Sinyalleri
* Destek-Direnç Seviyeleri
* Genel Piyasa Yorumu
''';
      case AnalysisMode.short:
        return '''
Bu kripto para grafik görüntüsünü profesyonel bir trader gibi analiz et. 
Kesin ve net yüzde tahminleri yap.
Grafikteki kısa pozisyon alma sinyallerini detaylı incele.

ÖNEMLİ KURALLAR:
1. Yüzdelerin toplamı 100 olmak ZORUNDA DEĞİL
2. Gerçekçi ve net tahminler yap
3. Yüzdeleri 5'er 10'ar artır (örn. 35%, 65%, 72%, 28%)
4. Aşırı kesin ve net yüzdeler ver

Cevabı mutlaka şu formatta ver:
LONG: X%
SHORT: Y%

Analiz detaylarını da açıkça belirt:
* Fiyat Hareketi Trendi
* RSI Yorumu
* MACD Sinyalleri
* Destek-Direnç Seviyeleri
* Genel Piyasa Yorumu
''';
    }
  }

  // Seçilen moda göre analiz sonucu oluştur
  AnalysisResult _createAnalysisResult(AnalysisMode mode,
      Map<String, double> probabilities, String responseText, String coinPair) {
    // Yüzdeleri normalize et ve daha gerçekçi hale getir
    final normalizedProbabilities = _normalizeProbabilities(probabilities);

    switch (mode) {
      case AnalysisMode.buy:
        return AnalysisResult(
          buyProbability: normalizedProbabilities['AL'] ?? 0.0,
          sellProbability: normalizedProbabilities['SAT'] ?? 0.0,
          longProbability: 0.0,
          shortProbability: 0.0,
          recommendation:
              normalizedProbabilities['AL']! > normalizedProbabilities['SAT']!
                  ? 'AL'
                  : 'SAT',
          confidenceLevel: _calculateConfidenceLevel(
              normalizedProbabilities['AL'] ?? 0.0,
              normalizedProbabilities['SAT'] ?? 0.0,
              0.0,
              0.0),
          analysisDetails: responseText,
          coinPair: coinPair,
        );
      case AnalysisMode.sell:
        return AnalysisResult(
          buyProbability: normalizedProbabilities['AL'] ?? 0.0,
          sellProbability: normalizedProbabilities['SAT'] ?? 0.0,
          longProbability: 0.0,
          shortProbability: 0.0,
          recommendation:
              normalizedProbabilities['SAT']! > normalizedProbabilities['AL']!
                  ? 'SAT'
                  : 'AL',
          confidenceLevel: _calculateConfidenceLevel(
              normalizedProbabilities['AL'] ?? 0.0,
              normalizedProbabilities['SAT'] ?? 0.0,
              0.0,
              0.0),
          analysisDetails: responseText,
          coinPair: coinPair,
        );
      case AnalysisMode.long:
        return AnalysisResult(
          buyProbability: 0.0,
          sellProbability: 0.0,
          longProbability: normalizedProbabilities['LONG'] ?? 0.0,
          shortProbability: normalizedProbabilities['SHORT'] ?? 0.0,
          recommendation: normalizedProbabilities['LONG']! >
                  normalizedProbabilities['SHORT']!
              ? 'LONG'
              : 'SHORT',
          confidenceLevel: _calculateConfidenceLevel(
              0.0,
              0.0,
              normalizedProbabilities['LONG'] ?? 0.0,
              normalizedProbabilities['SHORT'] ?? 0.0),
          analysisDetails: responseText,
          coinPair: coinPair,
        );
      case AnalysisMode.short:
        return AnalysisResult(
          buyProbability: 0.0,
          sellProbability: 0.0,
          longProbability: normalizedProbabilities['LONG'] ?? 0.0,
          shortProbability: normalizedProbabilities['SHORT'] ?? 0.0,
          recommendation: normalizedProbabilities['SHORT']! >
                  normalizedProbabilities['LONG']!
              ? 'SHORT'
              : 'LONG',
          confidenceLevel: _calculateConfidenceLevel(
              0.0,
              0.0,
              normalizedProbabilities['LONG'] ?? 0.0,
              normalizedProbabilities['SHORT'] ?? 0.0),
          analysisDetails: responseText,
          coinPair: coinPair,
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

  // Yüzdeleri normalize eden ve gerçekçi hale getiren yardımcı metot
  Map<String, double> _normalizeProbabilities(
      Map<String, double> probabilities) {
    // Eğer yüzdeler çok yakınsa, daha belirgin hale getir
    final keys = probabilities.keys.toList();
    if (keys.length == 2) {
      final first = probabilities[keys[0]] ?? 0.0;
      final second = probabilities[keys[1]] ?? 0.0;

      // Yüzdeleri 65-35 veya 72-28 gibi daha net aralıklara getir
      if ((first - second).abs() < 10) {
        if (first > second) {
          probabilities[keys[0]] = 65.0;
          probabilities[keys[1]] = 35.0;
        } else {
          probabilities[keys[0]] = 35.0;
          probabilities[keys[1]] = 65.0;
        }
      }
    }

    return probabilities;
  }
}
