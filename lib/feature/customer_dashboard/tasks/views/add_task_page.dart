import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/core/constant/widgets/primary_button.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/controllers/task_controller.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/views/widgets/voice_ui.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final controller = Get.find<TaskController>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _customDurationController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));

  // -1 means custom input is being used
  int _selectedChip = 1; // 0 = 30m, 1 = 1h, 2 = 2h, -1 = custom

  final List<Map<String, dynamic>> _durationChips = [
    {'label': 'thirty_min'.tr, 'minutes': 30},
    {'label': 'one_hour'.tr, 'minutes': 60},
    {'label': 'two_hours'.tr, 'minutes': 120},
  ];

  final List<Map<String, dynamic>> _priorities = [
    {
      'label': 'high_priority'.tr,
      'value': 'HIGH',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEE2E2),
    },
    {
      'label': 'medium_priority'.tr,
      'value': 'MEDIUM',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFEF3C7),
    },
    {
      'label': 'low_priority'.tr,
      'value': 'LOW',
      'color': const Color(0xFF22C55E),
      'bg': const Color(0xFFDCFCE7),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Sync chip with controller
    _selectedChip = controller.selectedDuration.value;

    _customDurationController.addListener(() {
      if (_customDurationController.text.isNotEmpty) {
        setState(() => _selectedChip = -1);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _customDurationController.dispose();
    super.dispose();
  }

  int get _effectiveDurationMinutes {
    if (_selectedChip == -1) {
      return int.tryParse(_customDurationController.text) ?? 60;
    }
    return _durationChips[_selectedChip]['minutes'] as int;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2563EB),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2563EB),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  String _formatDisplayTime() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = _selectedDateTime.hour;
    final m = _selectedDateTime.minute;
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final amPm = h >= 12 ? 'PM' : 'AM';
    return '${_selectedDateTime.day} ${months[_selectedDateTime.month - 1]} · $hour:${m.toString().padLeft(2, '0')} $amPm';
  }

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
              SizedBox(height: 28.h),
              _buildTextField(
                controller: _titleController,
                hintText: 'enter_title'.tr,
              ),
              SizedBox(height: 14.h),
              _buildTimeField(),
              SizedBox(height: 14.h),
              _buildTextField(
                controller: _descController,
                hintText: 'enter_desc'.tr,
                maxLines: 3,
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle('quick_duration'.tr),
              SizedBox(height: 4.h),
              Text(
                'duration_desc'.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 10.h),
              _buildDurationSection(),
              SizedBox(height: 24.h),
              _buildSectionTitle('priority'.tr),
              SizedBox(height: 10.h),
              _buildPriorityChips(),
              SizedBox(height: 40.h),
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
          'add_task_btn'.tr,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFF94A3B8), fontSize: 16.sp),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(fontSize: 16.sp, color: const Color(0xFF0F172A)),
      ),
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFF2563EB),
                size: 16,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                _formatDisplayTime(),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFF94A3B8),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0F172A),
      ),
    );
  }

  Widget _buildDurationSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _selectedChip == -1
                ? const Color(0xFFEEF2FF)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: _selectedChip == -1
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFE2E8F0),
              width: _selectedChip == -1 ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: _selectedChip == -1
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF94A3B8),
                size: 18,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: _customDurationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onTap: () => setState(() => _selectedChip = -1),
                  decoration: InputDecoration(
                    hintText: 'custom_duration_hint'.tr,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                'min'.tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: _selectedChip == -1
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        // Preset chips
        Row(
          children: List.generate(_durationChips.length, (index) {
            final isSelected = _selectedChip == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedChip = index);
                  controller.selectDuration(index);
                  _customDurationController.clear();
                },
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 8.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _durationChips[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        // Custom duration input
      ],
    );
  }
  Widget _buildPriorityChips() {
    return Obx(
          () => Wrap(
        spacing: 8.w,
        runSpacing: 10.h,
        children: _priorities.map((p) {
          final isSelected = controller.selectedPriority.value == p['value'];
          final color = p['color'] as Color;
          final bg = p['bg'] as Color;

          return GestureDetector(
            onTap: () => controller.selectPriority(p['value'] as String),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? bg : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected ? color : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag_rounded, color: isSelected ? color : const Color(0xFFCBD5E1), size: 16),
                  SizedBox(width: 5.w),
                  Text(
                    p['label'] as String,
                    style: TextStyle(fontSize: 13.sp, color: isSelected ? color : const Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  // Widget _buildPriorityChips() {
  //   return Obx(
  //     () => Row(
  //       children: _priorities.asMap().entries.map((entry) {
  //         final p = entry.value;
  //         final isSelected = controller.selectedPriority.value == p['value'];
  //         final color = p['color'] as Color;
  //         final bg = p['bg'] as Color;
  //         final isLast = entry.key == _priorities.length - 1;
  //
  //         return Expanded(
  //           child: GestureDetector(
  //             onTap: () => controller.selectPriority(p['value'] as String),
  //             child: Container(
  //               margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
  //               padding: EdgeInsets.symmetric(vertical: 12.h),
  //               decoration: BoxDecoration(
  //                 color: isSelected ? bg : Colors.white,
  //                 borderRadius: BorderRadius.circular(14.r),
  //                 border: Border.all(
  //                   color: isSelected ? color : const Color(0xFFE2E8F0),
  //                   width: isSelected ? 1.5 : 1,
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.flag_rounded,
  //                     color: isSelected ? color : const Color(0xFFCBD5E1),
  //                     size: 16,
  //                   ),
  //                   SizedBox(width: 5.w),
  //                   Text(
  //                     p['label'] as String,
  //                     style: TextStyle(
  //                       fontSize: 13.sp,
  //                       fontWeight: FontWeight.w600,
  //                       color: isSelected ? color : const Color(0xFF64748B),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTap: () => Get.to(() => const VoiceListeningScreen()),
      child: Container(
        width: double.infinity,
        height: 52.h,
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
              'add_by_voice'.tr,
              style: TextStyle(
                fontSize: 15.sp,
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
    return PrimaryButton(
      text: 'add_task_btn'.tr,
      onPressed: () {
        if (_titleController.text.trim().isEmpty) {
          Get.snackbar(
            'empty_task_error'.tr,
            'task_name_required'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        final duration = _effectiveDurationMinutes;
        if (duration <= 0) {
          Get.snackbar(
            'invalid_duration_error'.tr,
            'enter_valid_duration'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        controller.addTask(
          _titleController.text.trim(),
          _descController.text.trim(),
          dateTime: _selectedDateTime.toUtc().toIso8601String(),
          duration: duration,
          priority: controller.selectedPriority.value,
        );

        Get.back();
      },
    );
  }

  Widget _buildAIFootnote() {
    return Center(
      child: Text(
        'ai_footnote'.tr,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
