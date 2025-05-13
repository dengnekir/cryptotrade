import 'package:flutter/material.dart';
import '../../../core/widgets/colors.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool _generalNotifications = true;
  bool _priceAlerts = true;
  bool _trendingAlerts = true;
  bool _newsAlerts = true;
  bool _portfolioUpdates = true;
  bool _marketUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Bildirim Ayarları',
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
            _buildNotificationSection(
              title: 'Genel Bildirimler',
              subtitle: 'Tüm bildirimleri aç/kapat',
              value: _generalNotifications,
              onChanged: (value) {
                setState(() {
                  _generalNotifications = value;
                });
              },
              icon: Icons.notifications,
            ),
            const Divider(height: 32),
            _buildNotificationSection(
              title: 'Fiyat Alarmları',
              subtitle:
                  'Belirlediğiniz fiyat hedeflerine ulaşıldığında bildirim alın',
              value: _priceAlerts,
              onChanged: (value) {
                setState(() {
                  _priceAlerts = value;
                });
              },
              icon: Icons.price_change,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: 'Trend Alarmları',
              subtitle: 'Önemli fiyat hareketlerinde bildirim alın',
              value: _trendingAlerts,
              onChanged: (value) {
                setState(() {
                  _trendingAlerts = value;
                });
              },
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: 'Haber Bildirimleri',
              subtitle: 'Önemli kripto haberleri hakkında bilgilendirilir',
              value: _newsAlerts,
              onChanged: (value) {
                setState(() {
                  _newsAlerts = value;
                });
              },
              icon: Icons.newspaper,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: 'Portföy Güncellemeleri',
              subtitle:
                  'Portföyünüzdeki önemli değişiklikler hakkında bilgi alın',
              value: _portfolioUpdates,
              onChanged: (value) {
                setState(() {
                  _portfolioUpdates = value;
                });
              },
              icon: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: 'Piyasa Güncellemeleri',
              subtitle: 'Genel piyasa durumu hakkında günlük özetler alın',
              value: _marketUpdates,
              onChanged: (value) {
                setState(() {
                  _marketUpdates = value;
                });
              },
              icon: Icons.analytics,
            ),
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
                Icons.notifications_active,
                color: colorss.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Bildirim Ayarları',
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
            'Hangi durumlarda bildirim almak istediğinizi özelleştirin. Önemli fırsatları kaçırmayın.',
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

  Widget _buildNotificationSection({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorss.backgroundColorLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorss.textColorSecondary.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SwitchListTile(
          value: value,
          onChanged: onChanged,
          title: Row(
            children: [
              Icon(
                icon,
                color: colorss.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
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
              subtitle,
              style: TextStyle(
                color: colorss.textColorSecondary,
                fontSize: 14,
              ),
            ),
          ),
          activeColor: colorss.primaryColor,
          inactiveThumbColor: colorss.textColorSecondary,
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
