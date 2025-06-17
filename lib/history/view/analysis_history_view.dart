import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/colors.dart';
import '../provider/analysis_history_provider.dart';
import '../../analysis/model/analysis_model.dart';
import '../../core/auth/providers/auth_provider.dart';

class AnalysisHistoryView extends ConsumerStatefulWidget {
  const AnalysisHistoryView({Key? key}) : super(key: key);

  @override
  _AnalysisHistoryViewState createState() => _AnalysisHistoryViewState();
}

class _AnalysisHistoryViewState extends ConsumerState<AnalysisHistoryView> {
  @override
  void initState() {
    super.initState();

    // Geçmiş analizleri yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analysisHistoryProvider.notifier).fetchAnalysisHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(analysisHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Analiz Geçmişi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              // Tüm geçmişi silme onayı için dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(Icons.warning_rounded,
                            color: colorss.primaryColor, size: 32),
                        SizedBox(width: 12),
                        Text(
                          'Tüm Geçmişi Sil',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'Tüm analiz geçmişini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        child: Text('İptal'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Tümünü Sil'),
                        onPressed: () {
                          // Tüm geçmişi sil
                          ref
                              .read(analysisHistoryProvider.notifier)
                              .clearAnalysisHistory();
                          Navigator.of(context).pop();

                          // Bilgilendirme
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tüm analiz geçmişi silindi'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(analysisHistoryProvider.notifier)
              .fetchAnalysisHistory();
        },
        color: colorss.primaryColor,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              if (historyState.isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: colorss.primaryColor,
                  ),
                )
              else if (historyState.error != null)
                _buildErrorWidget(historyState.error!)
              else if (historyState.analysisList.isEmpty)
                _buildEmptyStateWidget()
              else
                _buildAnalysisList(historyState.analysisList),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorss.primaryColor,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.backgroundColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: colorss.primaryColorDark,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Geçmiş Analizler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Yapay zeka tarafından gerçekleştirilen tüm analizlerin geçmişi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        error,
        style: TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyStateWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorss.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: colorss.primaryColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz bir analiz geçmişiniz yok',
            style: TextStyle(
              color: colorss.backgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk analizinizi yaparak geçmişinizi oluşturabilirsiniz',
            style: TextStyle(
              color: colorss.backgroundColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisList(List<AnalysisResult> analysisList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: analysisList.length,
      itemBuilder: (context, index) {
        final analysis = analysisList[index];
        return _buildAnalysisCard(analysis);
      },
    );
  }

  Widget _buildAnalysisCard(AnalysisResult analysis) {
    final positionColor = switch (analysis.recommendation) {
      'AL' || 'LONG' => Colors.green,
      'SAT' || 'SHORT' => Colors.red,
      _ => Colors.grey,
    };

    // Debug için log ekle
    print('Görüntülenen Analiz Bilgileri:');
    print('Coin Çifti: ${analysis.coinPair}');
    print('Recommendation: ${analysis.recommendation}');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorss.primaryColor.withAlpha(1),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.1),
        ),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: positionColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                analysis.recommendation,
                style: TextStyle(
                  color: positionColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              // Coin çiftini doğrudan al
              analysis.coinPair,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          analysis.timestamp.isNotEmpty
              ? analysis.timestamp
              : 'Tarih bilgisi bulunamadı',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              analysis.confidenceLevel,
              style: TextStyle(
                color: positionColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Olasılık çipleri
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProbabilityChip(
                        'AL', analysis.buyProbability, Colors.green),
                    _buildProbabilityChip(
                        'SAT', analysis.sellProbability, Colors.red),
                    _buildProbabilityChip(
                        'LONG', analysis.longProbability, Colors.blue),
                    _buildProbabilityChip(
                        'SHORT', analysis.shortProbability, Colors.orange),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  'Analiz Detayları:',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                // Detaylı analiz metnini parse et ve göster
                ..._parseAnalysisDetails(analysis.analysisDetails),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Detaylı analiz metnini parse eden metot
  List<Widget> _parseAnalysisDetails(String details) {
    // Detayları satır satır böl
    final lines = details.split('\n');

    // Widget listesi oluştur
    List<Widget> detailWidgets = [];

    for (var line in lines) {
      // Yıldızlı başlıkları ve içeriklerini ayır
      if (line.startsWith('* **') &&
          !line.contains('LONG') &&
          !line.contains('SHORT')) {
        // Başlığı ve içeriği çıkar
        final title = line.replaceAll('* **', '').replaceAll(':**', '');

        detailWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return detailWidgets;
  }

  // Olasılık çipi widget'ı
  Widget _buildProbabilityChip(String label, double probability, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: %${probability.toStringAsFixed(1)}',
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}
