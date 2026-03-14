import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                0,
                "assets/icons/home.png",
                "assets/icons/home_selected.png",
                'Home',
              ),
              _buildNavItem(
                1,
                "assets/icons/inventory.png",
                "assets/icons/inventory_selected.png",
                'Task',
              ),_buildNavItem(
                2,
                "assets/icons/event.png",
                "assets/icons/event_selected.png",
                'AI',
              ),
              _buildNavItem(
                3,
                "assets/icons/profile.png",
                "assets/icons/profile_selected.png",
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index,
      String outlinedIcon,
      String filledIcon,
      String label,
      ) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: isSelected
            ? BoxDecoration(borderRadius: BorderRadius.circular(12.r))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h),
            Image.asset(
              isSelected
                  ? filledIcon
                  : outlinedIcon, // ✅ Use filled icon when selected
              color: isSelected ? AppColors.primaryColor : AppColors.textColor,
              width: 26.w,
              height: 26.h,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.textColor,
                fontSize: 14.sp,
                fontFamily: "Roboto",
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
