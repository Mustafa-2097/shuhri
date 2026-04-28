import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/network/api_endpoints.dart';
import 'package:intl/intl.dart';

class TaskModel {
  String id;
  String title;
  String description;
  String dateTime;
  int duration;
  String priority;
  String status;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.dateTime,
    required this.duration,
    required this.priority,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: json['dateTime'] ?? '',
      duration: json['duration'] ?? 0,
      priority: json['priority'] ?? 'MEDIUM',
      status: json['status'] ?? 'PENDING',
    );
  }

  bool get isCompleted => status == 'COMPLETED';

  String get time {
    try {
      final dt = DateTime.parse(dateTime).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final amPm = dt.hour >= 12 ? 'PM' : 'AM';
      return "$hour:${dt.minute.toString().padLeft(2, '0')} $amPm";
    } catch (e) {
      return "12:00 PM";
    }
  }

  String get formattedDate {
    try {
      final dt = DateTime.parse(dateTime).toLocal();
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
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (e) {
      return '--';
    }
  }

  bool get isPriority => priority == 'HIGH';
}

class TaskController extends GetxController {
  // Task state
  var tasks = <TaskModel>[].obs;

  // Form state
  var selectedDuration = 1.obs; // 0: 30m, 1: 1h, 2: 2h
  var selectedPriority = 'MEDIUM'.obs; // HIGH | MEDIUM | LOW
  var isHighPriority = false.obs; // kept for legacy voice_ui usage
  var isToday = false.obs;

  // Speech state
  final stt.SpeechToText _speech = stt.SpeechToText();
  var isListening = false.obs;
  var recognizedText = "".obs;
  var speechEnabled = false.obs;
  var lastError = "".obs;
  var supportedLocales = <stt.LocaleName>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse(
          '${ApiEndpoints.tasks}?page=1&limit=50&sortBy=dateTime&sortOrder=asc',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final rawData = body['data'];

        List tasksList = [];
        if (rawData is List) {
          // Direct array: { "data": [ {...}, {...} ] }
          tasksList = rawData;
        } else if (rawData is Map && rawData['tasks'] != null) {
          // Nested: { "data": { "tasks": [ {...} ] } }
          tasksList = rawData['tasks'] as List;
        }

        tasks.value = tasksList.map((t) => TaskModel.fromJson(t)).toList();
        print('Fetched ${tasks.length} tasks');
      } else {
        print('fetchTasks error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<TaskModel?> fetchTaskById(String taskId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse('${ApiEndpoints.tasks}/$taskId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return TaskModel.fromJson(data['data']);
        }
      }
    } catch (e) {
      print('Error fetching task by id: $e');
    }
    return null;
  }

  Future<void> fetchStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.get(
        Uri.parse(ApiEndpoints.taskStats),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      if (response.statusCode == 200) {
        // print(response.body);
      }
    } catch (e) {
      print('Error fetching task stats: $e');
    }
  }

  bool _isInitializing = false;

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    if (status.isPermanentlyDenied) {
      lastError.value =
          "Microphone permission is permanently denied. Please enable it in settings.";
    }
  }

  Future<void> _initSpeech() async {
    if (_isInitializing) return;
    _isInitializing = true;
    lastError.value = "";

    try {
      await _requestPermission();

      speechEnabled.value = await _speech.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
        onError: (error) {
          print('Speech error: ${error.errorMsg}');
          lastError.value = error.errorMsg;
          isListening.value = false;
        },
      );
      if (speechEnabled.value) {
        supportedLocales.value = await _speech.locales();
        print(
          'Supported speech locales: ${supportedLocales.map((l) => l.localeId).toList()}',
        );
      }

      if (!speechEnabled.value) {
        lastError.value = "Speech recognition not available on this device.";
      }
    } catch (e) {
      print('Speech init error: $e');
      lastError.value = e.toString();
      speechEnabled.value = false;
    } finally {
      _isInitializing = false;
    }
  }

  String _getBestLocale() {
    if (Get.locale == null) return "en-US";

    String currentLang = Get.locale!.languageCode; // e.g. 'es', 'ar'
    String currentFull = Get.locale!.toString().replaceAll(
      '_',
      '-',
    ); // e.g. 'es-ES'

    // 1. Try exact match (e.g. 'es-ES')
    for (var loc in supportedLocales) {
      if (loc.localeId.toLowerCase() == currentFull.toLowerCase()) {
        return loc.localeId;
      }
    }

    // 2. Try language only match (e.g. 'es')
    for (var loc in supportedLocales) {
      if (loc.localeId.split('-')[0].toLowerCase() ==
          currentLang.toLowerCase()) {
        return loc.localeId;
      }
    }

    return currentFull; // Fallback to current app locale string
  }

  void startListening() async {
    lastError.value = "";

    if (!speechEnabled.value) {
      await _initSpeech();
    }

    if (speechEnabled.value) {
      recognizedText.value = "";
      isListening.value = true;
      try {
        String localeId = _getBestLocale();
        print('Starting voice recognition with best locale: $localeId');

        await _speech.listen(
          onResult: (result) {
            recognizedText.value = result.recognizedWords;
            if (result.finalResult) {
              isListening.value = false;
            }
          },
          localeId: localeId,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          partialResults: true,
          listenMode: stt.ListenMode.confirmation,
          listenOptions: stt.SpeechListenOptions(cancelOnError: true),
        );
      } catch (e) {
        print('Speech listen error: $e');
        lastError.value = e.toString();
        isListening.value = false;
      }
    } else {
      print('Speech not enabled: ${lastError.value}');
    }
  }

  void stopListening() async {
    await _speech.stop();
    isListening.value = false;
  }

  void selectDuration(int index) {
    selectedDuration.value = index;
  }

  void selectPriority(String priority) {
    selectedPriority.value = priority;
    isHighPriority.value = priority == 'HIGH';
  }

  void togglePriority() {
    isHighPriority.toggle();
  }

  void toggleToday() {
    isToday.toggle();
  }

  void addTask(
    String title,
    String description, {
    String? dateTime,
    int? duration,
    String? priority,
  }) async {
    try {
      EasyLoading.show(status: 'Creating task...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final int durMin =
          duration ??
          (selectedDuration.value == 0
              ? 30
              : selectedDuration.value == 1
              ? 60
              : 120);
      final String prio = priority ?? selectedPriority.value;
      final String dt =
          dateTime ??
          DateTime.now()
              .add(const Duration(hours: 1))
              .toUtc()
              .toIso8601String();

      final response = await http.post(
        Uri.parse(ApiEndpoints.tasks),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "dateTime": dt,
          "duration": durMin,
          "priority": prio,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Task Created');
        fetchTasks();
        fetchStats();
      } else {
        final data = jsonDecode(response.body);
        EasyLoading.showError(data['message'] ?? 'Failed to create task');
      }
    } catch (e) {
      EasyLoading.showError('Error creating task');
    }
  }

  Future<void> updateTask({
    required String id,
    required String title,
    required String description,
    required String dateTime,
    required int duration,
    required String priority,
    required String status,
  }) async {
    try {
      EasyLoading.show(status: 'Updating task...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.put(
        Uri.parse('${ApiEndpoints.tasks}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "dateTime": dateTime,
          "duration": duration,
          "priority": priority,
          "status": status,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Task updated');
        fetchTasks();
      } else {
        final data = jsonDecode(response.body);
        EasyLoading.showError(data['message'] ?? 'Failed to update task');
      }
    } catch (e) {
      EasyLoading.showError('Error updating task');
    }
  }

  Future<void> deleteTaskById(String id) async {
    try {
      EasyLoading.show(status: 'Deleting task...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.delete(
        Uri.parse('${ApiEndpoints.tasks}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        EasyLoading.showSuccess('Task deleted');
        fetchTasks();
      } else {
        final data = jsonDecode(response.body);
        EasyLoading.showError(data['message'] ?? 'Failed to delete task');
      }
    } catch (e) {
      EasyLoading.showError('Error deleting task');
    }
  }

  Future<void> updateTaskStatus(String id, String status) async {
    try {
      EasyLoading.show(status: 'Updating status...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await http.patch(
        Uri.parse('${ApiEndpoints.tasks}/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Status updated');
        fetchTasks();
      } else {
        final data = jsonDecode(response.body);
        EasyLoading.showError(data['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      EasyLoading.showError('Error updating status');
    }
  }

  void toggleTaskCompletion(int index) {
    if (index >= 0 && index < tasks.length) {
      final task = tasks[index];
      final newStatus = task.isCompleted ? 'PENDING' : 'COMPLETED';
      updateTaskStatus(task.id, newStatus);
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      deleteTaskById(tasks[index].id);
    }
  }
}
