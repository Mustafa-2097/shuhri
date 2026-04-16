import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  var isLoading = true.obs;
  var isSaving = false.obs;

  var smartRemindersEnabled = false.obs;
  var dailySummaryEnabled = false.obs;
  var autoOptimizationEnabled = false.obs;
  var notificationsEnabled = true.obs;
  var emailNotificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    getSettings();
  }

  Future<void> getSettings() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiEndpoints.settings),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['data'] != null) {
          final s = data['data'];
          smartRemindersEnabled.value = s['smartRemindersEnabled'] ?? false;
          dailySummaryEnabled.value = s['dailySummaryEnabled'] ?? false;
          autoOptimizationEnabled.value = s['autoOptimizationEnabled'] ?? false;
          notificationsEnabled.value = s['notificationsEnabled'] ?? true;
          emailNotificationsEnabled.value = s['emailNotificationsEnabled'] ?? true;
        }
      }
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateSettings() async {
    try {
      isSaving(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.patch(
        Uri.parse(ApiEndpoints.settings),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "smartRemindersEnabled": smartRemindersEnabled.value,
          "dailySummaryEnabled": dailySummaryEnabled.value,
          "autoOptimizationEnabled": autoOptimizationEnabled.value,
          "notificationsEnabled": notificationsEnabled.value,
          "emailNotificationsEnabled": emailNotificationsEnabled.value,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success silently or show toast? Unobtrusive is better.
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("Error", data['message'] ?? "Failed to update settings");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred");
    } finally {
      isSaving(false);
    }
  }

  void toggleSmartReminders(bool value) {
    smartRemindersEnabled.value = value;
    updateSettings();
  }

  void toggleDailySummary(bool value) {
    dailySummaryEnabled.value = value;
    updateSettings();
  }

  void toggleAutoOptimization(bool value) {
    autoOptimizationEnabled.value = value;
    updateSettings();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    updateSettings();
  }

  void toggleEmailNotifications(bool value) {
    emailNotificationsEnabled.value = value;
    updateSettings();
  }
}
