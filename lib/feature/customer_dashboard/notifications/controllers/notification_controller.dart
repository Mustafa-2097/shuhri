import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';
import 'dart:async';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  var isLoading = true.obs;
  var notificationsList = [].obs;
  var selectedFilter = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
    connectToSse();
  }

  List get filteredNotifications {
    if (selectedFilter.value == 0) {
      return notificationsList;
    } else {
      return notificationsList.where((n) => n['isRead'] == false).toList();
    }
  }

  int get unreadCount {
    return notificationsList.where((n) => n['isRead'] == false).length;
  }

  Future<void> getNotifications() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiEndpoints.notifications),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['data'] != null) {
          notificationsList.value = data['data'];
        }
      }
    } catch (e) {
      // Error
    } finally {
      isLoading(false);
    }
  }

  void connectToSse() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      // Basic simple polling or standard http stream for SSE
      final client = http.Client();
      final request = http.Request('GET', Uri.parse('${ApiEndpoints.notificationsStream}?accessToken=$token'));
      request.headers['ngrok-skip-browser-warning'] = 'true';

      final response = await client.send(request);

      response.stream.transform(utf8.decoder).listen((data) {
        // Here we parse SSE formatted data
        // Format is typically `data: {"some":"json"}\n\n`
        if (data.contains('data:')) {
          final lines = data.split('\n');
          for (var line in lines) {
            if (line.startsWith('data: ')) {
              final jsonStr = line.substring(6).trim();
              if (jsonStr.isNotEmpty) {
                try {
                  final eventData = jsonDecode(jsonStr);
                  // We can either prepend to list or refresh
                  notificationsList.insert(0, eventData);
                } catch(e) {
                  // handle decode err
                }
              }
            }
          }
        }
      });
    } catch (e) {
      print("SSE Error: $e");
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.patch(
        Uri.parse(ApiEndpoints.markNotificationRead(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Find and update local list
        final index = notificationsList.indexWhere((n) => n['_id'] == id || n['id'] == id);
        if (index != -1) {
          var item = Map<String, dynamic>.from(notificationsList[index]);
          item['isRead'] = true;
          notificationsList[index] = item;
        }
      }
    } catch (e) {
      // Error handling
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.patch(
        Uri.parse(ApiEndpoints.markAllNotificationsRead),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local list
        for (int i = 0; i < notificationsList.length; i++) {
          var item = Map<String, dynamic>.from(notificationsList[i]);
          item['isRead'] = true;
          notificationsList[i] = item;
        }
      }
    } catch (e) {
      // Error handling
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.delete(
        Uri.parse(ApiEndpoints.deleteNotification(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notificationsList.removeWhere((n) => n['_id'] == id || n['id'] == id);
      }
    } catch (e) {
      // Error handling
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.delete(
        Uri.parse(ApiEndpoints.notifications),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notificationsList.clear();
      }
    } catch (e) {
      // Error handling
    }
  }
}
