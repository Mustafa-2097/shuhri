import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_endpoints.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shuhri/feature/auth/login/views/login_page.dart';

class AuthService {
  /// Refresh Token
  static Future<void> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentRefreshToken = prefs.getString('refreshToken');

      if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
        return; // No refresh token available
      }

      final response = await http.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refreshToken": currentRefreshToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          await prefs.setString('accessToken', newAccessToken);
        }
        if (newRefreshToken != null) {
          await prefs.setString('refreshToken', newRefreshToken);
        }
      } else {
        // Handle failed text refresh (e.g. require re-login)
      }
    } catch (e) {
      // Error in refresh token
    }
  }

  /// Logout
  static Future<void> logout() async {
    try {
      EasyLoading.show(status: 'Logging out...');
      final prefs = await SharedPreferences.getInstance();
      final currentRefreshToken = prefs.getString('refreshToken');

      if (currentRefreshToken != null && currentRefreshToken.isNotEmpty) {
        await http.post(
          Uri.parse(ApiEndpoints.logout),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"refreshToken": currentRefreshToken}),
        );
      }

      // Clear local storage
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');

      EasyLoading.showSuccess('Logged out');
      Get.offAll(() => LoginPage()); // Navigate back to Login
    } catch (e) {
      EasyLoading.showError('Logout failed');
    }
  }
}
