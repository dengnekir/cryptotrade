import 'package:flutter/material.dart';

class SupportView extends StatelessWidget {
  const SupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destek'),
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
              'Size Nasıl Yardımcı Olabiliriz?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildSupportCard(
              context,
              'Sık Sorulan Sorular',
              'En çok sorulan sorular ve cevapları',
              Icons.question_answer,
              () {
                // TODO: Navigate to FAQ page
              },
            ),
            _buildSupportCard(
              context,
              'Canlı Destek',
              '7/24 müşteri temsilcilerimizle görüşün',
              Icons.support_agent,
              () {
                // TODO: Navigate to live support
              },
            ),
            _buildSupportCard(
              context,
              'E-posta ile İletişim',
              'support@cryptotrade.com',
              Icons.email,
              () {
                // TODO: Open email client
              },
            ),
            _buildSupportCard(
              context,
              'Bilgi Merkezi',
              'Detaylı rehberler ve öğreticiler',
              Icons.library_books,
              () {
                // TODO: Navigate to knowledge base
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white10,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
        ),
        onTap: onTap,
      ),
    );
  }
}
