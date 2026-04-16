import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/feature/auth/forgot_password/views/pages/reset_otp_page.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/constant/widgets/auth_app_bar.dart';
import '../../../../core/constant/widgets/input_text_field.dart';
import '../../../../core/constant/widgets/label_text.dart';
import '../../../../core/constant/widgets/primary_button.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
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
                  "Forgot Password",
                  style: AppTextStyles.title24(context),
                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Recover your account password",
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
              SizedBox(height: 30.h),

              // Next Button
              PrimaryButton(text: "Next", onPressed: () => controller.sendForgotPassword()),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
