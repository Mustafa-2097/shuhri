import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildFilterToggle(),
          SizedBox(height: 24.h),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = controller.filteredNotifications;
              if (list.isEmpty) {
                return Center(child: Text("No notifications".tr));
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: list.length + 1,
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return Column(
                      children: [
                        SizedBox(height: 24.h),
                        _buildClearAllButton(),
                        SizedBox(height: 32.h),
                      ],
                    );
                  }
                  final item = list[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildNotificationCard(
                      icon: Icons.notifications_active,
                      iconColor: const Color(0xFF2563EB),
                      iconBgColor: const Color(0xFFEEF2FF),
                      title: item['title']?.toString() ?? 'Notification',
                      description:
                          item['message']?.toString() ??
                          item['description']?.toString() ??
                          '',
                      time: item['createdAt'] != null ? "Recent" : "Just now",
                      isUnread: !(item['isRead'] == true),
                      onTap: () => controller.markAsRead(
                        item['id'] ?? item['_id'] ?? '',
                      ),
                      onDelete: () => controller.deleteNotification(
                        item['id'] ?? item['_id'] ?? '',
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 70.w,
      leading: Center(
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Icon(
              Icons.arrow_back,
              color: const Color(0xFF64748B),
              size: 20.sp,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'notification'.tr,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          Obx(
            () => Text(
              '${controller.unreadCount} unread'.tr,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => controller.markAllAsRead(),
          child: Text(
            'Mark all read'.tr,
            style: TextStyle(
              color: const Color(0xFF2563EB),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                'All'.tr + ' (${controller.notificationsList.length})'.tr,
                0,
              ),
            ),
            Expanded(
              child: _buildToggleButton(
                'Unread'.tr + ' (${controller.unreadCount})'.tr,
                1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, int index) {
    bool isSelected = controller.selectedFilter.value == index;
    return GestureDetector(
      onTap: () => controller.selectedFilter.value = index,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Left blue accent for unread
              if (isUnread)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4.w, color: const Color(0xFF2563EB)),
                ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 22.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.withOpacity(0.7),
                        size: 20.sp,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

  Widget _buildClearAllButton() {
    return GestureDetector(
      onTap: () => controller.deleteAllNotifications(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Center(
          child: Text(
            'Clear All Notifications',
            style: TextStyle(
              color: const Color(0xFF475569),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
