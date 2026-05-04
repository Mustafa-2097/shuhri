class ApiEndpoints {
  //static const String baseUrl = 'https://05e2-137-59-180-177.ngrok-free.app/api/v1';
  //static const String baseUrl = 'https://0e1b-137-59-180-177.ngrok-free.app/api/v1';
  //static const String baseUrl = 'https://1bb7-137-59-180-177.ngrok-free.app/api/v1';
  static const String baseUrl = 'http://206.162.244.189:8007/api/v1'; //http://206.162.244.189:8007/
  //https://e89b-182-252-90-97.ngrok-free.app/
  //https://cf8b-182-252-90-97.ngrok-free.app/
  //https://1bb7-137-59-180-177.ngrok-free.app/



  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String verifyEmail = '$baseUrl/auth/verify-email';

  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String logout = '$baseUrl/auth/logout';
  static const String me = '$baseUrl/auth/me';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String updateProfile = '$baseUrl/auth/update-profile';

  /// Tasks
  static const String tasks = '$baseUrl/tasks';
  static const String taskStats = '$baseUrl/tasks/stats';
  static const String todayOverview = '$baseUrl/tasks/today-overview';
  static const String reoptimizeTasks = '$baseUrl/tasks/reoptimize-my-day';

  /// Settings
  static const String settings = '$baseUrl/settings';

  /// Notifications
  static const String notifications = '$baseUrl/notifications';
  static const String notificationsStream = '$baseUrl/notifications/stream';
  static const String markAllNotificationsRead = '$baseUrl/notifications/read-all';
  static String markNotificationRead(String id) => '$baseUrl/notifications/$id/read';
  static String deleteNotification(String id) => '$baseUrl/notifications/$id';
}
