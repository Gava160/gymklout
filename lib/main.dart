import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gymklout/app-settings/app_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode');
  final biometricLogin = prefs.getBool('biometricLogin') ?? false;
  final biometricAuth = prefs.getBool('biometricAuth') ?? false;

  final themeMode = switch (savedTheme) {
    'dark' => ThemeMode.dark,
    'light' => ThemeMode.light,
    _ => ThemeMode.system,
  };

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => themeMode),
        biometricAuthProvider.overrideWith((ref) => biometricAuth),
        biometricLoginProvider.overrideWith((ref) => biometricLogin),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode ?? ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        scaffoldBackgroundColor: AppDefaults.bgColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        scaffoldBackgroundColor: AppDefaults.darkBgColor,
      ),
      home: const SplashScreen(),
    );
  }
}
