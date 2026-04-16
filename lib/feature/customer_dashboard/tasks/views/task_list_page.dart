import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'edit_task_page.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final controller = Get.put(TaskController());
  final _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Pending',
    'In-Progress',
    'Completed',
    'High Priority',
    'Medium Priority',
    'Low Priority',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TaskModel> get _filteredTasks {
    List<TaskModel> tasks = controller.tasks.toList();

    // Apply search
    if (_searchQuery.isNotEmpty) {
      tasks = tasks
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply filter chip
    switch (_selectedFilter) {
      case 'Pending':
        tasks = tasks.where((t) => t.status == 'PENDING').toList();
        break;
      case 'In-Progress':
        tasks = tasks.where((t) => t.status == 'IN_PROGRESS').toList();
        break;
      case 'Completed':
        tasks = tasks.where((t) => t.status == 'COMPLETED').toList();
        break;
      case 'High Priority':
        tasks = tasks.where((t) => t.priority == 'HIGH').toList();
        break;
      case 'Medium Priority':
        tasks = tasks.where((t) => t.priority == 'MEDIUM').toList();
        break;
      case 'Low Priority':
        tasks = tasks.where((t) => t.priority == 'LOW').toList();
        break;
      default:
        break; // 'All' — no filter
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: Obx(() {
              final tasks = _filteredTasks;

              if (controller.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.task_alt_rounded,
                          size: 56.sp, color: const Color(0xFFCBD5E1)),
                      SizedBox(height: 12.h),
                      Text(
                        'No tasks yet',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 56.sp, color: const Color(0xFFCBD5E1)),
                      SizedBox(height: 12.h),
                      Text(
                        'No matching tasks',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildTaskItem(task: task),
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
      centerTitle: true,
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
        Obx(() => Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${_filteredTasks.length} tasks',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h, top: 8.h),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: const Color(0xFF94A3B8), size: 22.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search tasks by title...',
                      hintStyle: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 15.sp,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded,
                        color: const Color(0xFF94A3B8), size: 18.sp),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters
                  .map((f) => _buildFilterChip(f, _selectedFilter == f))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem({required TaskModel task}) {
    Color getPriorityColor(String priority) {
      if (priority == 'HIGH') return const Color(0xFFEF4444);
      if (priority == 'LOW') return const Color(0xFF22C55E);
      return const Color(0xFFF59E0B);
    }

    return GestureDetector(
      onTap: () =>
          Get.bottomSheet(EditTaskPage(task: task), isScrollControlled: true),
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
        child: Row(
          children: [
            // Priority left bar
            Container(
              width: 5.w,
              height: 90.h,
              decoration: BoxDecoration(
                color: getPriorityColor(task.priority),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Time badge
                    Container(
                      width: 58.w,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? const Color(0xFFF8FAFC)
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
                          SizedBox(height: 3.h),
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
                          // Date row
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 11,
                                color: const Color(0xFF94A3B8),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                task.formattedDate,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          // Tags row
                          Row(
                            children: [
                              _buildTag(
                                icon: Icons.timer_outlined,
                                text: '${task.duration}m',
                                color: const Color(0xFF2563EB),
                                bgColor: const Color(0xFFEEF2FF),
                              ),
                              SizedBox(width: 6.w),
                              _buildTag(
                                icon: Icons.flag_rounded,
                                text: task.priority,
                                color: getPriorityColor(task.priority),
                                bgColor: getPriorityColor(
                                  task.priority,
                                ).withOpacity(0.12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Check toggle
                    GestureDetector(
                      onTap: () => controller.updateTaskStatus(
                        task.id,
                        task.isCompleted ? 'PENDING' : 'COMPLETED',
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFF8FAFC),
                          shape: BoxShape.circle,
                          border: task.isCompleted
                              ? null
                              : Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Icon(
                          Icons.check,
                          color: task.isCompleted
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                          size: 17.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          SizedBox(width: 3.w),
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
