class ApiConstants {
  static const String baseUrl = "http://139.59.1.109:5000";

  static const String login = "$baseUrl/api/auth/login";
  static const String registerUser = "$baseUrl/api/user/register";
  static String deviceByUserId(String userId) => "$baseUrl/api/devices/$userId";
  static const String deviceDataByDate = "$baseUrl/api/device/check-deviceList_byDate";
}
