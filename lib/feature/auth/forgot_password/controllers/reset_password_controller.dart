import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  /// Password Controllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Observables
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;


  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
