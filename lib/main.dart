import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'register/view/splash_view.dart';
import 'core/services/preferences_service.dart';
import 'core/providers/theme_provider.dart';
import 'core/navigation/app_routes.dart';

void main() async {
  // Flutter binding'i başlat
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase App Check'i başlat
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  // Preferences Service'i başlat
  final preferencesService = PreferencesService();
  await preferencesService.init();

  // Uygulamayı Riverpod ProviderScope ile sarmalayarak başlat
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema sağlayıcısını izle
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'CryptoTrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeMode,
      home: const SplashView(),
      routes: AppRoutes.routes,
    );
  }
}
