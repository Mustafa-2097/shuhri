import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shukriraad/feature/auth/forgot_password/views/pages/reset_password_page.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/constant/widgets/auth_app_bar.dart';
import '../../../../../core/constant/widgets/otpbox.dart';
import '../../../../../core/constant/widgets/primary_button.dart';
import '../../controllers/reset_otp_controller.dart';

class ResetOtpPage extends StatelessWidget {
  ResetOtpPage({super.key});
  final ResetOtpController controller = Get.find<ResetOtpController>();

  @override
  Widget build(BuildContext context) {
    // final sh = MediaQuery.of(context).size.height;
    // final sw = MediaQuery.of(context).size.width;

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
                "We have just sent you 6 digit code via your\nemail ${controller.email}",
                textAlign: TextAlign.center,
                style: AppTextStyles.regular_16(context),
              ),
              SizedBox(height: 30.h),


              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: OtpBox(
                  onChanged: (value) => controller.otp.value = value,
                ),
              ),
              SizedBox(height: 30.h),

              PrimaryButton(
                text: "Continue",
                onPressed: () => controller.verifyOtp(),
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
                          controller.resendOtp();
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
