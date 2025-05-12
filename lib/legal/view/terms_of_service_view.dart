import 'package:flutter/material.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanım Koşulları'),
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
              'Kullanım Koşulları',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Hizmet Kullanımı\n'
              '- CryptoTrade uygulamasını kullanarak bu koşulları kabul etmiş olursunuz\n'
              '- Uygulama içerisindeki tüm işlemlerinizden siz sorumlusunuz\n\n'
              '2. Hesap Güvenliği\n'
              '- Hesap bilgilerinizi güvende tutmak sizin sorumluluğunuzdadır\n'
              '- Şüpheli bir durum fark ettiğinizde hemen bizimle iletişime geçin\n\n'
              '3. İşlem Kuralları\n'
              '- Tüm işlemler kayıt altına alınır\n'
              '- Manipülatif işlemler yasaktır\n\n'
              '4. Değişiklikler\n'
              'Bu koşullar önceden haber verilmeksizin değiştirilebilir.',
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
