import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../app_colors.dart';

class OtpBox extends StatelessWidget {
  final Function(String)? onChanged;
  const OtpBox({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      keyboardType: TextInputType.number,
      cursorColor: AppColors.textColor,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E293B),
      ),
      animationType: AnimationType.fade,
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderRadius: BorderRadius.circular(10.r),
        fieldHeight: 65.h,
        fieldWidth: 60.w,
        borderWidth: 1,
        
        // Background colors
        activeFillColor: const Color(0xFFF5F6FA),
        inactiveFillColor: const Color(0xFFF5F6FA),
        selectedFillColor: Colors.white,

        // Border colors
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedColor: AppColors.primaryColor,
      ),
      onChanged: onChanged,
    );
    // return PinCodeTextField(
    //   appContext: context,
    //   length: 6,
    //   keyboardType: TextInputType.number,
    //   cursorColor: AppColors.textColor,
    //   textStyle: AppTextStyles.title24(context),
    //   animationType: AnimationType.fade,
    //   pinTheme: PinTheme(
    //     shape: PinCodeFieldShape.box,
    //     borderRadius: BorderRadius.circular(12.r),
    //     fieldHeight: 50.h,
    //     fieldWidth: 50.w,
    //     activeColor: AppColors.whiteColor,
    //     selectedColor: AppColors.whiteColor,
    //   ),
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   onChanged: onChanged,
    // );
  }
}
