import 'package:flutter/material.dart';
import '../../../core/widgets/colors.dart';

class RiskLevelView extends StatefulWidget {
  const RiskLevelView({Key? key}) : super(key: key);

  @override
  State<RiskLevelView> createState() => _RiskLevelViewState();
}

class _RiskLevelViewState extends State<RiskLevelView> {
  double _riskLevel = 2;
  double _stopLoss = 5;
  double _takeProfit = 10;
  double _maxInvestmentPerTrade = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Risk Seviyesi',
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
            _buildRiskLevelSection(),
            const SizedBox(height: 24),
            _buildStopLossSection(),
            const SizedBox(height: 24),
            _buildTakeProfitSection(),
            const SizedBox(height: 24),
            _buildMaxInvestmentSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
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
                Icons.warning_amber,
                color: colorss.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Risk Yönetimi',
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
            'Risk seviyenizi ve işlem limitlerini belirleyin. Doğru risk yönetimi, başarılı yatırımın temelidir.',
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

  Widget _buildRiskLevelSection() {
    return _buildSettingSection(
      title: 'Risk Seviyesi',
      subtitle: _getRiskLevelDescription(),
      icon: Icons.speed,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Düşük',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                'Yüksek',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Slider(
            value: _riskLevel,
            min: 1,
            max: 3,
            divisions: 2,
            activeColor: _getRiskLevelColor(),
            inactiveColor: colorss.textColorSecondary.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _riskLevel = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStopLossSection() {
    return _buildSettingSection(
      title: 'Stop Loss',
      subtitle: 'Maksimum zarar toleransı: %${_stopLoss.round()}',
      icon: Icons.trending_down,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '%1',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                '%20',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Slider(
            value: _stopLoss,
            min: 1,
            max: 20,
            divisions: 19,
            activeColor: Colors.red,
            inactiveColor: colorss.textColorSecondary.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _stopLoss = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTakeProfitSection() {
    return _buildSettingSection(
      title: 'Take Profit',
      subtitle: 'Hedef kar oranı: %${_takeProfit.round()}',
      icon: Icons.trending_up,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '%5',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                '%50',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Slider(
            value: _takeProfit,
            min: 5,
            max: 50,
            divisions: 45,
            activeColor: Colors.green,
            inactiveColor: colorss.textColorSecondary.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _takeProfit = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaxInvestmentSection() {
    return _buildSettingSection(
      title: 'Maksimum İşlem Büyüklüğü',
      subtitle: 'Toplam portföyün %${_maxInvestmentPerTrade.round()}\'i',
      icon: Icons.account_balance_wallet,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '%5',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                '%50',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Slider(
            value: _maxInvestmentPerTrade,
            min: 5,
            max: 50,
            divisions: 45,
            activeColor: colorss.primaryColor,
            inactiveColor: colorss.textColorSecondary.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _maxInvestmentPerTrade = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: colorss.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorss.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorss.textColorSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Save risk settings
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorss.primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Ayarları Kaydet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getRiskLevelDescription() {
    switch (_riskLevel.round()) {
      case 1:
        return 'Düşük risk, düşük getiri potansiyeli';
      case 2:
        return 'Orta risk, dengeli getiri potansiyeli';
      case 3:
        return 'Yüksek risk, yüksek getiri potansiyeli';
      default:
        return '';
    }
  }

  Color _getRiskLevelColor() {
    switch (_riskLevel.round()) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return colorss.primaryColor;
    }
  }
}
