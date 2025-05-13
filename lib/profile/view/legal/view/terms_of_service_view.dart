import 'package:flutter/material.dart';
import '../../../../core/widgets/colors.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        title: const Text('Kullanım Koşulları',
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
                        Icons.gavel_outlined,
                        color: colorss.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Kullanım Koşulları',
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
                    'Genel Hükümler',
                    'CryptoTrade uygulamasını kullanarak bu koşulları kabul etmiş olursunuz. '
                        'Uygulama içerisindeki tüm işlemlerinizden siz sorumlusunuz.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Hesap Güvenliği',
                    '• Hesap bilgilerinizi güvende tutmak sizin sorumluluğunuzdadır\n'
                        '• Şüpheli bir durum fark ettiğinizde hemen bizimle iletişime geçin\n'
                        '• Hesap bilgilerinizi kimseyle paylaşmayın\n'
                        '• Güçlü şifreler kullanın ve düzenli olarak değiştirin',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Abonelik ve Hizmetler',
                    '• CryptoTrade, yapay zeka destekli kripto analiz hizmeti sunar\n'
                        '• Abonelik ücretleri ve koşulları ayrıca belirtilir\n'
                        '• Abonelikler otomatik yenilenir ve istediğiniz zaman iptal edilebilir\n'
                        '• Ödeme işlemleri güvenli ödeme sistemleri üzerinden yapılır',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Kullanım Kuralları',
                    '• Manipülatif işlemler kesinlikle yasaktır\n'
                        '• Tüm işlemler kayıt altına alınır\n'
                        '• Hatalı veya kötüye kullanım durumunda hesabınız askıya alınabilir\n'
                        '• Diğer kullanıcıların haklarına saygı gösterilmelidir',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Yasal Uyarı',
                    'CryptoTrade, yatırım tavsiyesi vermez. Tüm analizler bilgilendirme amaçlıdır. '
                        'Yatırım kararlarınızdan ve sonuçlarından kendiniz sorumlusunuz.',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Değişiklikler',
                    'Bu koşullar önceden haber verilmeksizin değiştirilebilir. '
                        'Değişiklikler uygulamada ve web sitesinde duyurulacaktır.',
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
