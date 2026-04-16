import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_endpoints.dart';
import '../views/pages/reset_password_page.dart';
import 'reset_password_controller.dart';

class ResetOtpController extends GetxController {
  static ResetOtpController get instance => Get.find();

  String email = "";

  /// OTP value
  var otp = "".obs;

  /// Timer countdown 50 seconds
  var secondsRemaining = 20.obs;
  Timer? _timer;

  /// Whether user can resend OTP
  var canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  /// Start 20-second countdown
  void startTimer() {
    secondsRemaining.value = 20;
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Validate OTP
  String? validateOtp() {
    if (otp.value.length < 6) return "Enter the 6-digit code";
    return null;
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    final error = validateOtp();

    if (error != null) {
      EasyLoading.showError(error);
      return;
    }

    try {
      EasyLoading.show(status: 'Verifying OTP...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.verifyOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email, // Make sure email is set by UI
          "otp": otp.value,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('OTP Verified');
        // Handle next steps, e.g., move to reset password passing reset token
        final token = data['data'] != null ? data['data']['resetToken'] : data['resetToken'];
        if (token != null) {
          Get.put(ResetPasswordController()).resetToken = token;
        }
        Get.to(() => ResetPasswordPage());
      } else {
        EasyLoading.showError(data['message'] ?? 'Verification failed');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      EasyLoading.show(status: "Sending new code...");
      final response = await http.post(
        Uri.parse(ApiEndpoints.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('New code sent');
        startTimer();
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
