import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/feature/auth/registration/views/pages/popup_agreement.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/constant/widgets/input_text_field.dart';
import '../../../../core/constant/widgets/label_text.dart';
import '../../../../core/constant/widgets/primary_button.dart';
import '../controllers/registration_page_controller.dart';
import 'pages/registration_otp_page.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});
  final RegistrationPageController controller = Get.put(
    RegistrationPageController(),
  );

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
              AppBar(
                title: Center(
                  child: Text(
                    "Create Account",
                    style: AppTextStyles.title24(context),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Center(
                // child: Text(
                //   "Create Account",
                //   style: AppTextStyles.title24(context),
                // ),
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
              // Your Name
              LabelText(context: context, text: "Your Name"),
              InputTextField(
                controller: controller.nameController,
                hintText: "Enter your name",
              ),
              SizedBox(height: 16.h),

              // Email
              LabelText(context: context, text: "Email Address"),
              InputTextField(
                controller: controller.emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.h),

              // Password
              LabelText(context: context, text: "Password"),
              Obx(
                () => InputTextField(
                  controller: controller.passwordController,
                  hintText: "Password",
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
              SizedBox(height: 16.h),

              // Re-Password
              LabelText(context: context, text: "Re-Password"),
              Obx(
                () => InputTextField(
                  controller: controller.confirmPasswordController,
                  hintText: "Re-Password",
                  obscureText: controller.isConfirmPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.boxTextColor,
                    ),
                    onPressed: () {
                      controller.isConfirmPasswordHidden.value =
                          !controller.isConfirmPasswordHidden.value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Terms and Conditions checkbox
              Row(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.agreedToTerms.value =
                            !controller.agreedToTerms.value;
                      },
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.textColor,
                            width: 1,
                          ),
                          color: controller.agreedToTerms.value
                              ? AppColors.buttonColor
                              : Colors.transparent,
                        ),
                        child: controller.agreedToTerms.value
                            ? Icon(
                                Icons.check,
                                size: 16.sp,
                                color: AppColors.whiteColor,
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const PopupAgreement(),
                        );
                      },
                      child: Text(
                        "I'm agree with all Terms and Conditions",
                        style: AppTextStyles.regular_16(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Sign Up Button
              PrimaryButton(
                text: "Create An Account",
                onPressed: () {
                  Get.to(() => const RegistrationOtpPage());
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
