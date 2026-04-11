// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get selectLanguage => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get letsGetStarted => 'ಪ್ರಾರಂಭಿಸೋಣ';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get password => 'ಪಾಸ್ವರ್ಡ್';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'ಇಮೇಲ್ ಅಗತ್ಯವಿದೆ';

  @override
  String get passwordRequired => 'ಪಾಸ್ವರ್ಡ್ ಅಗತ್ಯವಿದೆ';

  @override
  String get invalidEmail => 'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ';

  @override
  String get forgotPassword => 'ಪಾಸ್ವರ್ಡ್ ಮರೆತಿದ್ದೀರಾ?';

  @override
  String get signIn => 'ಸೈನ್ ಇನ್ ಮಾಡಿ';

  @override
  String get or => 'ಅಥವಾ';

  @override
  String get dontHaveAccount => 'ಖಾತೆಯನ್ನು ಹೊಂದಿಲ್ಲವೇ? ';

  @override
  String get signUp => 'ಸೈನ್ ಅಪ್ ಮಾಡಿ';

  @override
  String welcome(String email) {
    return 'ಸ್ವಾಗತ $email!';
  }

  @override
  String get loginFailed => 'ಲಾಗಿನ್ ವಿಫಲವಾಗಿದೆ';

  @override
  String get name => 'ಹೆಸರು';

  @override
  String get nameHint => 'ಜಾನ್ ಡೋ';

  @override
  String get nameRequired => 'ಹೆಸರು ಅಗತ್ಯವಿದೆ';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get mobileNumberHint => 'Enter mobile number';

  @override
  String get mobileNumberRequired => 'Mobile number is required';

  @override
  String get country => 'Country';

  @override
  String get countryHint => 'Enter country';

  @override
  String get countryRequired => 'Country is required';

  @override
  String get state => 'State';

  @override
  String get stateHint => 'Enter state';

  @override
  String get stateRequired => 'State is required';

  @override
  String get city => 'City';

  @override
  String get cityHint => 'Enter city';

  @override
  String get cityRequired => 'City is required';

  @override
  String get selectProfileImage => 'Select Profile Image';

  @override
  String get role => 'ಪಾತ್ರ';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get selectRoleHint => 'Select Role';

  @override
  String get roleRequired => 'ದಯವಿಟ್ಟು ಪಾತ್ರವನ್ನು ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get createAccount => 'ಖಾತೆಯನ್ನು ರಚಿಸಿ';

  @override
  String get registerSuccess =>
      'ಬಳಕೆದಾರರನ್ನು ಯಶಸ್ವಿಯಾಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ, ದಯವಿಟ್ಟು ಲಾಗಿನ್ ಮಾಡಿ';

  @override
  String get signUpFailed => 'ಸೈನ್ ಅಪ್ ವಿಫಲವಾಗಿದೆ';

  @override
  String get otpSent => 'OTP ಯಶಸ್ವಿಯಾಗಿ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get resetPassword => 'ಪಾಸ್ವರ್ಡ್ ಮರುಹೊಂದಿಸಿ';

  @override
  String get resetPasswordDesc =>
      'ನಿಮ್ಮ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ಮರುಹೊಂದಿಸಲು ನಾವು ಲಿಂಕ್ ಕಳುಹಿಸುತ್ತೇವೆ.';

  @override
  String get sendResetLink => 'ಮರುಹೊಂದಿಸುವ ಲಿಂಕ್ ಅನ್ನು ಕಳುಹಿಸಿ';

  @override
  String get otpVerified => 'OTP ಯಶಸ್ವಿಯಾಗಿ ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get verifyOtp => 'OTP ಪರಿಶೀಲಿಸಿ';

  @override
  String get otpHeader => 'OTP ಪರಿಶೀಲನೆ';

  @override
  String otpDesc(String email) {
    return '$email ಗೆ ಕಳುಹಿಸಲಾದ OTP ಅನ್ನು ನಮೂದಿಸಿ.';
  }

  @override
  String get otp => 'OTP';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'OTP ಅಗತ್ಯವಿದೆ';

  @override
  String get passwordResetSuccess => 'ಪಾಸ್ವರ್ಡ್ ಯಶಸ್ವಿಯಾಗಿ ಮರುಹೊಂದಿಸಲಾಗಿದೆ';

  @override
  String get createNewPassword => 'ಹೊಸ ಪಾಸ್ವರ್ಡ್ ಅನ್ನು ರಚಿಸಿ';

  @override
  String get passwordDesc =>
      'ನಿಮ್ಮ ಹೊಸ ಪಾಸ್‌ವರ್ಡ್ ಹಿಂದಿನ ಪಾಸ್‌ವರ್ಡ್‌ಗಳಿಗಿಂತ ಭಿನ್ನವಾಗಿರಬೇಕು.';

  @override
  String get newPassword => 'ಹೊಸ ಪಾಸ್ವರ್ಡ್';

  @override
  String get newPasswordHint => 'ನಿಮ್ಮ ಹೊಸ ಪಾಸ್ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  String get passwordMinLength => 'ಪಾಸ್ವರ್ಡ್ ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು';

  @override
  String get confirmPassword => 'ಪಾಸ್ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get confirmPasswordHint => 'ನಿಮ್ಮ ಹೊಸ ಪಾಸ್ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get confirmPasswordRequired => 'ಪಾಸ್ವರ್ಡ್ ದೃಢೀಕರಣದ ಅಗತ್ಯವಿದೆ';

  @override
  String get passwordsDoNotMatch => 'ಪಾಸ್ವರ್ಡ್ಗಳು ಹೊಂದಾಣಿಕೆಯಾಗುತ್ತಿಲ್ಲ';

  @override
  String get selectDevice => 'ಸಾಧನವನ್ನು ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get noDevicesFound => 'ಯಾವುದೇ ಸಾಧನಗಳು ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get proceed => 'ಮುಂದುವರಿಯಿರಿ';

  @override
  String get unknownDevice => 'ಅಜ್ಞಾತ ಸಾಧನ';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'ಸಾಧನಗಳನ್ನು ಪಡೆಯಲು ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get recordRide => 'ಪ್ರಯಾಣವನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ';

  @override
  String get phoneAsGps =>
      'ನಿಮ್ಮ ಫೋನ್ ಅನ್ನು ಜಿಪಿಎಸ್ ಟ್ರ್ಯಾಕಿಂಗ್ ಸಾಧನವನ್ನಾಗಿ ಮಾಡಿ';

  @override
  String get goToDashboard => 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್‌ಗೆ ಹೋಗಿ';

  @override
  String get seeFullMap => 'ಪೂರ್ಣ ನಕ್ಷೆಯನ್ನು ನೋಡಿ';

  @override
  String get exploreMore => 'ಹೆಚ್ಚು ಅನ್ವೇಷಿಸಿ';

  @override
  String get reachMeSticker => 'ReachMe ಸ್ಟಿಕರ್';

  @override
  String get products => 'ಉತ್ಪನ್ನಗಳು';

  @override
  String get fuelLogs => 'ಇಂಧನ ದಾಖಲೆಗಳು';

  @override
  String get locationSharing => 'ಸ್ಥಳ ಹಂಚಿಕೆ';

  @override
  String get documentFolder => 'ಡಾಕ್ಯುಮೆಂಟ್ ಫೋಲ್ಡರ್';

  @override
  String get voiceMonitoring => 'ಧ್ವನಿ ಮಾನಿಟರಿಂಗ್';

  @override
  String get remoteEngineOff => 'ರಿಮೋಟ್ ಇಂಜಿನ್ ಆಫ್';

  @override
  String get networkBooster => 'ನೆಟ್‌ವರ್ಕ್ ಬೂಸ್ಟರ್';

  @override
  String get emergency => 'ತುರ್ತು';

  @override
  String get overspeedAlert => 'ಅತಿವೇಗದ ಎಚ್ಚರಿಕೆ';

  @override
  String get geoFenceAlert => 'ಜಿಯೋ-ಫೆನ್ಸ್ ಎಚ್ಚರಿಕೆ';

  @override
  String get more => 'ಹೆಚ್ಚು';

  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get bikeSmartMsg =>
      '1000+ ಜನರು ನಮ್ಮ ಸಾಧನದೊಂದಿಗೆ ತಮ್ಮ ಬೈಕನ್ನು ಸ್ಮಾರ್ಟ್ ಮಾಡಿದ್ದಾರೆ';

  @override
  String get features => 'ವೈಶಿಷ್ಟ್ಯಗಳು';

  @override
  String get contactUs => 'ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get contactUsDesc => 'ಪ್ರಶ್ನೆಗಳಿವೆಯೇ? ನಾವು ಸಹಾಯ ಮಾಡಲು ಇಲ್ಲಿದ್ದೇವೆ.';

  @override
  String get userReviews => 'ಬಳಕೆದಾರರ ವಿಮರ್ಶೆಗಳು';

  @override
  String get accidentAlert => 'ಅಪಘಾತ ಎಚ್ಚರಿಕೆ';

  @override
  String get antiTheftAlert => 'ಕಳ್ಳತನ ವಿರೋಧಿ ಎಚ್ಚರಿಕೆ';

  @override
  String get geoFence => 'ಜಿಯೋ ಫೆನ್ಸ್';

  @override
  String get statistics => 'ಅಂಕಿಅಂಶಗಳು';

  @override
  String get myGarage => 'ನನ್ನ ಗ್ಯಾರೇಜ್';

  @override
  String get noVehiclesInGarage =>
      'ನಿಮ್ಮ ಗ್ಯಾರೇಜ್‌ನಲ್ಲಿ ಯಾವುದೇ ವಾಹನಗಳು ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get unknownVehicle => 'ಅಜ್ಞಾತ ವಾಹನ';

  @override
  String get status => 'ಸ್ಥಿತಿ';

  @override
  String get active => 'ಸಕ್ರಿಯ';

  @override
  String get subscription => 'ಚಂದಾದಾರಿಕೆ';

  @override
  String get proPlan => 'ಪ್ರೊ ಯೋಜನೆ';

  @override
  String get initializeGarage => 'ನಿಮ್ಮ ಗ್ಯಾರೇಜ್ ಅನ್ನು ಪಡೆಯಲು ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get ourProducts => 'ನಮ್ಮ ಉತ್ಪನ್ನಗಳು';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'ಗರಿಷ್ಠ ವೈಶಿಷ್ಟ್ಯಗಳೊಂದಿಗೆ ಸುಧಾರಿತ ಟ್ರ್ಯಾಕಿಂಗ್';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'ದಿನನಿತ್ಯದ ಬಳಕೆಗಾಗಿ ಪ್ರಮಾಣಿತ ಟ್ರ್ಯಾಕಿಂಗ್';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'ಮೂಲ ಲೊಕೇಟರ್ ಸಾಧನ';

  @override
  String get realTime1s => 'ರಿಯಲ್-ಟೈಮ್ 1 ಸೆ ಟ್ರ್ಯಾಕಿಂಗ್';

  @override
  String get remoteEngineCutOff => 'ರಿಮೋಟ್ ಇಂಜಿನ್ ಕಟ್-ಆಫ್';

  @override
  String get detailedFuelAnalytics => 'ವಿವರವಾದ ಇಂಧನ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get realTime5s => 'ರಿಯಲ್-ಟೈಮ್ 5 ಸೆ ಟ್ರ್ಯಾಕಿಂಗ್';

  @override
  String get antiTheftAlerts => 'ಕಳ್ಳತನ ವಿರೋಧಿ ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get basicJourneyLogs => 'ಮೂಲ ಪ್ರಯಾಣದ ದಾಖಲೆಗಳು';

  @override
  String get locationUpdates => 'ಸ್ಥಳದ ಅಪ್ಡೇಟ್ಗಳು';

  @override
  String get batteryMonitor => 'ಬ್ಯಾಟರಿ ಮಾನಿಟರ್';

  @override
  String get featuresLabel => 'ವೈಶಿಷ್ಟ್ಯಗಳು:';

  @override
  String addedToCart(String title) {
    return '$title ಅನ್ನು ಕಾರ್ಟ್‌ಗೆ ಯಶಸ್ವಿಯಾಗಿ ಸೇರಿಸಲಾಗಿದೆ!';
  }

  @override
  String get buyNow => 'ಈಗಲೇ ಖರೀದಿಸಿ';

  @override
  String get retry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String errorMsg(String message) {
    return 'ದೋಷ: $message';
  }

  @override
  String get addVehicle => 'Add Vehicle/Device';

  @override
  String get vehicleAdded => 'Vehicle added successfully!';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get twoWheeler => 'Two Wheeler';

  @override
  String get fourWheeler => 'Four Wheeler';

  @override
  String get autoRickshaw => 'Auto Rickshaw';

  @override
  String get heavyVehicle => 'Heavy Vehicle';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get petrol => 'Petrol';

  @override
  String get electric => 'Electric';

  @override
  String get vehicleMake => 'Vehicle Make';

  @override
  String get vehicleModel => 'Vehicle Model';

  @override
  String get vehicleNumber => 'Vehicle number';

  @override
  String get vehicleNumberHint => 'e.g. MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'Please enter vehicle number';

  @override
  String get selectMake => 'Select Vehicle Make';

  @override
  String get selectModel => 'Select Vehicle Model';

  @override
  String get installDevice => 'Install Trackify Device';

  @override
  String get installDeviceDesc =>
      'Quickly set up your Ajjas smart device with simple steps';

  @override
  String get activateSticker => 'Activate Contact Sticker';

  @override
  String get activateStickerDesc =>
      'Simple steps to quickly activate your contact sticker';

  @override
  String get exploreFreeApp => 'Explore Our Free App';

  @override
  String get exploreFreeAppDesc =>
      'Record rides using phone manually & keep track of it using our free app curated for you';

  @override
  String get logout => 'Logout';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dataPlan => 'ಡೇಟಾ ಪ್ಲಾನ್';

  @override
  String get warranty => 'ವಾರಂಟಿ';

  @override
  String expiresInDays(String days) {
    return '$days ದಿನಗಳಲ್ಲಿ ಮುಕ್ತಾಯಗೊಳ್ಳುತ್ತದೆ';
  }

  @override
  String get rechargeNow => 'ಈಗ ರೀಚಾರ್ಜ್ ಮಾಡಿ';

  @override
  String get renewNow => 'ಈಗ ನವೀಕರಿಸಿ';

  @override
  String get secureYourVehicle => 'ನಿಮ್ಮ ವಾಹನವನ್ನು ಸುರಕ್ಷಿತಗೊಳಿಸಿ';

  @override
  String get secureYourVehicleDesc =>
      'ನೈಜ-ಸಮಯದ ಟ್ರ್ಯಾಕಿಂಗ್ ಮತ್ತು ಮನಃಶಾಂತಿಗಾಗಿ ಈಗ ಅಜ್ಜಾಸ್ ಸಾಧನವನ್ನು ಖರೀದಿಸಿ.';

  @override
  String get boughtDeviceInstallNow => 'ಸಾಧನವನ್ನು ಖರೀದಿಸಿದ್ದೀರಾ? ';

  @override
  String get installNow => 'ಈಗ ಸ್ಥಾಪಿಸಿ';

  @override
  String get buyAjjasDevice => 'ಅಜ್ಜಾಸ್ ಸಾಧನವನ್ನು ಖರೀದಿಸಿ';

  @override
  String get lite4G => 'ಲೈಟ್ 4ಜಿ';

  @override
  String get swipeToLock => 'ಲಾಕ್ ಮಾಡಲು ಸ್ವೈಪ್ ಮಾಡಿ';

  @override
  String get upgradeToPlus => 'Upgrade to Ajjas Plus';

  @override
  String get getMoreOutOfAjjas => 'Get more out of Ajjas';

  @override
  String featuresExploredCount(Object count, Object total) {
    return 'You\'ve explored $count of $total features - keep going!';
  }

  @override
  String get manageVehiclesDesc => 'Manage all your Vehicles here';

  @override
  String get settingsDesc => 'Language, Account Settings & more';

  @override
  String get notifications => 'Notifications';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpAndSupportDesc => 'Get assistance and FAQs';

  @override
  String get settings => 'Settings';

  @override
  String get searchForSettings => 'Search for settings';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get backupAndRestoreDesc =>
      'Back up your rides data and restore them anytime.';

  @override
  String get appSettings => 'App Settings';

  @override
  String get appSettingsDesc => 'App Theme, Ride Heatmap and Emergency Feature';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationSettingsDesc =>
      'Notification preference & Notification sound';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyDesc =>
      'Change password, manage current session, delete your account';

  @override
  String get rateUsOnPlayStore => 'Rate us on Play Store';

  @override
  String get rateUsOnPlayStoreDesc => 'Share your valuable feedback';

  @override
  String get logoutDesc => 'Logout from this device';

  @override
  String get helpAndSuggestion => 'Help & Suggestion';

  @override
  String get reportAnIssue => 'Report an issue';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get whatIsYourIssueRelatedTo => 'What is your issue related to ?';

  @override
  String get shortDescriptionHint =>
      'Give us a short description (max 200 characters)';

  @override
  String get selectCallSlot => 'Select Call Slot';

  @override
  String get myIssues => 'My Issues';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get forceMigrate => 'Force Migrate';

  @override
  String get forceMigrateDesc1 =>
      'Use this option to fix backed up daily rides missed during app update.';

  @override
  String get forceMigrateDesc2 =>
      'Please note, this does not bring back your old rides from the server. It only migrates data in your local storage to the new data format for you to view it.';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get termsConditions => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get changeLog => 'Change log';
}
