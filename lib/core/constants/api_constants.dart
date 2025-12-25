// api/api_endpoints.dart
class ApiConstants {
  static const String baseUrl = "http://139.59.1.109:5000";

  // Authentication
  static const String login = "$baseUrl/api/user/login";
  static const String registerUser = "$baseUrl/api/user/register";
  static const String deviceByUserId = "$baseUrl/api/devices/4";
}
