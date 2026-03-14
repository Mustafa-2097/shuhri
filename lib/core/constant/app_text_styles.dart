import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle title32(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textColor,
      fontSize: sw * 0.085, // 32
      fontWeight: FontWeight.w700,
      height: 0, // normal
    );
  }

  static TextStyle title24(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textColor,
      fontSize: sw * 0.064, // 24
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle bold_18(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.whiteColor,
      fontSize: sw * 0.048, // 18
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle bold_16(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.whiteColor,
      fontSize: sw * 0.043, // 16
      fontWeight: FontWeight.w700,
    );
  }


  /// Regular Text
  static TextStyle regular_16(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.subTextColor,
      fontSize: sw * 0.042, // 16
      fontWeight: FontWeight.w400,
      height: 1.5, // normal
    );
  }
  static TextStyle regular_14(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.subTextColor,
      fontSize: sw * 0.037, // 14
      fontWeight: FontWeight.w400,
    );
  }

  // static TextStyle body3 = GoogleFonts.plusJakartaSans(
  //   color: AppColors.subTextColor,
  //   fontSize: 14.sp,
  //   fontWeight: FontWeight.w600,
  // );
}
