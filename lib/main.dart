import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MediBotApp(),
    ),
  );
}

enum Language { english, hindi, marathi }

class AppState extends ChangeNotifier {
  Language _language = Language.english;
  Language get language => _language;

  void setLanguage(Language lang) {
    _language = lang;
    notifyListeners();
  }

  String get languageName {
    switch (_language) {
      case Language.english: return 'English';
      case Language.hindi: return 'Hindi';
      case Language.marathi: return 'Marathi';
    }
  }
}

class MediBotApp extends StatelessWidget {
  const MediBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediBot Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // blue-600
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF0D9488), // teal-600
          error: const Color(0xFFEF4444), // red-500
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}
