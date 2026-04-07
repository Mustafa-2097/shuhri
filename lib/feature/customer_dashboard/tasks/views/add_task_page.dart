import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/core/constant/widgets/primary_button.dart';
import '../controllers/task_controller.dart';
import 'widgets/voice_ui.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key});

  final controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              SizedBox(height: 32.h),
              _buildTextField(hintText: 'Enter your task...'),
              SizedBox(height: 16.h),
              _buildTimeField(time: '11:20 AM'),
              SizedBox(height: 16.h),
              _buildTextField(
                hintText: 'Add a description (optional)...',
                maxLines: 5,
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle('Quick duration'),
              SizedBox(height: 12.h),
              _buildDurationOptions(),
              SizedBox(height: 24.h),
              _buildSectionTitle('Quick options'),
              SizedBox(height: 12.h),
              _buildQuickOptions(),
              SizedBox(height: 48.h),
              _buildVoiceButton(),
              SizedBox(height: 12.h),
              _buildAddTaskButton(),
              SizedBox(height: 24.h),
              _buildAIFootnote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          'Add Task',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({required String hintText, int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: 18.sp,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          fontSize: 18.sp,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildTimeField({required String time}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const Icon(Icons.access_time_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildDurationOptions() {
    final durations = [
      {'label': '30 min', 'icon': Icons.access_time_rounded},
      {'label': '1 hour', 'icon': Icons.access_time_rounded},
      {'label': '2 hours', 'icon': Icons.access_time_rounded},
    ];

    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(durations.length, (index) {
            bool isSelected = controller.selectedDuration.value == index;
            return GestureDetector(
              onTap: () => controller.selectDuration(index),
              child: Container(
                width: 105.w,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2563EB).withOpacity(0.2) : const Color(0xFFF1F5F9),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      durations[index]['icon'] as IconData,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                      size: 18,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      durations[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }

  Widget _buildQuickOptions() {
    return Row(
      children: [
        _buildOptionPill(
          label: 'High Priority',
          icon: Icons.flag_outlined,
          observable: controller.isHighPriority,
          onTap: controller.togglePriority,
        ),
        SizedBox(width: 12.w),
        _buildOptionPill(
          label: 'Today',
          icon: Icons.calendar_today_outlined,
          observable: controller.isToday,
          onTap: controller.toggleToday,
        ),
      ],
    );
  }

  Widget _buildOptionPill({
    required String label,
    required IconData icon,
    required RxBool observable,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      bool isSelected = observable.value;
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? const Color(0xFF2563EB).withOpacity(0.2) : const Color(0xFFF1F5F9),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
                size: 18,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTap: () => Get.to(() => const VoiceListeningScreen()),
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_none_rounded, color: Color(0xFF0F172A)),
            SizedBox(width: 8.w),
            Text(
              'Add by Voice',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return PrimaryButton(text: "Add Task", onPressed: () {});
  }

  Widget _buildAIFootnote() {
    return Center(
      child: Text(
        '✨ AI will find the best time for your task',
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
