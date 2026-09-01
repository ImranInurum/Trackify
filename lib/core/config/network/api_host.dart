class ApiURL {
  final String hostUrl;

  const ApiURL._(this.hostUrl);

  factory ApiURL.devENV() {
    return const ApiURL._('https://trackifybackend.inurum.com');
  }

  factory ApiURL.prodENV() {
    return const ApiURL._('https://trackifybackend.inurum.com');
  }

  static const String baseURL = 'https://trackifybackend.inurum.com';
  static const String socketURL = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'wss://trackifybackend.inurum.com:4000',
  );

  // Razorpay
  static const String razorpayKey = String.fromEnvironment(
    'RAZORPAY_KEY',
    defaultValue: 'rzp_live_TWnjz52KBoRTQj',
  );

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
  static const String changePassword = "$baseURL/api/auth/change-password";

  // -------------------------
  // Vehicle
  static const String addVehicle = "$baseURL/api/vehicle/vehicle";
  static String updateVehicleDetails(String vehicleId) =>
      "$baseURL/api/vehicle/update-vehicle/$vehicleId";
  static String updateVehicleControl(String imei) =>
      "$baseURL/api/vehicle-control/update/$imei";
  static String lockUnlockVehicle(String imei) =>
      "$baseURL/api/vehicle-control/lock-unlock/$imei";
  static String getVehicleControl(String imei) =>
      "$baseURL/api/vehicle-control/$imei";
  static String deleteVehicle(String id) =>
      "$baseURL/api/vehicle/vehicle/$id";
  static String checkImei(String imei) =>
      "$baseURL/api/vehicle/check-imei/$imei";
  static String devicePinStatus(String imei) =>
      "$baseURL/api/device-pin/status/$imei";
  static const String setDevicePin = "$baseURL/api/device-pin/set-pin";
  static const String resetDevicePin = "$baseURL/api/device-pin/reset-pin";
  static const String verifyDevicePin = "$baseURL/api/device-pin/verify-pin";
  static const String changePinOtp = "$baseURL/api/device-pin/change-pin-otp";
  static const String verifyChangePinOtp = "$baseURL/api/device-pin/verify-change-pin";

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

  static String vehicleModelDetails(String vehicleId) =>
      "$baseURL/api/vehicle/vehicle-model-details/$vehicleId";

  // -------------------------
  // Device
  // -------------------------
  static String deviceByUserId(String userId) => "$baseURL/api/devices/$userId";
  static const String deviceDataByDate =
      "$baseURL/api/device/check-deviceList_byDate";
  static const String assignDevices = "$baseURL/api/assign-devices";
  static String deviceStatus(String imei) =>
      "$baseURL/api/device/deviceStatus/$imei";

  static const String journeyRideHistory = "$baseURL/api/journey/ride-history";
  static const String createRideMode = "$baseURL/api/ride-mode/create";
  static String onlinePastRides(String userId, {String? unit}) => "$baseURL/api/ride-mode/user/$userId${unit != null && unit.isNotEmpty ? '?unit=$unit' : ''}";
  static String updateOnlinePastRideTag(String rideId) => "$baseURL/api/ride-mode/update-tag/$rideId";
  static String deleteOnlinePastRide(String rideId) => "$baseURL/api/ride-mode/delete/$rideId";
  static String rateOnlinePastRide(String rideId) => "$baseURL/api/ride-mode/rate/$rideId";
  static String promoVideos(String imei) {
    if (imei == 'null' || imei.isEmpty) {
      return "$baseURL/api/global-video/imei-videos";
    }
    return "$baseURL/api/global-video/imei-videos/$imei";
  }
  static const String promoOffers = "$baseURL/api/banner/all";
  static const String productFeatures = "$baseURL/api/product-features";

  // -------------------------
  // LogoURL
  // -------------------------
  static const String logoUrl = "$baseURL/api/logoUrl";
  static const String theme = "$baseURL/api/theme";

  // -------------------------
  // Notification
  // -------------------------
  static String notifications(String userId, {int page = 1, int limit = 20}) =>
      "$baseURL/api/notification/user/$userId?page=$page&limit=$limit";
  static const String alertTypes = "$baseURL/api/alert-types";

  // -------------------------
  // Geo-Fence
  // -------------------------
  static const String updateGeoFence = "$baseURL/api/geoFance/update_geofence";
  static String editGeoFenceById(String fenceId) =>
      "$baseURL/api/geoFance/editGeofenceById/$fenceId";
  static String getGeoFenceData(String imei) =>
      "$baseURL/api/geoFance/geofenceData/$imei";
  static String deleteGeoFence(String imei, String fenceId) =>
      "$baseURL/api/geoFance/geofence/$imei/$fenceId";

  // -------------------------
  // Documents / Upload
  // -------------------------
  static const String uploadDocument = "$baseURL/api/documents/document";
  static const String getDocuments = "$baseURL/api/documents/document";
  static String updateDocument(String documentId) =>
      "$baseURL/api/documents/document/$documentId";
  static String deleteDocument(String documentId) =>
      "$baseURL/api/documents/document/$documentId";

  // -------------------------
  // Service Logs
  // -------------------------
  static const String serviceLogs = "$baseURL/api/service/service-logs";
  static const String addServiceLogs = "$baseURL/api/service/service-logs";
  static String updateServiceLog(String id) => "$baseURL/api/service/service-logs/$id";
  static String deleteServiceLog(String id) => "$baseURL/api/service/service-logs/$id";

  // -------------------------
  // Overspeed Alert
  // -------------------------
  static const String createOverspeedAlert =
      "$baseURL/api/overspeed/create-alert";
  static String getOverspeedAlerts(String imei) =>
      "$baseURL/api/overspeed/get-overspeed/$imei";
  static String updateOverspeedAlert(String alertId) =>
      "$baseURL/api/overspeed/update-alert/$alertId";
  static String deleteOverspeedAlert(String alertId) =>
      "$baseURL/api/overspeed/delete-alert/$alertId";

  // -------------------------
  // Add Fuel
  // -------------------------
  static const String addFuel = "$baseURL/api/vehicle-refuel/create";
  static String dashboard(String vehicleId, {String? unit}) =>
      "$baseURL/api/vehicle-refuel/fuel-log-details/$vehicleId${unit != null && unit.isNotEmpty ? '?unit=$unit' : ''}";
  static String refuel(String vehicleId, {String? unit}) => "$baseURL/api/vehicle-refuel/$vehicleId${unit != null && unit.isNotEmpty ? '?unit=$unit' : ''}";
  static String deleteRefuel(String vehicleId, String refuelId) => "$baseURL/api/vehicle-refuel/$vehicleId/$refuelId";
  static String updateRefuelLog(String refuelId) => "$baseURL/api/vehicle-refuel/update/$refuelId";
  static const String updateOdometer = "$baseURL/api/vehicle-refuel/update-odometer";

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
      
  static String getDeviceWarrantyStatus(String imei) =>
      "$baseURL/api/warranty-status/$imei";

  static String getWarrantyPaymentSummary(String imei, String planId) =>
      "$baseURL/api/warranty/warranty-payment-summary/$imei/$planId";

  static const String extendWarranty = "$baseURL/api/warranty/extend-warranty";
  static const String verifyPayment = "$baseURL/api/warranty/verify-payment";

  // -------------------------
  // Health Insurance
  // -------------------------
  static const String healthInsuranceOptions =
      "$baseURL/api/health-insurance/health-insurance-options";
  static const String saveHealthInsurance =
      "$baseURL/api/health-insurance/health-insurance";
  static String getHealthInsurance(String userId) =>
      "$baseURL/api/health-insurance/health-insurance/$userId";

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


  // -------------------------
//Help & suggestion
// -------------------------
  static const String myIssue = "$baseURL/api/help/my-issues";
  static const String mySuggestions = "$baseURL/api/help/my-suggestions";
  static const String timeSlots = "$baseURL/api/help/call-slots";
  static const String report = "$baseURL/api/help/book-call-slot";
  static const String suggestion = "$baseURL/api/help/suggestions";

  // NEED TO IMPLEMENT CORRECT API
  // static const String logout = '$baseURL/users/logout';
  // static const String userDetails = '$baseURL/users/get-details';
  // static const String updateUserDetails = '$baseURL/users/update-user-details';

  static String updateProfile(String userId) =>
      "$baseURL/api/auth/user-detail/$userId";

  static String deleteAccount(String userId) =>
      "$baseURL/user/delete/$userId";

  // -------------------------
  // Emergency Contact
  // -------------------------
  static const String addEmergencyNumber = "$baseURL/api/emergency-number";

  // -------------------------
  // Notification Controls
  // -------------------------
  static String notificationControl(String imei) => "$baseURL/api/notification-control/$imei";
  static const String updateNotificationControl = "$baseURL/api/notification-control/update";

  // -------------------------
  // Sessions
  // -------------------------
  static String getSessions(String userId) => "$baseURL/api/sessions/$userId";
  static String logoutSession(String sessionId) => "$baseURL/api/sessions/logout/$sessionId";
  static const String updateFcmSession = "$baseURL/api/sessions/update-fcm";
  static const String checkToken = "$baseURL/api/sessions/check-token";

  // -------------------------
  // Statistics
  // -------------------------
  static String statistics(String imei, {String? date, String? unit}) {
    String url = "$baseURL/api/statistics/$imei";
    List<String> queryParams = [];
    if (date != null && date.isNotEmpty) {
      queryParams.add("date=$date");
    }
    if (unit != null && unit.isNotEmpty) {
      queryParams.add("unit=$unit");
    }
    if (queryParams.isNotEmpty) {
      url += "?${queryParams.join('&')}";
    }
    return url;
  }

  // -------------------------
  // General Settings
  // -------------------------
  static const String generalSettings = "$baseURL/api/general-settings";
}
