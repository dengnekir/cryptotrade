import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class LiveSupportViewModel extends ChangeNotifier {
  Future<void> openWhatsApp() async {
    const phoneNumber = '905305807247';
    const message = 'Merhaba, yardıma ihtiyacım var.';

    try {
      if (Platform.isAndroid) {
        // WhatsApp URL'ini hazırla
        final whatsappUrl = Uri.parse(
            'https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');

        // URL'i açmaya çalış
        if (await canLaunchUrl(whatsappUrl)) {
          // Android'de intent kullanarak açmayı dene
          final intent = AndroidIntent(
            action: 'android.intent.action.VIEW',
            data: Uri.encodeFull(
                'https://api.whatsapp.com/send?phone=$phoneNumber&text=$message'),
            package: 'com.whatsapp',
          );

          try {
            await intent.launch();
            return;
          } catch (e) {
            // Intent açılamazsa, tarayıcı ile açmayı dene
            await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
          }
        } else {
          debugPrint('WhatsApp yüklü değil, Play Store\'a yönlendiriliyor...');
          final playStoreUrl = Uri.parse(
              'https://play.google.com/store/apps/details?id=com.whatsapp');
          await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
        }
      } else if (Platform.isIOS) {
        final whatsappUrl = Uri.parse(
            "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
        if (await canLaunchUrl(whatsappUrl)) {
          await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        } else {
          final appStoreUrl = Uri.parse(
              'https://apps.apple.com/app/whatsapp-messenger/id310633997');
          await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
        }
      } else {
        final webUrl = Uri.parse(
            "https://web.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('WhatsApp açılırken hata oluştu: $e');
    }
  }
}
