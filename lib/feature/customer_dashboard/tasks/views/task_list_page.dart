import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'edit_task_page.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});

  final controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                _buildSectionHeader('Priority Tasks'),
                _buildTaskItem(
                  time: '11:20 AM',
                  title: 'Lunch Break',
                  duration: '1h',
                  priority: 'High',
                  priorityColor: const Color(0xFFEF4444),
                ),
                SizedBox(height: 16.h),
                _buildSectionHeader('Today'),
                _buildTaskItem(
                  time: '02:00 PM',
                  title: 'Client Meeting',
                  duration: '45m',
                  priority: 'Medium',
                  priorityColor: const Color(0xFFF59E0B),
                ),
                SizedBox(height: 16.h),
                _buildTaskItem(
                  time: '04:30 PM',
                  title: 'Code Review',
                  duration: '30m',
                  priority: 'Low',
                  priorityColor: const Color(0xFF22C55E),
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader('Completed'),
                _buildTaskItem(
                  time: '09:00 AM',
                  title: 'Morning Standup',
                  duration: '30m',
                  isCompleted: true,
                ),
                SizedBox(height: 100.h), // Space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Tasks List',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF0F172A),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.calendar_month_outlined, color: const Color(0xFF2563EB), size: 24.sp),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h, top: 8.h),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: const Color(0xFF94A3B8), size: 22.sp),
                hintText: 'Search tasks...',
                hintStyle: TextStyle(color: const Color(0xFF94A3B8), fontSize: 16.sp),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Today', false),
                _buildFilterChip('Incoming', false),
                _buildFilterChip('Priority', false),
                _buildFilterChip('Completed', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF64748B),
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildTaskItem({
    required String time,
    required String title,
    required String duration,
    String? priority,
    Color? priorityColor,
    bool isCompleted = false,
  }) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(const EditTaskPage(), isScrollControlled: true),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Time Badge
            Container(
              width: 70.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFFF8FAFC) : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.access_time_filled_rounded,
                    color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF2563EB),
                    size: 16,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF312E81),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _buildTag(
                        icon: Icons.access_time_rounded,
                        text: duration,
                        color: const Color(0xFF2563EB),
                        bgColor: const Color(0xFFEEF2FF),
                      ),
                      if (priority != null) ...[
                        SizedBox(width: 8.w),
                        _buildTag(
                          icon: Icons.flag_rounded,
                          text: priority,
                          color: priorityColor!,
                          bgColor: priorityColor.withOpacity(0.1),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Action Check
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF22C55E) : const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: isCompleted ? null : Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Icon(
                Icons.check,
                color: isCompleted ? Colors.white : const Color(0xFF94A3B8),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({required IconData icon, required String text, required Color color, required Color bgColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
