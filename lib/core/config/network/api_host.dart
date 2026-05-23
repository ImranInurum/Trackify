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
  static const String addVehicle = "$baseURL/api/vehicle/vehicle";
  static String updateVehicleDetails(String imei) =>
      "$baseURL/api/vehicle/update-vehicle/$imei";
  static String updateVehicleControl(String imei) =>
      "$baseURL/api/vehicle-control/update/$imei";
  static String lockUnlockVehicle(String imei) =>
      "$baseURL/api/vehicle-control/lock-unlock/$imei";
  static String getVehicleControl(String imei) =>
      "$baseURL/api/vehicle-control/$imei";
  static String deleteVehicle(String imei) =>
      "$baseURL/api/vehicle-control/delete/$imei";

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
  static String getGeoFenceData(String imei) =>
      "$baseURL/api/geoFance/geofenceData/$imei";
  static String deleteGeoFence(String imei) =>
      "$baseURL/api/geoFance/geofence/$imei";

  // -------------------------
  // Documents / Upload
  // -------------------------
  static const String uploadDocument = "$baseURL/api/documents/document";

  // -------------------------
  // Service Logs
  // -------------------------
  static const String serviceLogs = "$baseURL/api/service/service-logs";
  static const String addServiceLogs = "$baseURL/api/service/service-logs";

  // -------------------------
  // Overspeed Alert
  // -------------------------
  static const String createOverspeedAlert =
      "$baseURL/api/overspeed/create-alert";
  static String getOverspeedAlerts(String imei) =>
      "$baseURL/api/overspeed/get-overspeed/$imei";

  // -------------------------
  // Add Fuel
  // -------------------------
  static const String addFuel = "$baseURL/api/vehicle-refuel/create";
  static String dashboard(String imei) =>
      "$baseURL/api/vehicle-refuel/fuel-log-details/$imei";
  static String refuel(String imei) => "$baseURL/api/vehicle-refuel/$imei";

  // -------------------------
  // Recharge Plans
  // -------------------------
  static const String getRechargePlans =
      "$baseURL/api/data-plans/recharge-plans";
  static String getCurrentDataPlan(String imei) =>
      "$baseURL/api/data-plans/current-data-plan/$imei";
  static const String purchaseDataPlan =
      "$baseURL/api/data-plans/vehicle-data-plan";

  // -------------------------
  // Warranty
  // -------------------------
  static String getDeviceWarranty(String imei) =>
      "$baseURL/api/warranty/device-warranty/$imei";

  static String getWarrantyPaymentSummary(String imei, String planId) =>
      "$baseURL/api/warranty/warranty-payment-summary/$imei/$planId";

  static const String extendWarranty = "$baseURL/api/warranty/extend-warranty";

  // -------------------------
  // Health Insurance
  // -------------------------
  static const String healthInsuranceOptions =
      "$baseURL/api/health-insurance/health-insurance-options";
  static const String saveHealthInsurance =
      "$baseURL/api/health-insurance/health-insurance";

  // -------------------------
  // Video Tutorial
  // -------------------------
  static const String tutorial = "$baseURL/api/api/video-tutorials-list";
  static const String category = "$baseURL/api/video-tutorials-category";

  // -------------------------
  // App Update
  // -------------------------
  static const String appUpdate = "$baseURL/api/app-update/app-updates";

// -------------------------
// Discover feature
// -------------------------
static const String discover = "$baseURL/api/features/discover-features";
  static const String featureDetails = "$baseURL/api/features/feature-category";
  static const String geoFenceIntro = "$baseURL/api/features/feature-intro/{featureId}";

// -------------------------
//Plus Membership
// -------------------------
  static const String plusMembership = "$baseURL/api/plus-membership/plus-plan";




  // NEED TO IMPLEMENT CORRECT API
  // static const String logout = '$baseURL/users/logout';
  // static const String userDetails = '$baseURL/users/get-details';
  // static const String updateUserDetails = '$baseURL/users/update-user-details';

  static String updateProfile(String userId) =>
      "$baseURL/api/auth/user-detail/$userId";

  // -------------------------
  // Statistics
  // -------------------------
  static String statistics(String imei, {String? date}) {
    if (date != null && date.isNotEmpty) {
      return "$baseURL/api/statistics/$imei?date=$date";
    }
    return "$baseURL/api/statistics/$imei";
  }
}
