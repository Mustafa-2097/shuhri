import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_endpoints.dart';
import '../views/pages/registration_otp_page.dart';
import 'registration_otp_controller.dart';

class RegistrationPageController extends GetxController {
  static RegistrationPageController get instance => Get.find();

  /// Text Controllers
  final nameController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Observables
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var agreedToTerms = false.obs;

  /// Validation
  String? validateName() {
    if (nameController.text.trim().isEmpty) return "Name is required";
    return null;
  }

  String? validateEmail() {
    if (emailController.text.trim().isEmpty) return "Email/Phone is required";
    // Optional: Add email/phone regex validation
    final regex = RegExp(r'^((\+?\d{10,15})|([\w\.-]+@[\w\.-]+\.\w{2,}))$');
    if (!regex.hasMatch(emailController.text.trim())) return "Enter a valid email or phone number";
    return null;
  }

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

  /// Registration
  Future<void> register() async {
    final nameError = validateName();
    final emailError = validateEmail();
    final passwordError = validatePassword();
    final confirmPasswordError = validateConfirmPassword();

    final errorMessage =
       nameError ?? emailError ?? passwordError ?? confirmPasswordError;

    if (errorMessage != null) {
      EasyLoading.showError(errorMessage);
      return;
    }

    if (!agreedToTerms.value) {
      EasyLoading.showError("You must agree to the terms and conditions");
      return;
    }

    try {
      EasyLoading.show(status: 'Registering...');
      final response = await http.post(
        Uri.parse(ApiEndpoints.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text,
          "isAcceptedTerms": agreedToTerms.value,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Registration Successful');
        // Handle successful registration
        final otpController = Get.find<RegistrationOtpController>();
        otpController.email = emailController.text.trim();
        Get.to(() => const RegistrationOtpPage());
      } else {
        EasyLoading.showError(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
