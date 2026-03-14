import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_text_styles.dart';

class LabelText extends StatelessWidget {
  final BuildContext context;
  final String text;

  const LabelText({super.key, required this.context, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: AppTextStyles.regular_16(context),
      ),
    );
  }
}