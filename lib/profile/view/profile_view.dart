import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../register/view/login_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'legal/view/profile_edit_view.dart';
import 'legal/view/account_delete_view.dart';
import '../../register/view/forgot_password_view.dart';
import '../../core/navigation/app_routes.dart';
import 'legal/view/subscription_plan_view.dart';
import '../../core/widgets/colors.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: colorss.backgroundColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.userModel == null
              ? const Center(
                  child: Text('Kullanıcı bilgileri yüklenemedi',
                      style: TextStyle(color: Colors.black)))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profil Başlık Bölümü
                      Container(
                        padding: EdgeInsets.all(screenSize.width * 0.05),
                        decoration: BoxDecoration(
                          color: colorss.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profil Fotoğrafı
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorss.primaryColor,
                                  width: 2,
                                ),
                                color: colorss.primaryColor.withOpacity(0.2),
                              ),
                              child: Icon(
                                Icons.person,
                                color: colorss.primaryColor,
                                size: 50,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${viewModel.userModel!.name} ${viewModel.userModel!.surname}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: colorss.backgroundColorDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    viewModel.userModel!.email,
                                    style: TextStyle(
                                      color: colorss.backgroundColorDark
                                          .withOpacity(0.7),
                                      fontSize: 14,
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
                        ],
                      ),

                      _buildMenuSection(
                        'Destek ve Geri Bildirim',
                        [
                          _buildMenuItem(
                            icon: Icons.support_agent,
                            title: 'Destek',
                            onTap: () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'usluferhat98@gmail.com',
                                query: encodeQueryParameters(<String, String>{
                                  'subject': 'CryptoTrade Destek Talebi',
                                  'body':
                                      'Merhaba,\n\nUygulamayla ilgili destek talebim var:'
                                }),
                              );
                              if (await canLaunchUrl(emailLaunchUri)) {
                                await launchUrl(emailLaunchUri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('E-posta uygulaması açılamadı.'),
                                  ),
                                );
                              }
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help,
                            title: 'SSS',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.faq);
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

                      // Çıkış Yapma Butonu
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Çıkış onayı dialog'u
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    'Çıkış Yap',
                                    style: TextStyle(
                                        color: colorss.backgroundColorDark),
                                  ),
                                  content: const Text(
                                    'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
                                    style: TextStyle(
                                        color: colorss.backgroundColorDark),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('İptal',
                                          style: TextStyle(
                                              color:
                                                  colorss.backgroundColorDark)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        'Çıkış Yap',
                                        style: TextStyle(
                                            color: colorss.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (result == true && mounted) {
                                await viewModel.signOut();
                                if (mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) => const LoginView()),
                                    (route) => false,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorss.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Çıkış Yap',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorss.backgroundColorDark.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorss.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                color: colorss.backgroundColorDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : colorss.backgroundColorDark,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : colorss.backgroundColorDark,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorss.backgroundColorDark.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
