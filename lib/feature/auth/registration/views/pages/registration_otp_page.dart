import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/constant/widgets/auth_app_bar.dart';
import '../../../../../core/constant/widgets/otpbox.dart';
import '../../../../../core/constant/widgets/primary_button.dart';
import '../../../../../core/constant/widgets/success_dialog.dart';
import '../../../Login/views/login_page.dart';

class RegistrationOtpPage extends StatelessWidget {
  const RegistrationOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Text("Enter OTP", style: AppTextStyles.title24(context)),
              SizedBox(height: 10.h),
              Text(
                "We have just sent you 4 digit code via your\nemail example@gmail.com",
                textAlign: TextAlign.center,
                style: AppTextStyles.regular_16(context),
              ),
              SizedBox(height: 30.h),

              // Custom OTP Box tailored to the UI (4 circles)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: OtpBox(),
              ),
              SizedBox(height: 30.h),

              PrimaryButton(
                text: "Continue",
                onPressed: () => SuccessDialog.show(
                  subtitle: "Your account is successfully created",
                  context: context,
                  onPressed: () => Get.to(() => LoginPage()),
                ),
              ),
              SizedBox(height: 20.h),

              RichText(
                text: TextSpan(
                  text: "Didn’t receive code? ",
                  style: AppTextStyles.regular_16(context),
                  children: [
                    TextSpan(
                      text: "Resend Code",
                      style: AppTextStyles.bold_16(
                        context,
                      ).copyWith(color: AppColors.primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle Resend logic
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
