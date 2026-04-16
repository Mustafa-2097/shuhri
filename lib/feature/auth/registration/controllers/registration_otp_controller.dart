import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_endpoints.dart';
import '../../login/views/login_page.dart';

class RegistrationOtpController extends GetxController {
  static RegistrationOtpController get instance => Get.find();

  var otp = "".obs;
  String email = "";

  void setOtp(String val) => otp.value = val;

  Future<void> verifyEmail() async {
    if (otp.value.length < 6) {
      EasyLoading.showError("Enter complete 6-digit OTP");
      return;
    }

    try {
      EasyLoading.show(status: 'Verifying Email...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "otp": otp.value,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Email Verified');
        // Handle success (e.g. navigate to login)
        Get.offAll(() => LoginPage());
      } else {
        EasyLoading.showError(data['message'] ?? 'Verification failed');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  Future<void> resendOtp() async {
    try {
      EasyLoading.show(status: 'Resending OTP...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.resendOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "purpose": "EMAIL_VERIFICATION",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('OTP resent successfully');
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }
}
