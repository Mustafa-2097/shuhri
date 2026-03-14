import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../controllers/registration_page_controller.dart';

class PopupAgreement extends StatelessWidget {
  const PopupAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    final RegistrationPageController controller =
        Get.find<RegistrationPageController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
      backgroundColor: AppColors.whiteColor,
      //insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scrollable text area
            Flexible(
              child: RawScrollbar(
                thumbColor: AppColors.buttonColor,
                radius: Radius.circular(8.r),
                thickness: 4.w,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Column(
                    children: [
                      Text(
                        "I agree to the Terms of Service and Conditions of Use including consent to electronic communications and I affirm that the information provided is my own.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular_14(context).copyWith(
                          color: AppColors.textColor,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "I agree to the Terms of Service and Conditions of Use including consent to electronic communications and I affirm that the information provided is my own.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular_14(context).copyWith(
                          color: AppColors.textColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Disagree
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.agreedToTerms.value = false;
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      "Disagree",
                      style: AppTextStyles.bold_16(context).copyWith(
                        color: AppColors.redColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),

                // Agree
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.agreedToTerms.value = true;
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Agree",
                      style: AppTextStyles.bold_16(context).copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
