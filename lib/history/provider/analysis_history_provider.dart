import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../analysis/model/analysis_model.dart';
import '../../core/auth/providers/auth_provider.dart';

class AnalysisHistoryState {
  final List<AnalysisResult> analysisList;
  final bool isLoading;
  final String? error;

  AnalysisHistoryState({
    this.analysisList = const [],
    this.isLoading = false,
    this.error,
  });

  AnalysisHistoryState copyWith({
    List<AnalysisResult>? analysisList,
    bool? isLoading,
    String? error,
  }) {
    return AnalysisHistoryState(
      analysisList: analysisList ?? this.analysisList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AnalysisHistoryNotifier extends StateNotifier<AnalysisHistoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref ref;

  AnalysisHistoryNotifier(this.ref) : super(AnalysisHistoryState());

  Future<void> fetchAnalysisHistory() async {
    // Auth sağlayıcısından kullanıcı bilgisini al
    final authState = ref.read(authStateProvider);

    // Kullanıcı girişi kontrolü
    if (authState.currentUser == null) {
      state =
          state.copyWith(isLoading: false, error: 'Lütfen önce giriş yapın');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Debug için log ekle
      print('Kullanıcı ID: ${authState.currentUser!.uid}');
      print('Firestore sorgusu başlatılıyor...');

      final querySnapshot = await _firestore
          .collection('analysis_history')
          .doc(authState.currentUser!.uid)
          .collection('analyses')
          .orderBy('timestamp', descending: true)
          .get()
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException('Zaman aşımı'));

      print('Sorgu tamamlandı. Döküman sayısı: ${querySnapshot.docs.length}');

      final analysisList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        print('Döküman verisi: $data'); // Debug için log

        // Timestamp'ı okunabilir formata çevir
        String formattedTimestamp = '';
        if (data['timestamp'] != null) {
          final timestamp = (data['timestamp'] as Timestamp).toDate();
          formattedTimestamp = _formatTimestamp(timestamp);
        }

        return AnalysisResult(
          buyProbability: (data['buyProbability'] as num?)?.toDouble() ?? 0.0,
          sellProbability: (data['sellProbability'] as num?)?.toDouble() ?? 0.0,
          longProbability: (data['longProbability'] as num?)?.toDouble() ?? 0.0,
          shortProbability:
              (data['shortProbability'] as num?)?.toDouble() ?? 0.0,
          recommendation: data['recommendation']?.toString() ?? '',
          confidenceLevel: data['confidenceLevel']?.toString() ?? '',
          analysisDetails: data['analysisDetails']?.toString() ?? '',
          timestamp: formattedTimestamp, // Yeni eklenen timestamp
        );
      }).toList();

      state = state.copyWith(
        analysisList: analysisList,
        isLoading: false,
      );

      print(
          'Analiz listesi güncellendi. Toplam analiz: ${analysisList.length}');
    } catch (e) {
      print('Hata oluştu: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Geçmiş analizler yüklenemedi: $e',
        analysisList: [], // Boş liste olarak ayarla
      );
    }
  }

  // Timestamp'ı okunabilir formata çeviren yardımcı metod
  String _formatTimestamp(DateTime timestamp) {
    final localTimestamp = timestamp.toLocal(); // UTC'yi yerel saate çevir
    return '${_getMonthName(localTimestamp.month)} ${localTimestamp.day}, '
        '${localTimestamp.year} at '
        '${_formatTime(localTimestamp)} UTC+3';
  }

  // Ay ismini alan yardımcı metod
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  // Zamanı 12 saat formatında alan yardımcı metod
  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = 'AM';

    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;

    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second $period';
  }

  // Hata ayarlama metodu
  void setError(String errorMessage) {
    state = state.copyWith(
      isLoading: false,
      error: errorMessage,
    );
  }

  Future<void> saveAnalysisToHistory(
    AnalysisResult analysisResult,
    String coinPair,
  ) async {
    final authState = ref.read(authStateProvider);

    if (authState.currentUser == null) return;

    try {
      await _firestore
          .collection('analysis_history')
          .doc(authState.currentUser!.uid)
          .collection('analyses')
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'coinPair': coinPair,
        'buyProbability': analysisResult.buyProbability,
        'sellProbability': analysisResult.sellProbability,
        'longProbability': analysisResult.longProbability,
        'shortProbability': analysisResult.shortProbability,
        'recommendation': analysisResult.recommendation,
        'confidenceLevel': analysisResult.confidenceLevel,
        'analysisDetails': analysisResult.analysisDetails,
      });
    } catch (e) {
      print('Analiz geçmişine kaydetme hatası: $e');
    }
  }
}

final analysisHistoryProvider =
    StateNotifierProvider<AnalysisHistoryNotifier, AnalysisHistoryState>((ref) {
  return AnalysisHistoryNotifier(ref);
});
