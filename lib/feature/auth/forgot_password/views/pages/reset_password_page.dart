import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/constant/widgets/auth_app_bar.dart';
import '../../../../../core/constant/widgets/input_text_field.dart';
import '../../../../../core/constant/widgets/label_text.dart';
import '../../../../../core/constant/widgets/primary_button.dart';
import '../../../../../core/constant/widgets/success_dialog.dart';
import '../../../Login/views/login_page.dart';
import '../../controllers/reset_password_controller.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    // final sh = MediaQuery.of(context).size.height;
    // final sw = MediaQuery.of(context).size.width;

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
                  "Create a New Password",
                  style: AppTextStyles.title24(context),
                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Enter your new password",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular_16(context),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Password
              LabelText(context: context, text: "New Password"),
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
              SizedBox(height: 16.h),

              // Re-Password
              LabelText(context: context, text: "Confirm Password"),
              Obx(
                    () => InputTextField(
                  controller: controller.confirmPasswordController,
                  hintText: "Confirm your password",
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
              SizedBox(height: 30.h),

              // Sign Up Button
              PrimaryButton(
                text: "Next",
                onPressed: () => SuccessDialog.show(
                  subtitle: "Your password is successfully reset",
                  context: context,
                  onPressed: () => Get.to(() => LoginPage()),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
