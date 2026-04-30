import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shukriraad/core/constant/widgets/primary_button.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/constant/image_path.dart';

class SuccessDialog {
  static void show({
    required String subtitle,
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 100.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Image
              Image.asset(ImagePath.successLogo, height: 140.h),
              SizedBox(height: 12.h),

              /// Title
              Text('Success', style: AppTextStyles.title24(context)),
              SizedBox(height: 4.h),

              /// Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular_16(context),
              ),
              SizedBox(height: 20.h),

              /// Continue Button
              PrimaryButton(text: 'Continue', onPressed: onPressed),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
