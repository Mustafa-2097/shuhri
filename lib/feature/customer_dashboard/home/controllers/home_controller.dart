import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../tasks/controllers/task_controller.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var todayTasksNumber = 0.obs;
  var remainingTaskNumber = 0.obs;
  var focusTime = 0.obs;
  var progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayOverview();
  }

  Future<void> fetchTodayOverview() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      
      final response = await http.get(
        Uri.parse(ApiEndpoints.todayOverview),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          todayTasksNumber.value = data['data']['todayTasksNumber'] ?? 0;
          remainingTaskNumber.value = data['data']['remainingTaskNumber'] ?? 0;
          focusTime.value = data['data']['focusTime'] ?? 0; 
          progress.value = (data['data']['progress'] ?? 0).toDouble();
        }
      }
    } catch (e) {
      print('Error fetching overview: $e');
    }
  }

  Future<void> reoptimizeMyDay() async {
     try {
       EasyLoading.show(status: 'Re-optimizing schedule...');
       final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('accessToken');

       final response = await http.get(
         Uri.parse(ApiEndpoints.reoptimizeTasks),
         headers: {
           'Content-Type': 'application/json',
           'Authorization': 'Bearer $token',
         },
       );

       if (response.statusCode == 200 || response.statusCode == 201) {
         EasyLoading.showSuccess('Day re-optimized successfully');
         fetchTodayOverview();
         // Attempt to update tasks on UI
         if (Get.isRegistered<TaskController>()) {
             Get.find<TaskController>().fetchTasks();
         }
       } else {
         final data = jsonDecode(response.body);
         EasyLoading.showError(data['message'] ?? 'Optimization failed');
       }
     } catch (e) {
       EasyLoading.showError('An error occurred');
     }
  }
}
