import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

class GlobalFormLayout extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget bottomButton;

  const GlobalFormLayout({
    super.key,
    required this.title,
    required this.content,
    required this.bottomButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            right: 20.w,
            bottom: 15.h,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.textColor,
                    size: 24.w,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: content,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 20.h + MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: bottomButton,
            ),
          ),
        ],
      ),
    );
  }
}
