import 'package:flutter/material.dart';

class FAQView extends StatelessWidget {
  const FAQView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sık Sorulan Sorular'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text(
              'CryptoTrade nasıl kullanılır?',
              style: TextStyle(color: Colors.white),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'CryptoTrade\'i kullanmaya başlamak için önce bir hesap oluşturmanız gerekir. '
                  'Ardından kimlik doğrulama işlemlerini tamamlayarak alım-satım işlemlerine başlayabilirsiniz.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'İşlem ücretleri nelerdir?',
              style: TextStyle(color: Colors.white),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'İşlem ücretleri, işlem tipine ve hacmine göre değişiklik gösterir. '
                  'Güncel ücret bilgilerini uygulama içindeki ücret tablosundan görebilirsiniz.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Hesabımı nasıl doğrularım?',
              style: TextStyle(color: Colors.white),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Hesap doğrulama için kimlik belgesi ve adres belgesi yüklemeniz gerekmektedir. '
                  'Profil bölümünden doğrulama işlemlerini başlatabilirsiniz.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Para yatırma ve çekme işlemleri nasıl yapılır?',
              style: TextStyle(color: Colors.white),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Para yatırma ve çekme işlemlerini Cüzdan bölümünden gerçekleştirebilirsiniz. '
                  'Desteklenen ödeme yöntemlerini kullanarak işlemlerinizi yapabilirsiniz.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
