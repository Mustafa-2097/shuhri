import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shukriraad/core/constant/app_colors.dart';

class ProfileListTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? trailingText;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Color? textColor;

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingIcon,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 24.w,
        height: 24.w,
        child: Center(child: icon),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: TextStyle(color: AppColors.subTextColor, fontSize: 14.sp),
            ),
          SizedBox(width: 8.w),
          Icon(
            trailingIcon ?? Icons.arrow_forward_ios,
            size: 14.sp,
            color: AppColors.subTextColor,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
