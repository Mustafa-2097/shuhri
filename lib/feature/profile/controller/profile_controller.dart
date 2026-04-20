import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  var isLoading = true.obs;
  var name = "".obs;
  var email = "".obs;
  var profileImage = "".obs; // network URL from /auth/me
  var selectedLanguage = "English".obs;
  
  final List<String> languages = [
    'English',
    'Spanish',
    'Arabic',
    'German',
    'French',
  ];

  final Map<String, String> languageFlags = {
    'English': '🇺🇸',
    'Spanish': '🇪🇸',
    'Arabic': '🇸🇦',
    'German': '🇩🇪',
    'French': '🇫🇷',
  };

  final Map<String, String> languageNativeNames = {
    'English': 'English',
    'Spanish': 'Español',
    'Arabic': 'العربية',
    'German': 'Deutsch',
    'French': 'Français',
  };

  final Map<String, Locale> languageLocales = {
    'English': const Locale('en', 'US'),
    'Spanish': const Locale('es', 'ES'),
    'Arabic': const Locale('ar', 'SA'),
    'German': const Locale('de', 'DE'),
    'French': const Locale('fr', 'FR'),
  };

  void updateLanguage(String langName) async {
    selectedLanguage.value = langName;
    Locale? locale = languageLocales[langName];
    if (locale != null) {
      Get.updateLocale(locale);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', langName);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('selectedLanguage');
    if (lang != null && languages.contains(lang)) {
      selectedLanguage.value = lang;
      Locale? locale = languageLocales[lang];
      if (locale != null) {
        Get.updateLocale(locale);
      }
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiEndpoints.me),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['data'] != null) {
          name.value = data['data']['name'] ?? "";
          email.value = data['data']['email'] ?? "";
          profileImage.value = data['data']['profileImage'] ?? "";
        }
      }
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading(false);
    }
  }
}
