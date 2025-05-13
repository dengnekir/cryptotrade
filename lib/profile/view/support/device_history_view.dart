import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/profile_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/widgets/colors.dart';

class DeviceHistoryView extends StatefulWidget {
  const DeviceHistoryView({Key? key}) : super(key: key);

  @override
  State<DeviceHistoryView> createState() => _DeviceHistoryViewState();
}

class _DeviceHistoryViewState extends State<DeviceHistoryView> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setDefaultLocale('tr');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadDeviceHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        backgroundColor: colorss.backgroundColor,
        elevation: 0,
        title: Text(
          'Cihaz Geçmişi',
          style: TextStyle(color: colorss.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorss.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: viewModel.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorss.primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => viewModel.loadDeviceHistory(),
              color: colorss.primaryColor,
              backgroundColor: colorss.backgroundColorLight,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Aktif Oturumlar', Icons.devices),
                      const SizedBox(height: 16),
                      if (viewModel.activeSessions.isEmpty)
                        _buildEmptyState('Aktif oturum bulunamadı')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.activeSessions.length,
                          itemBuilder: (context, index) {
                            final session = viewModel.activeSessions[index];
                            return _buildSessionCard(
                              session: session,
                              isActive: true,
                              onLogout: () => _showLogoutDialog(session.id),
                            );
                          },
                        ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Oturum Geçmişi', Icons.history),
                      const SizedBox(height: 16),
                      if (viewModel.sessionHistory.isEmpty)
                        _buildEmptyState('Oturum geçmişi bulunamadı')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.sessionHistory.length,
                          itemBuilder: (context, index) {
                            final session = viewModel.sessionHistory[index];
                            return _buildSessionCard(
                              session: session,
                              isActive: false,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorss.primaryColor.withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorss.backgroundColorLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.devices_other,
              size: 48,
              color: colorss.textColorSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: colorss.textColorSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required dynamic session,
    required bool isActive,
    VoidCallback? onLogout,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          color: isActive
              ? colorss.primaryColor.withOpacity(0.2)
              : colorss.textColorSecondary.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: ExpansionTile(
            leading: Icon(
              _getDeviceIcon(session.deviceType),
              color:
                  isActive ? colorss.primaryColor : colorss.textColorSecondary,
              size: 28,
            ),
            title: Text(
              session.deviceName,
              style: TextStyle(
                color: colorss.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Son erişim: ${timeago.format(session.lastAccess)}',
              style: TextStyle(
                color: colorss.textColorSecondary,
                fontSize: 13,
              ),
            ),
            trailing: isActive && onLogout != null
                ? TextButton.icon(
                    onPressed: onLogout,
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Oturumu Kapat'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  )
                : null,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      'Giriş Zamanı',
                      timeago.format(session.loginTime),
                    ),
                    if (!isActive && session.logoutTime != null)
                      _buildInfoRow(
                        'Çıkış Zamanı',
                        timeago.format(session.logoutTime!),
                      ),
                    _buildInfoRow(
                      'Cihaz Türü',
                      _getDeviceTypeName(session.deviceType),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colorss.textColorSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colorss.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDeviceTypeName(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile':
        return 'Mobil Cihaz';
      case 'tablet':
        return 'Tablet';
      case 'desktop':
        return 'Masaüstü';
      default:
        return 'Diğer';
    }
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile':
        return Icons.phone_android;
      case 'tablet':
        return Icons.tablet_android;
      case 'desktop':
        return Icons.computer;
      default:
        return Icons.devices_other;
    }
  }

  Future<void> _showLogoutDialog(String sessionId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorss.backgroundColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Oturumu Kapat',
          style: TextStyle(color: colorss.textColor),
        ),
        content: Text(
          'Bu cihazdan oturumu kapatmak istediğinize emin misiniz?',
          style: TextStyle(color: colorss.textColorSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'İptal',
              style: TextStyle(color: colorss.textColorSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Oturumu Kapat',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      final viewModel = context.read<ProfileViewModel>();
      try {
        await viewModel.terminateSession(sessionId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Oturum başarıyla kapatıldı'),
              backgroundColor: colorss.primaryColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
