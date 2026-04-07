class ApiConstants {
  static const String baseUrl = "http://139.59.1.109:5000";

  //auth
  static const String login = "$baseUrl/api/auth/login";
  static const String registerUser = "$baseUrl/api/auth/register";
  static const String sendOtp = "$baseUrl/api/auth/send-otp";
  static const String verifyOtp = "$baseUrl/api/auth/verify-otp";
  static const String resetPassword = "$baseUrl/api/auth/reset-password";

  //get device by user id
  static String deviceByUserId(String userId) => "$baseUrl/api/devices/$userId";

  static const String deviceDataByDate = "$baseUrl/api/device/check-deviceList_byDate";

  static const String logoUrl = "$baseUrl/api/logoUrl";
  static const String socialLogin = "$baseUrl/api/auth/social-login";
}
