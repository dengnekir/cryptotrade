import 'package:flutter/material.dart';
import '../../../../core/widgets/colors.dart';

class FAQView extends StatelessWidget {
  const FAQView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorss.backgroundColor,
      appBar: AppBar(
        title: const Text('Sık Sorulan Sorular',
            style: TextStyle(color: colorss.textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorss.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
                      Icons.help_outline,
                      color: colorss.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sık Sorulan Sorular',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorss.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildFAQItem(
                  'CryptoTrade nasıl çalışır?',
                  'CryptoTrade, yapay zeka teknolojisini kullanarak kripto para piyasalarını analiz eder ve size kişiselleştirilmiş al/sat önerileri sunar. Abonelik planınıza göre günlük veya anlık sinyaller alabilirsiniz.',
                  context,
                ),
                _buildFAQItem(
                  'Hangi abonelik planları mevcut?',
                  '• Başlangıç Planı: Günlük 3 analiz sinyali\n'
                      '• Pro Plan: Sınırsız analiz sinyali ve öncelikli destek\n'
                      '• Premium Plan: Özel stratejiler ve VIP destek\n\n'
                      'Tüm planlar aylık veya yıllık olarak seçilebilir.',
                  context,
                ),
                _buildFAQItem(
                  'Yapay zeka analizleri ne kadar güvenilir?',
                  'Yapay zeka sistemimiz, geçmiş veriler, teknik analizler ve piyasa göstergelerini kullanarak tahminler yapar. Ancak kripto piyasaları yüksek risk içerir ve hiçbir tahmin %100 garanti değildir.',
                  context,
                ),
                _buildFAQItem(
                  'Aboneliğimi nasıl iptal edebilirim?',
                  'Aboneliğinizi istediğiniz zaman profil ayarlarından veya müşteri hizmetlerimizle iletişime geçerek iptal edebilirsiniz. İptal işlemi anında gerçekleşir ve bir sonraki dönem için ücret alınmaz.',
                  context,
                ),
                _buildFAQItem(
                  'Para yatırma ve çekme işlemleri nasıl yapılır?',
                  'CryptoTrade sadece analiz hizmeti sunar. Uygulama içinde para yatırma veya çekme işlemi yapılmaz. Alım-satım işlemlerinizi kendi tercih ettiğiniz kripto borsalarında gerçekleştirebilirsiniz.',
                  context,
                ),
                _buildFAQItem(
                  'Destek hizmetlerine nasıl ulaşabilirim?',
                  'Canlı destek hattımıza 7/24 WhatsApp üzerinden ulaşabilirsiniz. Ayrıca e-posta ile de destek talebinde bulunabilirsiniz. Premium üyelerimiz için öncelikli destek hizmeti sunulmaktadır.',
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            color: colorss.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: colorss.primaryColor,
        collapsedIconColor: colorss.primaryColor.withOpacity(0.7),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: colorss.textColorSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
