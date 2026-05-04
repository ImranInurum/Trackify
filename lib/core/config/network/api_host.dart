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
  static const String socketURL = 'ws://139.59.1.109:4000';

  static String authToken = '';
  static void updateAuthToken(String token) {
    authToken = token;
  }

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
  static const String saveFcmToken = "$baseURL/user/save-fcm-token";

  // -------------------------
  // Vehicle
  // -------------------------
  static const String addVehicle = "$baseURL/api/vehicle/vehicle";

  static String getVehiclesByUserId(String userId) =>
      "$baseURL/api/vehicle/get-vehicles?userId=$userId";

  static const String vehicleConfig = "$baseURL/api/vehicle/vehicle-config";

  static String vehicleMakers(String vehicleType, String fuelType) =>
      "$baseURL/api/vehicle/makers?vehicleType=$vehicleType&fuelType=$fuelType";

  static String vehicleModels(
    String vehicleType,
    String fuelType,
    String brandId,
  ) =>
      "$baseURL/api/vehicle/models?vehicleType=$vehicleType&fuelType=$fuelType&brandId=$brandId";

  // -------------------------
  // Device
  // -------------------------
  static String deviceByUserId(String userId) => "$baseURL/api/devices/$userId";
  static const String deviceDataByDate =
      "$baseURL/api/device/check-deviceList_byDate";
  static const String assignDevices = "$baseURL/api/assign-devices";

  static const String journeyRideHistory = "$baseURL/api/journey/ride-history";
  static const String promoVideos = "$baseURL/api/promo/all";

  // -------------------------
  // LogoURL
  // -------------------------
  static const String logoUrl = "$baseURL/api/logoUrl";
  static const String theme = "$baseURL/api/theme";

  // -------------------------
  // Notification
  // -------------------------
  static String notifications(String userId) =>
      "$baseURL/api/notification/$userId";

  // -------------------------
  // Geo-Fence
  // -------------------------
  static const String updateGeoFence = "$baseURL/api/geoFance/update_geofence";
  static String getGeoFenceData(String imei) => "$baseURL/api/geoFance/geofenceData/$imei";
  static String deleteGeoFence(String imei) => "$baseURL/api/geoFance/geofence/$imei";

  // -------------------------
  // Service Logs
  // -------------------------
  static const String serviceLogs = "$baseURL/api/service/service-logs";
  static const String addServiceLogs = "$baseURL/api/service/service-logs";

  // -------------------------
  // Overspeed Alert
  // -------------------------
  static const String createOverspeedAlert = "$baseURL/api/overspeed/create-alert";
  static String getOverspeedAlerts(String imei) => "$baseURL/api/overspeed/get-overspeed/$imei";

  // NEED TO IMPLEMENT CORRECT API
  // static const String logout = '$baseURL/users/logout';
  // static const String userDetails = '$baseURL/users/get-details';
  // static const String updateUserDetails = '$baseURL/users/update-user-details';
}
