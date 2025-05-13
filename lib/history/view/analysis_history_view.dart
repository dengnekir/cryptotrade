import 'package:flutter/material.dart';
import '../../core/widgets/colors.dart';

class AnalysisHistoryView extends StatelessWidget {
  const AnalysisHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Analiz Geçmişi',
          style: TextStyle(color: colorss.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorss.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildAnalysisList(),
          ],
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
            colorss.primaryColor.withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.2),
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
                color: colorss.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Geçmiş Analizler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorss.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Yapay zeka tarafından gerçekleştirilen tüm analizlerin geçmişi',
            style: TextStyle(
              fontSize: 16,
              color: colorss.textColorSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisList() {
    // TODO: Gerçek veriyi entegre et
    final List<String> positions = ['AL', 'SAT', 'LONG', 'SHORT'];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12, // Örnek veri sayısı
      itemBuilder: (context, index) {
        return _buildAnalysisCard(
          date: DateTime.now().subtract(Duration(days: index)),
          coinPair: 'BTC/USDT',
          position: positions[index % 4], // Sırayla AL, SAT, LONG, SHORT
          successRate: 85 + (index * 0.5),
          profitLoss: index % 2 == 0 ? 2.5 : -1.8,
          signals: ['RSI Aşırı Satım', 'MACD Kesişimi', 'Destek Seviyesi'],
        );
      },
    );
  }

  Widget _buildAnalysisCard({
    required DateTime date,
    required String coinPair,
    required String position,
    required double successRate,
    required double profitLoss,
    required List<String> signals,
  }) {
    final isProfit = profitLoss >= 0;
    final positionColor = switch (position) {
      'AL' || 'LONG' => Colors.green,
      'SAT' || 'SHORT' => Colors.red,
      _ => Colors.grey,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorss.backgroundColorLight.withOpacity(0.1),
            colorss.backgroundColorLight.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.textColorSecondary.withOpacity(0.1),
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
                position,
                style: TextStyle(
                  color: positionColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              coinPair,
              style: TextStyle(
                color: colorss.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}',
          style: TextStyle(
            color: colorss.textColorSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${profitLoss >= 0 ? '+' : ''}${profitLoss.toStringAsFixed(2)}%',
              style: TextStyle(
                color: isProfit ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Başarı: %${successRate.toStringAsFixed(1)}',
              style: TextStyle(
                color: colorss.textColorSecondary,
                fontSize: 12,
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
                Text(
                  'Sinyal Detayları:',
                  style: TextStyle(
                    color: colorss.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...signals.map((signal) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_right,
                            color: colorss.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            signal,
                            style: TextStyle(
                              color: colorss.textColor,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
