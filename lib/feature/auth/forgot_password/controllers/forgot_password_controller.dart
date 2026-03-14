import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Text Controller
  final emailController = TextEditingController();

  /// Validation
  String? validateEmail() {
    if (emailController.text.trim().isEmpty) return "Email is required";
    if (!GetUtils.isEmail(emailController.text.trim())) return "Enter a valid email";
    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
