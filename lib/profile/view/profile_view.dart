import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../register/view/login_view.dart';
import '../../core/widgets/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'support/profile_edit_view.dart';
import 'support/device_history_view.dart';
import 'support/account_delete_view.dart';
import '../../register/view/forgot_password_view.dart';
import '../../core/navigation/app_routes.dart';
import 'subscription/subscription_plan_view.dart';
import 'subscription/billing_history_view.dart';
import 'crypto_preferences/favorite_coins_view.dart';
import 'crypto_preferences/notification_settings_view.dart';
import 'crypto_preferences/analysis_preferences_view.dart';
import 'crypto_preferences/risk_level_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
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
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              // Çıkış onayı dialog'u
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    'Çıkış Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
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
                        'Çıkış Yap',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (result == true && mounted) {
                await viewModel.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginView()),
                    (route) => false,
                  );
                }
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
                            icon: Icons.edit,
                            title: 'Profili Düzenle',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfileEditView(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.lock,
                            title: 'Şifre Sıfırlama',
                            onTap: () async {
                              final viewModel =
                                  context.read<ProfileViewModel>();
                              if (viewModel.userModel?.email != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForgotPasswordView(
                                      initialEmail: viewModel.userModel!.email,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.devices,
                            title: 'Cihaz Geçmişi ve Aktif Oturumlar',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DeviceHistoryView(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.delete_forever,
                            title: 'Hesap Silme',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AccountDeleteView(),
                                ),
                              );
                            },
                            isDestructive: true,
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Abonelik ve Planlar',
                        [
                          _buildMenuItem(
                            icon: Icons.card_membership,
                            title: 'Mevcut Abonelik Planı',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SubscriptionPlanView(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.history,
                            title: 'Fatura Geçmişi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BillingHistoryView(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Kripto Tercihleri',
                        [
                          _buildMenuItem(
                            icon: Icons.star,
                            title: 'Favori Coinler',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FavoriteCoinsView(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications,
                            title: 'Alarm & Bildirim Ayarları',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationSettingsView(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.analytics,
                            title: 'Analiz Tercihleri',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AnalysisPreferencesView(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.warning,
                            title: 'Risk Seviyesi Seçimi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RiskLevelView(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Destek ve Geri Bildirim',
                        [
                          _buildMenuItem(
                            icon: Icons.support_agent,
                            title: 'Canlı Destek',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.liveSupport);
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help,
                            title: 'SSS',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.faq);
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.feedback,
                            title: 'Geri Bildirim Gönder',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.feedback);
                            },
                          ),
                        ],
                      ),

                      _buildMenuSection(
                        'Hukuki Bilgiler',
                        [
                          _buildMenuItem(
                            icon: Icons.description,
                            title: 'Kullanım Şartları',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.termsOfService);
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.privacy_tip,
                            title: 'Gizlilik Politikası',
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.privacyPolicy);
                            },
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
