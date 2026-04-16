import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_endpoints.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  var isLoading = true.obs;
  var name = "".obs;
  var email = "".obs;
  var profileImage = "".obs; // network URL from /auth/me

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiEndpoints.me),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['data'] != null) {
          name.value = data['data']['name'] ?? "";
          email.value = data['data']['email'] ?? "";
          profileImage.value = data['data']['profileImage'] ?? "";
        }
      }
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading(false);
    }
  }
}
