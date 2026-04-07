import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/core/constant/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black54,
              size: 20.sp,
            ),
          ),
        ),
        title: Text(
          'Privacy & Policy',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              _dummyText,
              style: TextStyle(
                color: AppColors.textColor.withOpacity(0.7),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Changes to the Service and/or Terms:',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              _dummyText,
              style: TextStyle(
                color: AppColors.textColor.withOpacity(0.7),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const String _dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget ornare quam vel facilisis feugiat amet sagittis arcu, tortor. Sapien, consequat ultrices morbi sed. Eu sed et non, leo auctor ut sed. Eu sed et non, leo auctor ut sed. Eget ornare quam vel facilisis feugiat amet sagittis arcu, tortor. Sapien, consequat ultrices morbi sed. Eu sed et non, leo auctor ut sed. Eu sed et non, leo auctor ut sed.';
}
