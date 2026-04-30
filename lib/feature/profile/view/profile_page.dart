import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shukriraad/core/constant/app_colors.dart';
import 'package:shukriraad/feature/customer_dashboard/notifications/views/notification_page.dart';
import 'package:shukriraad/feature/profile/view/widgets/profile_list_tile.dart';
import 'package:shukriraad/feature/profile/view/edit_profile_page.dart';
import 'package:shukriraad/feature/profile/view/settings_page.dart';
import 'package:shukriraad/feature/profile/view/privacy_policy_page.dart';
import 'package:shukriraad/feature/profile/view/support_center_page.dart';
import 'package:shukriraad/feature/profile/view/widgets/logout_dialog.dart';
import 'package:shukriraad/feature/profile/controller/profile_controller.dart';
import 'package:shukriraad/feature/profile/view/change_password_page.dart';

class ProfilePage extends StatelessWidget {
  final bool showBackButton;
  const ProfilePage({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
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
              )
            : null,
        title: Text(
          'profile'.tr,
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
                      child: Obx(() {
                        final imgUrl = profileController.profileImage.value;
                        return CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.amber.shade200,
                          backgroundImage: imgUrl.isNotEmpty
                              ? NetworkImage(imgUrl)
                              : const AssetImage(
                                      'assets/images/profile_placeholder.png',
                                    )
                                    as ImageProvider,
                        );
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          await Get.to(() => const EditProfilePage());
                          profileController.getProfile();
                        },
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Obx(
              () => Text(
                profileController.name.value.isEmpty
                    ? 'MD. AKIB AHAMED'
                    : profileController.name.value,
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(
              () => Text(
                profileController.email.value.isEmpty
                    ? 'user@yourdomain.com'
                    : profileController.email.value,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
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
                  title: 'notification'.tr,
                  onTap: () => Get.to(() => const NotificationPage()),
                ),
                PopupMenuButton<String>(
                  offset: const Offset(1, 45),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 4,
                  constraints: BoxConstraints(
                    maxWidth: 180.w,
                    maxHeight: 300.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  initialValue: profileController.selectedLanguage.value,
                  onSelected: (String value) {
                    profileController.updateLanguage(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return profileController.languages.map((String language) {
                      return PopupMenuItem<String>(
                        value: language,
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              profileController.languageFlags[language] ?? '',
                              style: TextStyle(fontSize: 22.sp),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                profileController
                                        .languageNativeNames[language] ??
                                    language,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Obx(
                    () => ProfileListTile(
                      icon: Image.asset(
                        'assets/icons/language.png',
                        width: 26.w,
                        height: 25.w,
                      ),
                      title: 'language'.tr,
                      trailingText: profileController.selectedLanguage.value
                          .toLowerCase()
                          .tr,
                      trailingIcon: Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
                ProfileListTile(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: AppColors.textColor,
                    size: 24.sp,
                  ),
                  title: 'setting'.tr,
                  onTap: () => Get.to(() => const SettingsPage()),
                ),
                ProfileListTile(
                  icon: Icon(
                    Icons.lock_outline,
                    color: AppColors.textColor,
                    size: 24.sp,
                  ),
                  title: 'change_password'.tr,
                  onTap: () => Get.to(() => const ChangePasswordPage()),
                ),

                ProfileListTile(
                  icon: Icon(
                    Icons.help_outline,
                    color: AppColors.textColor,
                    size: 24.sp,
                  ),
                  title: 'support_center'.tr,
                  onTap: () => Get.to(() => const SupportCenterPage()),
                ),
                ProfileListTile(
                  icon: Image.asset(
                    'assets/icons/locked.png',
                    width: 26.w,
                    height: 25.w,
                  ),
                  title: 'privacy_policy'.tr,
                  onTap: () => Get.to(() => const PrivacyPolicyPage()),
                ),
                ProfileListTile(
                  icon: Image.asset(
                    'assets/icons/log_out.png',
                    width: 26.w,
                    height: 25.w,
                  ),
                  // icon: Icons.logout_outlined,
                  title: 'logout'.tr,
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
