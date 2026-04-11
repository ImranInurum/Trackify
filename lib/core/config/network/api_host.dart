class ApiURL {
  final String hostUrl;

  const ApiURL._(this.hostUrl);

  factory ApiURL.devENV() {
    return const ApiURL._('http://139.59.1.109:5000');
  }

  factory ApiURL.prodENV() {
    return const ApiURL._('http://139.59.1.109:5000');
  }

  static const String baseURL = 'http://139.59.1.109:5000';

  static String authToken = '';

  // -------------------------
  // Social Login
  // -------------------------
  static const String socialLogin = "$baseURL/api/auth/social-login";

  // -------------------------
  // Auth / Users
  // -------------------------
  static const String login = "$baseURL/api/auth/login";
  static const String registerUser = "$baseURL/api/auth/register";
  static const String verifyOtp = "$baseURL/api/auth/verify-otp";
  static const String resetPassword = "$baseURL/api/auth/reset-password";
  static const String sendOtp = "$baseURL/api/auth/send-otp";

  // -------------------------
  // Vehicle
  // -------------------------
  static const String addVehicle = "$baseURL/api/vehicle/add-vehicle";
  static String getVehiclesByUserId(String userId) =>
      "$baseURL/api/vehicle/get-vehicles?userId=$userId";

  // -------------------------
  // Device
  // -------------------------
  static String deviceByUserId(String userId) => "$baseURL/api/devices/$userId";
  static const String deviceDataByDate = "$baseURL/api/device/check-deviceList_byDate";

  // -------------------------
  // LogoURL
  // -------------------------
  static const String logoUrl = "$baseURL/api/logoUrl";

  // NEED TO IMPLEMENT CORRECT API
  // static const String logout = '$baseURL/users/logout';
  // static const String userDetails = '$baseURL/users/get-details';
  // static const String updateUserDetails = '$baseURL/users/update-user-details';
}
