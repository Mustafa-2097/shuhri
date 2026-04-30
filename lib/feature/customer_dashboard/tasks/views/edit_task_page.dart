import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController _timeController;
  late TextEditingController _durationController;
  late DateTime _selectedDateTime;
  late int _selectedDuration;
  late String _selectedPriority;
  late bool _isToday;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _selectedDateTime = DateTime.parse(widget.task.dateTime).toLocal();
    _selectedDuration = widget.task.duration;
    _selectedPriority = widget.task.priority;

    final now = DateTime.now();
    _isToday = _selectedDateTime.year == now.year &&
        _selectedDateTime.month == now.month &&
        _selectedDateTime.day == now.day;

    _timeController = TextEditingController(text: _formatTime(_selectedDateTime));
    _durationController = TextEditingController(text: _formatDuration(_selectedDuration));
  }

  String _formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) return '${hours}h';
      return '${hours}h ${remainingMinutes}m';
    }
    return '${minutes}m';
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        _timeController.text = _formatTime(_selectedDateTime);
      });
    }
  }

  int _parseDuration(String text) {
    text = text.toLowerCase().trim();
    if (text.contains('h')) {
      final parts = text.split('h');
      int hours = int.tryParse(parts[0].trim()) ?? 0;
      int mins = 0;
      if (parts.length > 1 && parts[1].contains('m')) {
        mins = int.tryParse(parts[1].replaceAll('m', '').trim()) ?? 0;
      } else if (parts.length > 1 && parts[1].trim().isNotEmpty) {
        mins = int.tryParse(parts[1].trim()) ?? 0;
      }
      return (hours * 60) + mins;
    }
    if (text.contains('m')) {
      return int.tryParse(text.replaceAll('m', '').trim()) ?? 0;
    }
    return int.tryParse(text) ?? 60;
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'task_title_empty'.tr);
      return;
    }

    int finalDuration = _parseDuration(_durationController.text);

    taskController.updateTask(
      id: widget.task.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dateTime: _selectedDateTime.toUtc().toIso8601String(),
      duration: finalDuration,
      priority: _selectedPriority,
      status: widget.task.status,
    );
    Get.back();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _timeController.dispose();
    _durationController.dispose();
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
                  'edit_task'.tr,
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
            _buildLabel('task_title'.tr),
            SizedBox(height: 8.h),
            _buildTextField(controller: _titleController, hintText: 'task_title_hint'.tr),
            SizedBox(height: 16.h),
            // Description
            _buildLabel('description'.tr),
            SizedBox(height: 8.h),
            _buildTextField(
              controller: _descController,
              hintText: 'description_hint'.tr,
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            // Time
            _buildLabel('time'.tr),
            SizedBox(height: 8.h),
            _buildTextField(
              controller: _timeController,
              hintText: '11:20 AM',
              readOnly: true,
              onTap: _pickTime,
              suffixIcon: Icon(Icons.access_time_outlined, color: const Color(0xFF94A3B8), size: 22.sp),
            ),
            SizedBox(height: 16.h),
            // Duration
            _buildLabel('duration'.tr),
            SizedBox(height: 8.h),
            _buildTextField(
              controller: _durationController,
              hintText: '1h',
            ),
            SizedBox(height: 16.h),
            // Priority Selector
            _buildLabel('priority'.tr),
            SizedBox(height: 12.h),
            Row(
              children: ['LOW', 'MEDIUM', 'HIGH'].map((p) {
                final isSelected = _selectedPriority == p;
                final color = p == 'HIGH'
                    ? const Color(0xFFEF4444)
                    : p == 'MEDIUM'
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF22C55E);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPriority = p),
                    child: Container(
                      margin: EdgeInsets.only(right: p != 'HIGH' ? 8.w : 0),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? color : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          p.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? color : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            // Quick options
            _buildLabel('quick_options'.tr),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildQuickOption(
                  label: 'high_priority'.tr,
                  icon: Icons.flag_outlined,
                  isSelected: _selectedPriority == 'HIGH',
                  onTap: () => setState(() {
                    if (_selectedPriority == 'HIGH') {
                      _selectedPriority = 'MEDIUM';
                    } else {
                      _selectedPriority = 'HIGH';
                    }
                  }),
                ),
                SizedBox(width: 12.w),
                _buildQuickOption(
                  label: 'today'.tr,
                  icon: Icons.calendar_today_outlined,
                  isSelected: _isToday,
                  onTap: () {
                    setState(() {
                      _isToday = !_isToday;
                      if (_isToday) {
                        final now = DateTime.now();
                        _selectedDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          _selectedDateTime.hour,
                          _selectedDateTime.minute,
                        );
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 32.h),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _saveTask,
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
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              'save_changes'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
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
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildQuickOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
