import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/core/constant/app_colors.dart';
import 'package:shuhri/feature/profile/view/widgets/profile_list_tile.dart';
import 'package:shuhri/feature/profile/view/edit_profile_page.dart';
import 'package:shuhri/feature/profile/view/settings_page.dart';
import 'package:shuhri/feature/profile/view/privacy_policy_page.dart';
import 'package:shuhri/feature/profile/view/support_center_page.dart';
import 'package:shuhri/feature/profile/view/widgets/logout_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            child: Icon(Icons.arrow_back, color: Colors.black54, size: 20.sp),
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // Profile Image (using Stack for the badge)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundImage: AssetImage(
                          'assets/images/profile_placeholder.png',
                        ), // Example image
                        backgroundColor: Colors.amber.shade200,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => Get.to(() => const EditProfilePage()),
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Image.asset(
                            'assets/icons/edit.png',
                            width: 26.w,
                            height: 25.w,
                          ),
                          // child: Icon(
                          //   Icons.edit,
                          //   color: Colors.white,
                          //   size: 15.sp,
                          // ),
                        ),
                      ),
                    ),
                    // Floating "S" callout
                    //
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'MD. AKIB AHAMED',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'user@yourdomain.com',
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            Column(
              children: [
                ProfileListTile(
                  icon: Image.asset(
                    'assets/icons/notifications.png',
                    width: 26.w,
                    height: 25.w,
                  ),
                  title: 'Notification',
                  onTap: () {},
                ),
                ProfileListTile(
                  icon: Image.asset(
                    'assets/icons/language.png',
                    width: 26.w,
                    height: 25.w,
                  ),
                  title: 'Language',
                  trailingText: 'English (US)',
                  onTap: () {},
                ),
                ProfileListTile(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: AppColors.textColor,
                    size: 24.sp,
                  ),
                  title: 'Setting',
                  onTap: () => Get.to(() => const SettingsPage()),
                ),
                ProfileListTile(
                  icon: Icon(
                    Icons.help_outline,
                    color: AppColors.textColor,
                    size: 24.sp,
                  ),
                  title: 'Support Center',
                  onTap: () => Get.to(() => const SupportCenterPage()),
                ),
                ProfileListTile(
                  icon: Image.asset(
                    'assets/icons/locked.png',
                    width: 26.w,
                    height: 25.w,
                  ),
                  title: 'Privacy & Policy',
                  onTap: () => Get.to(() => const PrivacyPolicyPage()),
                ),
                ProfileListTile(
                  icon: Image.asset(
                    'assets/icons/log_out.png',
                    width: 26.w,
                    height: 25.w,
                  ),
                  // icon: Icons.logout_outlined,
                  title: 'Logout',
                  textColor: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const LogoutDialog(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
