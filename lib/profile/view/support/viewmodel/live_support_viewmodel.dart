import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:device_apps/device_apps.dart';

class LiveSupportViewModel extends ChangeNotifier {
  Future<void> openWhatsApp() async {
    const phoneNumber = '905305807247';
    const message = 'Merhaba, yardıma ihtiyacım var.';

    try {
      if (Platform.isAndroid) {
        // Önce WhatsApp'ın yüklü olup olmadığını kontrol et
        final isWhatsAppInstalled =
            await DeviceApps.isAppInstalled('com.whatsapp');

        if (isWhatsAppInstalled) {
          final intent = AndroidIntent(
            action: 'android.intent.action.VIEW',
            data: Uri.encodeFull(
                'https://api.whatsapp.com/send?phone=$phoneNumber&text=$message'),
            package: 'com.whatsapp',
          );
          await intent.launch();
          return;
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
