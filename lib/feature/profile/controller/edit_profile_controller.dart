import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shuhri/core/network/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController(); // Just for display
  
  var selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ProfileController>()) {
      final profile = ProfileController.instance;
      nameController.text = profile.name.value;
      emailController.text = profile.email.value;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      EasyLoading.showError('Name is required');
      return;
    }

    try {
      EasyLoading.show(status: 'Updating Profile...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      var request = http.MultipartRequest('PUT', Uri.parse(ApiEndpoints.updateProfile));
      request.headers['Authorization'] = 'Bearer $token';

      final dataObj = {
        "name": nameController.text.trim(),
        "isAcceptedTerms": true
      };
      
      request.fields['data'] = jsonEncode(dataObj);

      if (selectedImage.value != null) {
        final imagePath = selectedImage.value!.path;
        final ext = p.extension(imagePath).toLowerCase().replaceAll('.', '');
        final mimeType = ext == 'jpg' || ext == 'jpeg'
            ? 'jpeg'
            : ext == 'png'
                ? 'png'
                : ext == 'gif'
                    ? 'gif'
                    : ext == 'webp'
                        ? 'webp'
                        : 'jpeg';
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          imagePath,
          contentType: MediaType('image', mimeType),
        ));
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseData.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Profile updated successfully');
        
        if (Get.isRegistered<ProfileController>()) {
          ProfileController.instance.getProfile();
        }

        Get.back();
      } else {
        EasyLoading.showError(jsonResponse['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
