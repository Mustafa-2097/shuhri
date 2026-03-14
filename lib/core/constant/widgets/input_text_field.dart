import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.regular_14(context),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}