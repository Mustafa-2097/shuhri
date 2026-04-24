import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_endpoints.dart';
import '../views/pages/reset_otp_page.dart';
import 'reset_otp_controller.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Text Controller
  final emailController = TextEditingController();

  /// Validation
  String? validateEmail() {
    if (emailController.text.trim().isEmpty) return "Email is required";
    if (!GetUtils.isEmail(emailController.text.trim()))
      return "Enter a valid email";
    return null;
  }

  Future<void> sendForgotPassword() async {
    final emailError = validateEmail();
    if (emailError != null) {
      EasyLoading.showError(emailError);
      return;
    }

    try {
      EasyLoading.show(status: 'Sending OTP...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": emailController.text.trim()}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('OTP Sent');
        // Handle next steps
        final otpController = Get.find<ResetOtpController>();
        otpController.email = emailController.text.trim();
        Get.to(() => ResetOtpPage());
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
