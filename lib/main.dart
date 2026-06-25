import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gymklout/app-settings/app_preferences.dart';
import 'package:gymklout/app-settings/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode');
  final hideBalance = prefs.getBool('hideBalance') ?? false;
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
        hideBalanceProvider.overrideWith((ref) => hideBalance),
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
  late AppLifecycleListener _listener;
  bool _isInactive = false;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onInactive: () {
        final biometricActive = ref.read(biometricActiveProvider);
        if (biometricActive) return;
        setState(() => _isInactive = true);
      },
      onResume: () => setState(() => _isInactive = false),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
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
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        scaffoldBackgroundColor: AppDefaults.bgColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        scaffoldBackgroundColor: AppDefaults.darkBgColor,
      ),
      home: const SplashScreen(),
      builder: (context, child) => Stack(
        children: [
          child!,
          if (_isInactive)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: AppDefaults.black.withAlpha(20),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      size: 40,
                      color: AppDefaults.white.withAlpha(190),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
