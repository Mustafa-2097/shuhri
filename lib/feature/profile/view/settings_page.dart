import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/core/constant/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool aiFeatures = true;
  bool smartReminders = true;
  bool dailySummary = true;
  bool autoOptimization = false;

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
          'Settings',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingItem(
                icon: Icons.auto_awesome,
                title: 'AI Features',
                description: '',
                value: aiFeatures,
                onChanged: (v) => setState(() => aiFeatures = v),
              ),
              _buildSettingItem(
                icon: Icons.notifications_none,
                title: 'Smart Reminders',
                description: 'Get AI powered task reminders.',
                value: smartReminders,
                onChanged: (v) => setState(() => smartReminders = v),
              ),
              _buildSettingItem(
                icon: Icons.description_outlined,
                title: 'Daily Summary',
                description: 'Receive end-of-day summaries.',
                value: dailySummary,
                onChanged: (v) => setState(() => dailySummary = v),
              ),
              _buildSettingItem(
                icon: Icons.bolt,
                title: 'Auto Optimization',
                description: 'Automatically reorganize tasks.',
                value: autoOptimization,
                onChanged: (v) => setState(() => autoOptimization = v),
              ),
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About MyDay AI',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Version 1.0.0-MVP1',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Your intelligent daily planner, designed for efficiency and powered by AI.',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Made with ❤️ for productivity enthusiasts.',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 24.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primaryColor,
              activeColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
