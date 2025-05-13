import 'package:flutter/material.dart';
import '../../../core/widgets/colors.dart';

class AnalysisPreferencesView extends StatefulWidget {
  const AnalysisPreferencesView({Key? key}) : super(key: key);

  @override
  State<AnalysisPreferencesView> createState() =>
      _AnalysisPreferencesViewState();
}

class _AnalysisPreferencesViewState extends State<AnalysisPreferencesView> {
  String _selectedTimeframe = '1h';
  String _selectedIndicator = 'RSI';
  double _analysisFrequency = 1.0;
  bool _autoTrade = false;

  final List<String> _timeframes = ['5m', '15m', '30m', '1h', '4h', '1d'];
  final List<String> _indicators = [
    'RSI',
    'MACD',
    'Bollinger Bands',
    'Moving Average',
    'Volume',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Analiz Tercihleri',
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
            _buildTimeframeSection(),
            const SizedBox(height: 24),
            _buildIndicatorSection(),
            const SizedBox(height: 24),
            _buildFrequencySection(),
            const SizedBox(height: 24),
            _buildAutoTradeSection(),
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
                Icons.analytics,
                color: colorss.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Analiz Tercihleri',
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
            'Yapay zeka analizlerinin nasıl çalışacağını özelleştirin. Tercihlerinize göre daha isabetli sinyaller alın.',
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

  Widget _buildTimeframeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zaman Aralığı',
          style: TextStyle(
            color: colorss.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: colorss.backgroundColorLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorss.textColorSecondary.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _timeframes.map((timeframe) {
              final isSelected = timeframe == _selectedTimeframe;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeframe = timeframe;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorss.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeframe,
                    style: TextStyle(
                      color: isSelected ? Colors.black : colorss.textColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tercih Edilen Gösterge',
          style: TextStyle(
            color: colorss.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorss.backgroundColorLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorss.textColorSecondary.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: _indicators.map((indicator) {
              final isSelected = indicator == _selectedIndicator;
              return RadioListTile(
                value: indicator,
                groupValue: _selectedIndicator,
                onChanged: (value) {
                  setState(() {
                    _selectedIndicator = value.toString();
                  });
                },
                title: Text(
                  indicator,
                  style: TextStyle(
                    color: colorss.textColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                activeColor: colorss.primaryColor,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analiz Sıklığı',
          style: TextStyle(
            color: colorss.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorss.backgroundColorLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorss.textColorSecondary.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Her ${_analysisFrequency.round()} saatte bir',
                    style: TextStyle(
                      color: colorss.textColor,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${(24 / _analysisFrequency).round()} analiz/gün',
                    style: TextStyle(
                      color: colorss.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _analysisFrequency,
                min: 1,
                max: 12,
                divisions: 11,
                activeColor: colorss.primaryColor,
                inactiveColor: colorss.textColorSecondary.withOpacity(0.2),
                onChanged: (value) {
                  setState(() {
                    _analysisFrequency = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoTradeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorss.backgroundColorLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.textColorSecondary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: _autoTrade,
            onChanged: (value) {
              setState(() {
                _autoTrade = value;
              });
            },
            title: Row(
              children: [
                Icon(
                  Icons.auto_graph,
                  color: colorss.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Otomatik İşlem',
                  style: TextStyle(
                    color: colorss.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Analiz sinyallerine göre otomatik alım/satım işlemleri gerçekleştir',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            activeColor: colorss.primaryColor,
            inactiveThumbColor: colorss.textColorSecondary,
          ),
          if (_autoTrade) ...[
            const Divider(height: 24),
            ListTile(
              leading: Icon(
                Icons.warning_amber,
                color: Colors.amber,
              ),
              title: Text(
                'Dikkat',
                style: TextStyle(
                  color: colorss.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Otomatik işlemler riskli olabilir. Lütfen risk yönetimi ayarlarınızı kontrol edin.',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
