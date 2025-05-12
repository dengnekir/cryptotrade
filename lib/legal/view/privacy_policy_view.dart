import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gizlilik Politikası'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Gizlilik Politikası',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'CryptoTrade uygulaması olarak kişisel verilerinizin güvenliği bizim için önemlidir. '
              'Bu gizlilik politikası, hangi bilgileri topladığımızı ve bu bilgileri nasıl kullandığımızı açıklar.\n\n'
              '1. Toplanan Bilgiler\n'
              '- Kullanıcı profil bilgileri\n'
              '- İşlem geçmişi\n'
              '- Cihaz bilgileri\n\n'
              '2. Bilgilerin Kullanımı\n'
              '- Hizmet kalitesini artırmak\n'
              '- Güvenliği sağlamak\n'
              '- Yasal yükümlülükleri yerine getirmek\n\n'
              '3. Bilgi Güvenliği\n'
              'Verileriniz endüstri standardı güvenlik önlemleriyle korunmaktadır.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
