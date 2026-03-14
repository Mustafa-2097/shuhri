import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  static LoginPageController get instance => Get.find();

  /// Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Observables
  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

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
  // Future<void> login() async {
  //   final emailError = validateEmail();
  //   final passError = validatePassword();
  //
  //   if (emailError != null || passError != null) {
  //     EasyLoading.showError(emailError ?? passError!);
  //     return;
  //   }
  //
  //   /// Call AuthService (REAL LOGIN)
  //   await AuthService.login(
  //     email: emailController.text,
  //     password: passwordController.text,
  //   );
  // }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
