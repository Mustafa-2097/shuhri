import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/core/constant/app_colors.dart';
import 'package:shuhri/core/constant/widgets/primary_button.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

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
          'change_password'.tr,
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
            Text('old_password'.tr, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            _buildTextField(controller.oldPasswordController, 'enter_old_password'.tr, true),
            SizedBox(height: 20.h),
            Text('new_password'.tr, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            _buildTextField(controller.newPasswordController, 'enter_new_password'.tr, true),
            SizedBox(height: 20.h),
            Text('confirm_new_password'.tr, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            _buildTextField(controller.confirmPasswordController, 'confirm_new_password'.tr, true),
            SizedBox(height: 40.h),
            PrimaryButton(
              text: 'update_password'.tr,
              onPressed: () => controller.changePassword(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool obscure) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}
