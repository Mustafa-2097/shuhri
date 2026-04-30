import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/feature/profile/view/profile_page.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/views/add_task_page.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/views/edit_task_page.dart';
import 'package:shuhri/feature/customer_dashboard/notifications/views/notification_page.dart';
import 'package:shuhri/feature/customer_dashboard/home/controllers/home_controller.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/controllers/task_controller.dart';
import 'package:shuhri/feature/customer_dashboard/notifications/controllers/notification_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final homeController = Get.put(HomeController());
  final taskController = Get.put(TaskController());
  final notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: _buildFAB(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildTodayOverview(context),
                    SizedBox(height: 20.h),
                    _buildReOptimizeButton(),
                    SizedBox(height: 24.h),
                    _buildTaskList(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'welcome_back'.tr,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'ready_for_tasks'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.to(() => const NotificationPage()),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Obx(() {
                      final count = notificationController.unreadCount;
                      if (count == 0) return const SizedBox.shrink();
                      return Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xFFF1F5F9),
                child: GestureDetector(
                  onTap: () => Get.to(() => const ProfilePage()),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF2563EB),
                  ), // Placeholder for image
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //    Examine  the Progress ui
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget _buildTodayOverview(BuildContext context) {
    return Obx(() {
      // Ensure these are treated as doubles for precise calculation
      final totalTasks = homeController.todayTasksNumber.value;
      final remain = homeController.remainingTaskNumber.value;
      final focusTime = homeController.focusTime.value;

      // Logic check: if totalTasks is 0, progress should be 0 to avoid NaN errors
      final double progress = totalTasks > 0
          ? (totalTasks - remain) / totalTasks
          : 0.0;

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('📊', style: TextStyle(fontSize: 18.sp)),
                SizedBox(width: 8.w),
                Text(
                  'today_overview'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(totalTasks.toString(), 'total_tasks'.tr),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatBox(remain.toString(), 'remain'.tr),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatBox('${focusTime}h', 'focus_time'.tr),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'progress'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Widget _buildTodayOverview(BuildContext context) {
  //   return Obx(() {
  //     final totalTasks = homeController.todayTasksNumber.value;
  //     final remain = homeController.remainingTaskNumber.value;
  //     final focusTime = homeController.focusTime.value;
  //     final progress = homeController.progress.value;
  //
  //     return Container(
  //       padding: EdgeInsets.all(20.w),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20.r),
  //         border: Border.all(color: const Color(0xFFF1F5F9)),
  //         boxShadow: [
  //           BoxShadow(
  //             color: const Color(0xFF0F172A).withOpacity(0.05),
  //             offset: const Offset(0, 4),
  //             blurRadius: 12,
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Text('📊', style: TextStyle(fontSize: 18.sp)),
  //               SizedBox(width: 8.w),
  //               Text(
  //                 'today_overview'.tr,
  //                 style: TextStyle(
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.w700,
  //                   color: const Color(0xFF0F172A),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 20.h),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               _buildStatBox(totalTasks.toString(), 'total_tasks'.tr),
  //               _buildStatBox(remain.toString(), 'remain'.tr),
  //               _buildStatBox('${focusTime}h', 'focus_time'.tr),
  //             ],
  //           ),
  //           SizedBox(height: 24.h),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'progress'.tr,
  //                 style: TextStyle(
  //                   fontSize: 14.sp,
  //                   color: const Color(0xFF64748B),
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //     Text(
  //                 '${(progress * 1).toInt()}%',
  //                 style: TextStyle(
  //                   fontSize: 14.sp,
  //                   color: const Color(0xFF2563EB),
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 8.h),
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10.r),
  //             child: LinearProgressIndicator(
  //               value: progress,
  //               minHeight: 8.h,
  //               backgroundColor: const Color(0xFFF1F5F9),
  //               valueColor: const AlwaysStoppedAnimation<Color>(
  //                 Color(0xFF0F172A),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _buildStatBox(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildReOptimizeButton() {
    return GestureDetector(
      onTap: () => homeController.reoptimizeMyDay(),
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt, color: Color(0xFF2563EB), size: 20),
            SizedBox(width: 8.w),
            Text(
              're_optimize'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2563EB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(
      () => Column(
        children: taskController.tasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTaskItem(index: index, task: task),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskItem({required int index, required TaskModel task}) {
    Color priorityColor(String p) {
      if (p == 'HIGH') return const Color(0xFFEF4444);
      if (p == 'LOW') return const Color(0xFF22C55E);
      return const Color(0xFFF59E0B);
    }

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Priority left bar
            Container(
              width: 5.w,
              decoration: BoxDecoration(
                color: priorityColor(task.priority),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  children: [
                  // Time badge
                  Container(
                    width: 62.w,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: task.isCompleted
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF2563EB),
                          size: 14,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          task.time,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: task.isCompleted
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF312E81),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: task.isCompleted
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF0F172A),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 10,
                              color: const Color(0xFF94A3B8),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              task.formattedDate,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            _buildMiniTag(
                              '${task.duration}m',
                              const Color(0xFF2563EB),
                              const Color(0xFFEEF2FF),
                            ),
                            SizedBox(width: 6.w),
                            _buildMiniTag(
                              task.priority.toLowerCase().tr,
                              priorityColor(task.priority),
                              priorityColor(task.priority).withOpacity(0.1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions column
                  Column(
                    children: [
                      _buildTaskAction(
                        icon: task.isCompleted
                            ? Icons.undo_rounded
                            : Icons.check,
                        color: const Color(0xFF22C55E),
                        bgColor: const Color(0xFFDCFCE7),
                        onTap: () => taskController.toggleTaskCompletion(index),
                      ),
                      SizedBox(height: 6.h),
                      _buildTaskAction(
                        icon: Icons.edit_outlined,
                        color: const Color(0xFF2563EB),
                        bgColor: const Color(0xFFDBEAFE),
                        onTap: () => Get.bottomSheet(
                          EditTaskPage(task: task),
                          isScrollControlled: true,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _buildTaskAction(
                        icon: Icons.delete_outline_rounded,
                        color: const Color(0xFFEF4444),
                        bgColor: const Color(0xFFFEE2E2),
                        onTap: () => taskController.deleteTask(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildMiniTag(String text, Color color, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTaskAction({
    required IconData icon,
    required Color color,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => Get.to(() => AddTaskPage(), transition: Transition.downToUp),
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF2563EB),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 36),
      ),
    );
  }
}
