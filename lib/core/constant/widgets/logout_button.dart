import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../feature/auth/login/views/login_page.dart';
import '../../offline_storage/shared_pref.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';
import '../image_path.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = ProfileController.instance;
    return Center(
      child: TextButton(
        onPressed: () {
          Get.dialog(
            Dialog(
              backgroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 100.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 40.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Image
                    Image.asset(ImagePath.logoutIcon, height: 70.h, fit: BoxFit.cover),
                    SizedBox(height: 6.h),

                    /// Title
                    Text(
                      'Are You Sure?',
                      style: AppTextStyles.title24(context)
                    ),
                    SizedBox(height: 8.h),

                    /// Subtitle
                    Text(
                      "Do you want to log out ?",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular_16(context),
                    ),
                    SizedBox(height: 10.h),

                    /// Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                  side: BorderSide(width: 1.5.w, color: AppColors.redColor)
                              ),
                              backgroundColor: AppColors.whiteColor,
                            ),
                            onPressed: () => Get.offAll(() => LoginPage()),
                            child: Text(
                              "Log Out",
                              style: GoogleFonts.plusJakartaSans(color: AppColors.redColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              backgroundColor: AppColors.primaryColor,
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.plusJakartaSans(color: AppColors.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: true,
          );
        },
        child: Text(
          "Logout",
          style: GoogleFonts.plusJakartaSans(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.redColor),
        ),
      ),
    );
  }
}
