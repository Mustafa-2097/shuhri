import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shukriraad/core/constant/app_colors.dart';

class SupportCenterPage extends StatelessWidget {
  const SupportCenterPage({super.key});

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
          'support_center'.tr,
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
          children: [
            _buildFAQItem('how_to_add_task', 'how_to_add_task_ans'),
            _buildFAQItem('ai_optimization', 'ai_optimization_ans'),
            _buildFAQItem('sync_devices', 'sync_devices_ans'),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(
    String questionKey,
    String answerKey, {
    bool isExpanded = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10.r,
            spreadRadius: 1.r,
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: Text(
            questionKey.tr,
            style: TextStyle(
              color: isExpanded ? AppColors.primaryColor : AppColors.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
              child: Text(
                answerKey.tr,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
