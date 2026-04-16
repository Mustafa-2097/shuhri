import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../customer_dashboard/dashboard/dashboard.dart';

class LoginPageController extends GetxController {
  static LoginPageController get instance => Get.find();

  /// Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Observables
  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRememberedCredentials();
  }

  /// Load saved credentials if Remember Me was checked
  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool('rememberMe') ?? false;
    if (remembered) {
      rememberMe.value = true;
      emailController.text = prefs.getString('rememberedEmail') ?? '';
      passwordController.text = prefs.getString('rememberedPassword') ?? '';
    }
  }

  /// Validation
  String? validateEmail() {
    if (emailController.text.trim().isEmpty) return "Email is required";
    if (!GetUtils.isEmail(emailController.text.trim())) return "Enter a valid email";
    return null;
  }

  String? validatePassword() {
    if (passwordController.text.trim().isEmpty) return "Password is required";
    return null;
  }

  /// MAIN LOGIN FUNCTION
  Future<void> login() async {
    final emailError = validateEmail();
    final passError = validatePassword();

    if (emailError != null || passError != null) {
      EasyLoading.showError(emailError ?? passError!);
      return;
    }

    try {
      EasyLoading.show(status: 'Logging in...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Login Successful');

        final prefs = await SharedPreferences.getInstance();
        final accessToken = data['data'] != null
            ? data['data']['accessToken']
            : data['accessToken'];
        final refreshToken = data['data'] != null
            ? data['data']['refreshToken']
            : data['refreshToken'];

        if (accessToken != null) {
          await prefs.setString('accessToken', accessToken);
        }
        if (refreshToken != null) {
          await prefs.setString('refreshToken', refreshToken);
        }

        // Save or clear Remember Me credentials
        await prefs.setBool('rememberMe', rememberMe.value);
        if (rememberMe.value) {
          await prefs.setString('rememberedEmail', emailController.text.trim());
          await prefs.setString('rememberedPassword', passwordController.text);
        } else {
          await prefs.remove('rememberedEmail');
          await prefs.remove('rememberedPassword');
        }

        Get.offAll(() => CustomerDashboard());
      } else {
        EasyLoading.showError(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
