import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../register/view/login_view.dart';
import '../../core/widgets/colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _ProfileViewContent(),
    );
  }
}

class _ProfileViewContent extends StatefulWidget {
  const _ProfileViewContent({Key? key}) : super(key: key);

  @override
  _ProfileViewContentState createState() => _ProfileViewContentState();
}

class _ProfileViewContentState extends State<_ProfileViewContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await viewModel.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.userModel == null
              ? const Center(child: Text('Kullanıcı bilgileri yüklenemedi'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profil Başlık Bölümü
                      Container(
                        padding: EdgeInsets.all(screenSize.width * 0.05),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: screenSize.width * 0.1,
                              backgroundColor: Colors.grey[800],
                              backgroundImage:
                                  viewModel.userModel!.profileImage != null
                                      ? NetworkImage(
                                          viewModel.userModel!.profileImage!)
                                      : null,
                              child: viewModel.userModel!.profileImage == null
                                  ? Icon(Icons.person,
                                      size: screenSize.width * 0.1,
                                      color: Colors.white)
                                  : null,
                            ),
                            SizedBox(width: screenSize.width * 0.05),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${viewModel.userModel!.name} ${viewModel.userModel!.surname}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    viewModel.userModel!.email,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Menü Öğeleri
                      _buildMenuSection(
                        'Hesap ve Güvenlik',
                        [
                          _buildMenuItem(
                            icon: Icons.email,
                            title: 'E-posta / Telefon değiştirme',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.security,
                            title: 'İki faktörlü kimlik doğrulama (2FA)',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.lock,
                            title: 'Şifre güncelleme',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.devices,
                            title: 'Cihaz geçmişi ve aktif oturumlar',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.delete_forever,
                            title: 'Hesap silme / devre dışı bırakma',
                            onTap: () {},
                            isDestructive: true,
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Abonelik ve Planlar',
                        [
                          _buildMenuItem(
                            icon: Icons.card_membership,
                            title: 'Mevcut abonelik planı',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.history,
                            title: 'Fatura geçmişi',
                            onTap: () {},
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Kripto Tercihleri',
                        [
                          _buildMenuItem(
                            icon: Icons.star,
                            title: 'Favori Coinler',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications,
                            title: 'Alarm & Bildirim Ayarları',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.analytics,
                            title: 'Analiz Tercihleri',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.warning,
                            title: 'Risk Seviyesi Seçimi',
                            onTap: () {},
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Destek ve Geri Bildirim',
                        [
                          _buildMenuItem(
                            icon: Icons.support_agent,
                            title: 'Canlı destek',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.help,
                            title: 'SSS',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.feedback,
                            title: 'Geri bildirim gönder',
                            onTap: () {},
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Hukuki Bilgiler',
                        [
                          _buildMenuItem(
                            icon: Icons.description,
                            title: 'Kullanım şartları',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.privacy_tip,
                            title: 'Gizlilik politikası',
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.warning_amber,
                            title: 'Risk bildirimi',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDestructive ? Colors.red : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDestructive ? Colors.red : Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
