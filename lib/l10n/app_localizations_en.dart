// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select your language';

  @override
  String get letsGetStarted => 'Let\'s Get Started';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'Email required';

  @override
  String get passwordRequired => 'Password required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'or';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String welcome(String email) {
    return 'Welcome $email!';
  }

  @override
  String get loginFailed => 'Login failed';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'John Doe';

  @override
  String get nameRequired => 'Name is required';

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
  String get role => 'Role';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get selectRoleHint => 'Select Role';

  @override
  String get roleRequired => 'Please select a role';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerSuccess => 'User Registered Successfully Please Login';

  @override
  String get signUpFailed => 'Sign up failed';

  @override
  String get otpSent => 'OTP sent successfully';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get otpVerified => 'OTP verified successfully';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get otpHeader => 'OTP Verification';

  @override
  String otpDesc(String email) {
    return 'Enter the OTP sent to $email.';
  }

  @override
  String get otp => 'OTP';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'OTP is required';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get passwordDesc =>
      'Your new password must be different from previous used passwords.';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter your new password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your new password';

  @override
  String get confirmPasswordRequired => 'Confirm Password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get selectDevice => 'Select Device';

  @override
  String get noDevicesFound => 'No devices found.';

  @override
  String get proceed => 'Proceed';

  @override
  String get unknownDevice => 'Unknown Device';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'Initialize to fetch devices.';

  @override
  String get recordRide => 'Record Ride';

  @override
  String get phoneAsGps => 'Make your phone a GPS Tracking device';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get seeFullMap => 'See full map';

  @override
  String get exploreMore => 'Explore More';

  @override
  String get reachMeSticker => 'ReachMe Sticker';

  @override
  String get products => 'Products';

  @override
  String get fuelLogs => 'Fuel Logs';

  @override
  String get locationSharing => 'Location Sharing';

  @override
  String get documentFolder => 'Document Folder';

  @override
  String get voiceMonitoring => 'Voice Monitoring';

  @override
  String get remoteEngineOff => 'Remote Engine OFF';

  @override
  String get networkBooster => 'Network Booster';

  @override
  String get emergency => 'Emergency';

  @override
  String get overspeedAlert => 'Overspeed Alert';

  @override
  String get geoFenceAlert => 'Geo-fence Alert';

  @override
  String get more => 'More';

  @override
  String get profile => 'Profile';

  @override
  String get bikeSmartMsg =>
      '1000+ people made their bike smart with our device';

  @override
  String get features => 'Features';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsDesc => 'Got questions? We are here to help.';

  @override
  String get userReviews => 'User Reviews';

  @override
  String get accidentAlert => 'Accident Alert';

  @override
  String get antiTheftAlert => 'Anti-Theft Alert';

  @override
  String get geoFence => 'Geo Fence';

  @override
  String get statistics => 'Statistics';

  @override
  String get myGarage => 'My Garage';

  @override
  String get noVehiclesInGarage => 'No vehicles found in your garage.';

  @override
  String get unknownVehicle => 'Unknown Vehicle';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get subscription => 'Subscription';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String get initializeGarage => 'Initialize to fetch your garage.';

  @override
  String get ourProducts => 'Our Products';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'Advanced tracking with max features';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'Standard tracking for everyday use';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'Basic locator device';

  @override
  String get realTime1s => 'Real-time 1s tracking';

  @override
  String get remoteEngineCutOff => 'Remote engine cut-off';

  @override
  String get detailedFuelAnalytics => 'Detailed Fuel Analytics';

  @override
  String get realTime5s => 'Real-time 5s tracking';

  @override
  String get antiTheftAlerts => 'Anti-theft alerts';

  @override
  String get basicJourneyLogs => 'Basic journey logs';

  @override
  String get locationUpdates => 'Location updates';

  @override
  String get batteryMonitor => 'Battery monitor';

  @override
  String get featuresLabel => 'Features:';

  @override
  String addedToCart(String title) {
    return 'Added $title to cart!';
  }

  @override
  String get buyNow => 'Buy Now';

  @override
  String get retry => 'Retry';

  @override
  String errorMsg(String message) {
    return 'Error: $message';
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
  String get dataPlan => 'Data Plan';

  @override
  String get warranty => 'Warranty';

  @override
  String expiresInDays(String days) {
    return 'Expires in $days days';
  }

  @override
  String get rechargeNow => 'Recharge Now';

  @override
  String get renewNow => 'Renew Now';

  @override
  String get secureYourVehicle => 'Secure Your Vehicle';

  @override
  String get secureYourVehicleDesc =>
      'Buy Ajjas device now for real-time tracking and complete peace of mind.';

  @override
  String get boughtDeviceInstallNow => 'Bought a device? ';

  @override
  String get installNow => 'Install now';

  @override
  String get buyAjjasDevice => 'Buy Ajjas Device';

  @override
  String get lite4G => 'Lite 4G';

  @override
  String get swipeToLock => 'SWIPE TO LOCK';

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

  @override
  String get todayLabel => '(Today)';

  @override
  String get ridingBehaviour => 'Riding Behaviour';

  @override
  String get ridingBehaviourVacationDesc =>
      'Looks like your vehicle enjoyed a little vacation, as you didn\'t take any ride during the selected time period';

  @override
  String get journey => 'Journey';

  @override
  String get distanceTravelled => 'Distance Travelled';

  @override
  String get timeDuration => 'Time Duration';

  @override
  String get speed => 'Speed';

  @override
  String get averageSpeed => 'Average Speed';

  @override
  String get topSpeed => 'Top Speed';

  @override
  String get fuel => 'Fuel';

  @override
  String get fuelConsumed => 'Fuel Consumed';

  @override
  String get fuelCost => 'Fuel Cost';

  @override
  String vsPreviousPeriod(String value) {
    return '$value% vs previous period';
  }
}
