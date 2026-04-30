import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shukriraad/feature/auth/login/views/login_page.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final int totalPages = 2;

  void changePage(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAll(() => LoginPage());
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
