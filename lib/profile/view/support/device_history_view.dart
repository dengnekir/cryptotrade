import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/profile_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Cihaz Geçmişi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : RefreshIndicator(
              onRefresh: () => viewModel.loadDeviceHistory(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aktif Oturumlar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (viewModel.activeSessions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Aktif oturum bulunamadı',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.activeSessions.length,
                          itemBuilder: (context, index) {
                            final session = viewModel.activeSessions[index];
                            return Card(
                              color: Colors.grey[900],
                              child: ListTile(
                                leading: Icon(
                                  _getDeviceIcon(session.deviceType),
                                  color: Colors.amber,
                                ),
                                title: Text(
                                  session.deviceName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Son erişim: ${timeago.format(session.lastAccess)}',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                trailing: TextButton(
                                  onPressed: () =>
                                      _showLogoutDialog(session.id),
                                  child: const Text(
                                    'Oturumu Kapat',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 32),
                      const Text(
                        'Oturum Geçmişi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (viewModel.sessionHistory.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Oturum geçmişi bulunamadı',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.sessionHistory.length,
                          itemBuilder: (context, index) {
                            final session = viewModel.sessionHistory[index];
                            return Card(
                              color: Colors.grey[900],
                              child: ListTile(
                                leading: Icon(
                                  _getDeviceIcon(session.deviceType),
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  session.deviceName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Giriş: ${timeago.format(session.loginTime)}',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    Text(
                                      'Çıkış: ${session.logoutTime != null ? timeago.format(session.logoutTime!) : 'Bilinmiyor'}',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                              ),
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
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Oturumu Kapat',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Bu cihazdan oturumu kapatmak istediğinize emin misiniz?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
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
            const SnackBar(
              content: Text('Oturum başarıyla kapatıldı'),
              backgroundColor: Colors.green,
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
