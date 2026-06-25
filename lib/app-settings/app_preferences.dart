import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _darkModeKey = "dark_mode";
  static const _biometricKey = "biometric_enabled";

  // Save Dark Mode
  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  // Get Dark Mode
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // Save Biometric Preference
  static Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
  }

  // Get Biometric Preference
  static Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

}

final hideBalanceProvider = StateProvider<bool>((ref) => false);
final biometricAuthProvider = StateProvider<bool>((ref) => false);
final biometricLoginProvider = StateProvider<bool>((ref) => false);
final biometricActiveProvider = StateProvider<bool>((ref) => false);

// theme provider
final themeProvider = StateProvider<ThemeMode?>((ref) => null);