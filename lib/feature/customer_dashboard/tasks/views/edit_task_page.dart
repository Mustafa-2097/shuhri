import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;
  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final taskController = Get.find<TaskController>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedPriority;
  late String _selectedStatus;

  final List<String> _priorities = ['LOW', 'MEDIUM', 'HIGH'];
  final List<String> _statuses = ['PENDING', 'IN_PROGRESS', 'COMPLETED'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _selectedPriority = widget.task.priority;
    _selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Task',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: const Color(0xFF64748B), size: 24.sp),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Task Title
            _buildLabel('Task Title'),
            SizedBox(height: 8.h),
            _buildTextField(controller: _titleController, hintText: 'Task title...'),
            SizedBox(height: 16.h),
            // Description
            _buildLabel('Description'),
            SizedBox(height: 8.h),
            _buildTextField(
              controller: _descController,
              hintText: 'Add a description (optional)...',
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            // Priority
            _buildLabel('Priority'),
            SizedBox(height: 8.h),
            _buildDropdown(
              value: _selectedPriority,
              items: _priorities,
              onChanged: (val) => setState(() => _selectedPriority = val!),
              icon: Icons.flag_outlined,
              colorMap: {
                'LOW': const Color(0xFF22C55E),
                'MEDIUM': const Color(0xFFF59E0B),
                'HIGH': const Color(0xFFEF4444),
              },
            ),
            SizedBox(height: 16.h),
            // Status
            _buildLabel('Status'),
            SizedBox(height: 8.h),
            _buildDropdown(
              value: _selectedStatus,
              items: _statuses,
              onChanged: (val) => setState(() => _selectedStatus = val!),
              icon: Icons.radio_button_checked_outlined,
              colorMap: {
                'PENDING': const Color(0xFF94A3B8),
                'IN_PROGRESS': const Color(0xFF2563EB),
                'COMPLETED': const Color(0xFF22C55E),
              },
            ),
            SizedBox(height: 32.h),
            // Update Status button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton.icon(
                onPressed: () => taskController.updateTaskStatus(widget.task.id, _selectedStatus),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: const Icon(Icons.sync_rounded, color: Color(0xFF2563EB), size: 20),
                label: Text(
                  'Update Status Only',
                  style: TextStyle(
                    color: const Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Delete button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  taskController.deleteTaskById(widget.task.id);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
                label: Text(
                  'Delete Task',
                  style: TextStyle(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Save button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Task title cannot be empty');
                    return;
                  }
                  taskController.updateTask(
                    id: widget.task.id,
                    title: _titleController.text.trim(),
                    description: _descController.text.trim(),
                    dateTime: widget.task.dateTime,
                    duration: widget.task.duration,
                    priority: _selectedPriority,
                    status: _selectedStatus,
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_as_outlined, color: Colors.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF0F172A),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: 15.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required Map<String, Color> colorMap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, color: colorMap[item] ?? Colors.grey, size: 16),
                  SizedBox(width: 8.w),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: colorMap[item] ?? const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
