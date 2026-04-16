import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_endpoints.dart';
import '../../login/views/login_page.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  /// Password Controllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Observables
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  String resetToken = "";

  String? validatePassword() {
    if (passwordController.text.trim().isEmpty) return "Password is required";
    final regex = RegExp(r'^(?=.*[!@#\$&*~]).{6,}$');
    if (!regex.hasMatch(passwordController.text.trim())) {
      return "Password must be at least 6 characters and contain 1 special character";
    }
    return null;
  }

  String? validateConfirmPassword() {
    if (confirmPasswordController.text.trim().isEmpty) return "Confirm your password";
    if (confirmPasswordController.text.trim() != passwordController.text.trim()) return "Passwords do not match";
    return null;
  }

  Future<void> resetPassword() async {
    final passwordError = validatePassword();
    final confirmPasswordError = validateConfirmPassword();

    if (passwordError != null || confirmPasswordError != null) {
      EasyLoading.showError(passwordError ?? confirmPasswordError!);
      return;
    }

    try {
      EasyLoading.show(status: 'Resetting Password...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "resetToken": resetToken,
          "newPassword": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Password Reset Successfully');
        // Handle next steps, e.g., navigate to login
        Get.offAll(() => LoginPage());
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
