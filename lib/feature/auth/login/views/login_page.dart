import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/constant/widgets/input_text_field.dart';
import '../../../../core/constant/widgets/label_text.dart';
import '../../../../core/constant/widgets/primary_button.dart';
import '../../../customer_dashboard/dashboard/dashboard.dart';
import '../../forgot_password/views/forgot_password_page.dart';
import '../../registration/views/registration_page.dart';
import '../controllers/login_page_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginPageController controller = Get.find<LoginPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              /// Title+SubTitle Text
              Center(
                child: Text(
                  "Let’s Sign you in",
                  style: AppTextStyles.title24(context),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Enter your company details for use in reports and documents.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular_16(context),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              /// ALL Input Field
              // Email Address
              LabelText(context: context, text: "Email Address"),
              InputTextField(
                controller: controller.emailController,
                hintText: "Enter your email address",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.h),

              // Password
              LabelText(context: context, text: "Password"),
              Obx(
                () => InputTextField(
                  controller: controller.passwordController,
                  hintText: "Enter your password",
                  obscureText: controller.isPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.boxTextColor,
                    ),
                    onPressed: () {
                      controller.isPasswordHidden.value =
                          !controller.isPasswordHidden.value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.rememberMe.value =
                                !controller.rememberMe.value;
                          },
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.textColor,
                                width: 1,
                              ),
                              color: controller.rememberMe.value
                                  ? AppColors.buttonColor
                                  : Colors.transparent,
                            ),
                            child: controller.rememberMe.value
                                ? Icon(
                                    Icons.check,
                                    size: 12.sp,
                                    color: AppColors.whiteColor,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Remember Me",
                        style: AppTextStyles.regular_16(context),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => ForgotPasswordPage()),
                    child: Text(
                      "Forgot Password?",
                      style: AppTextStyles.regular_14(
                        context,
                      ).copyWith(color: AppColors.redColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Login Button
              PrimaryButton(text: "Login", onPressed: () => controller.login()),
              SizedBox(height: 30.h),

              // Don't have an account
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: AppTextStyles.regular_16(context),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: AppTextStyles.bold_16(
                          context,
                        ).copyWith(color: AppColors.buttonColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => RegistrationPage()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
