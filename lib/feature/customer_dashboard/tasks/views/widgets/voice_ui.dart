import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shuhri/feature/customer_dashboard/ai/views/task_ai_parser.dart';
import 'package:shuhri/feature/customer_dashboard/tasks/controllers/task_controller.dart';

class VoiceListeningScreen extends StatefulWidget {
  const VoiceListeningScreen({super.key});

  @override
  State<VoiceListeningScreen> createState() => _VoiceListeningScreenState();
}

class _VoiceListeningScreenState extends State<VoiceListeningScreen> {
  final controller = Get.find<TaskController>();
  Worker? _listeningWorker;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Reset previous recognized text and start fresh
    controller.recognizedText.value = '';
    controller.lastError.value = '';
    controller.startListening();

    // Auto-navigate to Result screen when listening finishes with text
    _listeningWorker = ever(controller.isListening, (bool listening) {
      if (!listening &&
          controller.recognizedText.value.trim().isNotEmpty &&
          !_navigated) {
        _navigated = true;
        Get.to(() => const VoiceResultScreen());
      }
    });
  }

  @override
  void dispose() {
    _listeningWorker?.dispose();
    controller.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Close Button
            Positioned(
              top: 20.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: const Color(0xFF64748B),
                    size: 24.sp,
                  ),
                ),
              ),
            ),
            // Central Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulse Animation
                  Obx(() => _buildMicAnimation(controller.isListening.value)),
                  SizedBox(height: 48.h),
                  Obx(
                    () => Text(
                      controller.lastError.value.isNotEmpty
                          ? 'Oops!'
                          : (controller.isListening.value
                                ? 'Listening...'
                                : (controller.recognizedText.isEmpty
                                      ? 'Preparing...'
                                      : 'Finished')),
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        controller.lastError.value.isNotEmpty
                            ? controller.lastError.value
                            : (controller.isListening.value
                                  ? 'Speak naturally about your task'
                                  : (controller.recognizedText.isEmpty
                                        ? 'Getting ready to hear you...'
                                        : controller.recognizedText.value)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: controller.lastError.value.isNotEmpty
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Text
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(
                  () => Column(
                    children: [
                      if (!controller.isListening.value)
                        Column(
                          children: [
                            if (controller.recognizedText.isEmpty ||
                                controller.lastError.value.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  controller.lastError.value = "";
                                  controller.startListening();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2563EB),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Text(
                                    'Try Again',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () =>
                                    Get.to(() => const VoiceResultScreen()),
                                child: Text(
                                  'Tap to see result',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      Text(
                        'Tap X to cancel',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicAnimation(bool isListening) {
    bool hasError = controller.lastError.value.isNotEmpty;

    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasError
            ? const Color(0xFFEF4444).withOpacity(0.1)
            : const Color(0xFF2563EB).withOpacity(0.1),
      ),
      child: Center(
        child: Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasError
                ? const Color(0xFFEF4444).withOpacity(0.2)
                : const Color(0xFF2563EB).withOpacity(0.2),
          ),
          child: Center(
            child: Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF2563EB),
              ),
              child: Icon(
                hasError
                    ? Icons.priority_high_rounded
                    : (isListening
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_rounded),
                color: Colors.white,
                size: 36.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceResultScreen extends StatefulWidget {
  const VoiceResultScreen({super.key});

  @override
  State<VoiceResultScreen> createState() => _VoiceResultScreenState();
}

class _VoiceResultScreenState extends State<VoiceResultScreen> {
  final controller = Get.find<TaskController>();
  late TextEditingController _textController;
  late TextEditingController _descController;

  String _selectedPriority = 'MEDIUM';
  int _selectedDurationChip = 1; // 0=30m, 1=1h, 2=2h, -1=custom
  final TextEditingController _customDurationController =
      TextEditingController();
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));

  final List<Map<String, dynamic>> _priorities = [
    {
      'label': 'High',
      'value': 'HIGH',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEE2E2),
    },
    {
      'label': 'Medium',
      'value': 'MEDIUM',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFEF3C7),
    },
    {
      'label': 'Low',
      'value': 'LOW',
      'color': const Color(0xFF22C55E),
      'bg': const Color(0xFFDCFCE7),
    },
  ];

  final List<Map<String, dynamic>> _durationChips = [
    {'label': '30 min', 'minutes': 30},
    {'label': '1 hour', 'minutes': 60},
    {'label': '2 hours', 'minutes': 120},
  ];

  int get _effectiveDurationMinutes {
    if (_selectedDurationChip == -1) {
      return int.tryParse(_customDurationController.text) ?? 60;
    }
    return _durationChips[_selectedDurationChip]['minutes'] as int;
  }

  @override
  void initState() {
    super.initState();

    ////////////////////////////////////////////////////////////////////
    // _textController = TextEditingController(
    //   text: controller.recognizedText.value,
    // );
    ////////////////////////////////////////////////////////////////////
    final parsed = TaskAIParser.parse(controller.recognizedText.value);

    _textController = TextEditingController(text: parsed.title);

    _selectedDateTime = parsed.dateTime;
    _selectedPriority = parsed.priority;

    if (parsed.duration == 30) {
      _selectedDurationChip = 0;
    } else if (parsed.duration == 60) {
      _selectedDurationChip = 1;
    } else if (parsed.duration == 120) {
      _selectedDurationChip = 2;
    } else {
      _selectedDurationChip = -1;
      _customDurationController.text = parsed.duration.toString();
    }

    _descController = TextEditingController();
    _customDurationController.addListener(() {
      if (_customDurationController.text.isNotEmpty) {
        setState(() => _selectedDurationChip = -1);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _descController.dispose();
    _customDurationController.dispose();
    super.dispose();
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
    const months = [
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: const Color(0xFF0F172A),
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voice Prompt Overview',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Review, edit and confirm your task',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic_rounded,
                          color: const Color(0xFF22C55E),
                          size: 13.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'AI Transcribed',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recognized text (editable)
                    _sectionLabel('Task Title', Icons.edit_rounded),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFF2563EB),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Task title...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 16.sp,
                          ),
                          suffixIcon: Icon(
                            Icons.edit_rounded,
                            color: const Color(0xFF2563EB),
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),
                    _sectionLabel(
                      'Description (optional)',
                      Icons.notes_rounded,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: TextField(
                        controller: _descController,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Add more details...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),
                    _sectionLabel('Date & Time', Icons.calendar_today_rounded),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: _pickDateTime,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 15.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: const Color(0xFF2563EB),
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                _formatDisplayTime(),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0F172A),
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
                    ),

                    SizedBox(height: 18.h),
                    _sectionLabel('Duration', Icons.timer_outlined),
                    SizedBox(height: 8.h),
                    // Custom input
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedDurationChip == -1
                            ? const Color(0xFFEEF2FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: _selectedDurationChip == -1
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE2E8F0),
                          width: _selectedDurationChip == -1 ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: _selectedDurationChip == -1
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF94A3B8),
                            size: 18,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextField(
                              controller: _customDurationController,
                              keyboardType: TextInputType.number,
                              onTap: () =>
                                  setState(() => _selectedDurationChip = -1),
                              decoration: InputDecoration(
                                hintText: 'Custom minutes...',
                                hintStyle: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF94A3B8),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF0F172A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            'min',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: _selectedDurationChip == -1
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Preset chips
                    Row(
                      children: List.generate(_durationChips.length, (index) {
                        final isSelected = _selectedDurationChip == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDurationChip = index;
                                _customDurationController.clear();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: index < 2 ? 8.w : 0,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 11.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFEEF2FF)
                                    : Colors.white,
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

                    SizedBox(height: 18.h),
                    _sectionLabel('Priority', Icons.flag_rounded),
                    SizedBox(height: 8.h),
                    Row(
                      children: _priorities.asMap().entries.map((entry) {
                        final p = entry.value;
                        final isSelected = _selectedPriority == p['value'];
                        final color = p['color'] as Color;
                        final bg = p['bg'] as Color;
                        final isLast = entry.key == _priorities.length - 1;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                              () => _selectedPriority = p['value'] as String,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected ? bg : Colors.white,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isSelected
                                      ? color
                                      : const Color(0xFFE2E8F0),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    color: isSelected
                                        ? color
                                        : const Color(0xFFCBD5E1),
                                    size: 15,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    p['label'] as String,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? color
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 36.h),

                    // ── Action Buttons ───────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            label: 'Retry',
                            onTap: () {
                              controller.recognizedText.value = '';
                              Get.back();
                              controller.startListening();
                            },
                            isOutline: true,
                            icon: Icons.refresh_rounded,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          flex: 2,
                          child: _buildActionButton(
                            label: 'Confirm & Add',
                            onTap: () {
                              final title = _textController.text.trim();
                              if (title.isEmpty) {
                                Get.snackbar(
                                  'Empty Task',
                                  'Please enter a task title',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              controller.addTask(
                                title,
                                _descController.text.trim().isEmpty
                                    ? 'Task created via AI voice'
                                    : _descController.text.trim(),
                                dateTime: _selectedDateTime
                                    .toUtc()
                                    .toIso8601String(),
                                duration: _effectiveDurationMinutes,
                                priority: _selectedPriority,
                              );
                              Get.until((route) => route.isFirst);
                            },
                            isOutline: false,
                            icon: Icons.check_circle_rounded,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15.sp, color: const Color(0xFF64748B)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    bool isOutline = false,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: isOutline ? Colors.white : const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(16.r),
          border: isOutline ? Border.all(color: const Color(0xFFE2E8F0)) : null,
          boxShadow: isOutline
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isOutline ? const Color(0xFF64748B) : Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: isOutline ? const Color(0xFF475569) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
