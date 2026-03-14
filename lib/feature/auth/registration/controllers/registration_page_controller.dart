import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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
  // Future<void> register() async {
  //   final nameError = validateName();
  //   final emailError = validateEmail();
  //   final passwordError = validatePassword();
  //   final confirmPasswordError = validateConfirmPassword();
  //
  //   final errorMessage =
  //      nameError ?? emailError ?? passwordError ?? confirmPasswordError;
  //
  //   if (errorMessage != null) {
  //     EasyLoading.showError(errorMessage);
  //     return;
  //   }
  //
  //   /// REAL SIGNUP
  //   await AuthService.signUp(
  //     name: nameController.text,
  //     email: emailController.text,
  //     password: passwordController.text,
  //   );
  // }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
