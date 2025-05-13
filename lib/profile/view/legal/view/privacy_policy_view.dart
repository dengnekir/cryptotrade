import 'package:flutter/material.dart';
import '../../../../core/widgets/colors.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        title: const Text('Gizlilik Politikası',
            style: TextStyle(color: colorss.textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorss.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        Icons.privacy_tip_outlined,
                        color: colorss.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Gizlilik Politikası',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorss.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Veri Güvenliği ve Gizlilik',
                    'CryptoTrade olarak kişisel verilerinizin güvenliği bizim için en önemli önceliktir. '
                        'Verileriniz, endüstri standardı şifreleme ve güvenlik önlemleriyle korunmaktadır.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Toplanan Veriler',
                    '• Kimlik bilgileri (ad, soyad, e-posta)\n'
                        '• İşlem geçmişi ve tercihleri\n'
                        '• Cihaz ve kullanım bilgileri\n'
                        '• Konum bilgileri (isteğe bağlı)',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Veri Kullanımı',
                    '• Hizmet kalitesini iyileştirme\n'
                        '• Kişiselleştirilmiş deneyim sunma\n'
                        '• Güvenlik ve doğrulama işlemleri\n'
                        '• Yasal yükümlülüklerin yerine getirilmesi',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Veri Paylaşımı',
                    'Kişisel verileriniz, yasal zorunluluklar dışında üçüncü taraflarla paylaşılmaz. '
                        'Verileriniz yalnızca size daha iyi hizmet sunmak amacıyla kullanılır.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Haklarınız',
                    '• Verilerinize erişim\n'
                        '• Düzeltme talep etme\n'
                        '• Silme talep etme\n'
                        '• Veri işlemeye itiraz etme',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Son Güncelleme: Mart 2024',
                style: TextStyle(
                  color: colorss.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorss.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: colorss.textColorSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
