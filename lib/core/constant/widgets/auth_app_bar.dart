import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../app_colors.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 65.w, // Ensure there is enough width for the left padding + button
      leading: Padding(
        padding: EdgeInsets.only(left: 24.w, top: 4.h), // Adjust distance from the left edge
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 48.w, // Made the circle bigger
            height: 48.w,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: AppColors.textColor, size: 20.sp),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
