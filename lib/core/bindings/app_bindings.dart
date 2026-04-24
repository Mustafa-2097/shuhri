import 'package:get/get.dart';
import '../../feature/auth/login/controllers/login_page_controller.dart';
import '../../feature/auth/forgot_password/controllers/forgot_password_controller.dart';
import '../../feature/auth/forgot_password/controllers/reset_password_controller.dart';
import '../../feature/auth/forgot_password/controllers/reset_otp_controller.dart';
import '../../feature/auth/registration/controllers/registration_page_controller.dart';
import '../../feature/auth/registration/controllers/registration_otp_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginPageController(), fenix: true);
    Get.lazyPut(() => ForgotPasswordController(), fenix: true);
    Get.lazyPut(() => ResetPasswordController(), fenix: true);
    Get.lazyPut(() => ResetOtpController(), fenix: true);
    Get.lazyPut(() => RegistrationPageController(), fenix: true);
    Get.lazyPut(() => RegistrationOtpController(), fenix: true);
  }
}
