import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/controllers/task_controller.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/views/widgets/voice_ui.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Voice Assistant',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Add tasks with your voice',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Hero voice button
              GestureDetector(
                onTap: () => Get.to(() => const VoiceListeningScreen()),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pulse rings
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          Container(
                            width: 76.w,
                            height: 76.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.18),
                            ),
                          ),
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.mic_rounded,
                              color: const Color(0xFF2563EB),
                              size: 30.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Tap to Speak',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Tell me what task to add',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Tips
              Text(
                'Voice Tips',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 12.h),

              _buildTip(
                icon: Icons.lightbulb_outline_rounded,
                iconColor: const Color(0xFFF59E0B),
                bgColor: const Color(0xFFFFFBEB),
                text: 'Say "Remind me to call John at 3 PM"',
              ),
              SizedBox(height: 10.h),
              _buildTip(
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF2563EB),
                bgColor: const Color(0xFFEEF2FF),
                text: 'Say "Add a high priority meeting task"',
              ),
              SizedBox(height: 10.h),
              _buildTip(
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF22C55E),
                bgColor: const Color(0xFFDCFCE7),
                text: 'Speak clearly — AI transcribes instantly',
              ),

              SizedBox(height: 28.h),

              // Recent tasks mini-preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Tasks',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.fetchTasks(),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: const Color(0xFF2563EB),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              Obx(() {
                if (controller.tasks.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Center(
                      child: Text(
                        'No tasks yet. Use voice to add one!',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }

                final recent = controller.tasks.take(3).toList();
                return Column(
                  children: recent.map((task) => _buildTaskTile(task)).toList(),
                );
              }),

              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTip({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(TaskModel task) {
    Color priorityColor() {
      if (task.priority == 'HIGH') return const Color(0xFFEF4444);
      if (task.priority == 'LOW') return const Color(0xFF22C55E);
      return const Color(0xFFF59E0B);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: priorityColor(),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: task.isCompleted
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF0F172A),
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(
                  '${task.duration}m · ${task.priority}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            task.isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: task.isCompleted
                ? const Color(0xFF22C55E)
                : const Color(0xFFCBD5E1),
            size: 22.sp,
          ),
        ],
      ),
    );
  }
}
