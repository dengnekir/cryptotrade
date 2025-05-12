import 'package:flutter/material.dart';

class KnowledgeBaseView extends StatelessWidget {
  const KnowledgeBaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilgi Merkezi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Öğrenmeye Başlayın',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildCategorySection(
              context,
              'Başlangıç Rehberi',
              [
                'CryptoTrade\'e Hoş Geldiniz',
                'Hesap Oluşturma',
                'Güvenlik Ayarları',
                'İlk İşleminiz',
              ],
            ),
            _buildCategorySection(
              context,
              'Kripto Para İşlemleri',
              [
                'Alım-Satım Nasıl Yapılır?',
                'İşlem Tipleri',
                'İşlem Stratejileri',
                'Risk Yönetimi',
              ],
            ),
            _buildCategorySection(
              context,
              'Güvenlik',
              [
                '2FA Kurulumu',
                'Güvenli İşlem İpuçları',
                'Şifre Güvenliği',
                'Dolandırıcılıktan Korunma',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildArticleCard(context, item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildArticleCard(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white10,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 18,
        ),
        onTap: () {
          // TODO: Navigate to article detail
        },
      ),
    );
  }
}
