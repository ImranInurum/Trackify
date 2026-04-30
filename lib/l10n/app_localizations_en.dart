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
  String get invalidMobileNumber => 'Please enter a valid mobile number';

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
  String get noNotifications => 'No notifications found';

  @override
  String get notificationsFetchedSuccessfully =>
      'Notifications fetched successfully';

  @override
  String get errorFetchingNotifications => 'Error fetching notifications';

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

  @override
  String get vehicleMakeListEmpty =>
      'Vehicle make list is empty for this selection';

  @override
  String get vehicleModelListEmpty =>
      'Vehicle model list is empty for this selection';

  @override
  String get deviceInstallation => 'Device Installation';

  @override
  String get scanActivationCode => 'Scan activation code';

  @override
  String get enterActivationCodeManually => 'Enter activation code manually';

  @override
  String get openAjjasBoxInstruction =>
      'Open Ajjas box for the activation QR code.';

  @override
  String get continueText => 'Continue';

  @override
  String get enterUID => 'Enter UID';

  @override
  String get enterIMEINumber => 'Enter IMEI number';

  @override
  String get close => 'Close';

  @override
  String get uidRequired => 'UID is required';

  @override
  String get imeiRequired => 'IMEI number is required';

  @override
  String get deviceAssignedSuccess =>
      'Device successfully assigned to vehicle!';

  @override
  String get assigningDevice => 'Assigning device...';

  @override
  String get invalidImeiError => 'Please enter a valid 15-digit IMEI number';

  @override
  String get sharedRides => 'Shared Rides';

  @override
  String get savedRides => 'Saved Rides';

  @override
  String get allRides => 'ALL RIDES';

  @override
  String get trips => 'TRIPS';

  @override
  String clicked(String value) {
    return '$value Clicked';
  }

  @override
  String get noDailyRides => 'No daily rides to show';

  @override
  String get getStartedFirstRide => 'Get started by taking your first ride';

  @override
  String get durationLabel => 'Duration';

  @override
  String get km => 'km';

  @override
  String get kmh => 'km/h';

  @override
  String get tripEmptyQuote =>
      '“Group your rides into trips, add memories, and relive the journey”';

  @override
  String ridesCompletedCount(String completed, String total) {
    return 'Rides completed: $completed/$total';
  }

  @override
  String get unlockTripsRequirement =>
      'You need at least 3 rides to unlock trips';

  @override
  String get createNewTrip => 'Create a New Trip';

  @override
  String get startByCreatingTrip => 'Start by creating a New Trip';

  @override
  String get skip => 'Skip';

  @override
  String get todayText => 'Today';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get rideDuration => 'Ride Duration';

  @override
  String get speedLabel => 'Speed';

  @override
  String get minutesShort => 'm';

  @override
  String get secondsShort => 's';

  @override
  String get getMoreOutOfTrackify => 'Get more out of Trackify';

  @override
  String get discoverMoreDesc => 'Discover more — awesome things await!';

  @override
  String get serviceLogs => 'Service Logs';

  @override
  String get safeParking => 'Safe Parking';

  @override
  String get appUpdates => 'App Updates';

  @override
  String get deviceDataPlanLabel => 'Device Data Plan';

  @override
  String get deviceWarrantyLabel => 'Device Warranty';

  @override
  String get videoTutorials => 'Video Tutorials';

  @override
  String get exploreNow => 'Explore Now';

  @override
  String get plusLabel => 'Plus';

  @override
  String get mapStyleLabel => 'Map Style';

  @override
  String get darkStyle => 'Dark';

  @override
  String get lightStyle => 'Light';

  @override
  String get simpleStyle => 'Simple';

  @override
  String get satelliteStyle => 'Satellite';

  @override
  String get mapOptionsLabel => 'Map Options';

  @override
  String get trafficLabel => 'Traffic';

  @override
  String get labelsLabel => 'Labels';

  @override
  String get sharedWithMe => 'Shared with me';

  @override
  String get todaysStats => 'Today\'s Stats';

  @override
  String parkedSinceTime(String time) {
    return 'Parked Since: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return '$value kms more to go';
  }

  @override
  String get buyTrackifyDevice => 'Buy Trackify Device';

  @override
  String get recordViaPhone => 'Record via Phone';

  @override
  String progressPercentage(String value) {
    return '$value%';
  }

  @override
  String labelColon(String label) {
    return '$label:';
  }

  @override
  String get fuelEmpty => 'E';

  @override
  String get fuelFull => 'F';

  @override
  String get vehicleNamePlaceholder => 'SP 125';

  @override
  String get vehicleNumberPlaceholder => 'MP09QV8269';

  @override
  String get myProfile => 'My profile';

  @override
  String get profileCompleteness => 'Profile completeness';

  @override
  String lastUpdatedOn(String date) {
    return 'Last updated on $date';
  }

  @override
  String get addProfilePicture => 'Add your profile picture';

  @override
  String get personalDetails => 'Personal details';

  @override
  String get userNameLabel => 'Name';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get mobileNumberLabel => 'Mobile Number';

  @override
  String get countryLabel => 'Country';

  @override
  String get stateLabel => 'State';

  @override
  String get cityLabel => 'City';

  @override
  String get medicalInsuranceInfo => 'Medical insurance information';

  @override
  String get addMedicalInsuranceInfo => 'Add Medical insurance information';

  @override
  String get vehicleInsuranceInfo => 'Vehicle insurance information';

  @override
  String get editViewVehicleInsuranceDesc =>
      'Edit and view vehicle insurance details in vehicle settings.';

  @override
  String get myGarageVehiclePath => 'My Garage > Vehicle';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get addEditEmergencyContactDesc =>
      'Add and edit emergency contact list in vehicle settings.';

  @override
  String get smartContactSticker => 'Smart Contact Sticker';

  @override
  String get stickerSubtitle =>
      'A step forward to make your vehicle SAFE and SMART';

  @override
  String get activateContactSticker => 'Activate contact sticker';

  @override
  String get buyNewContactSticker => 'Buy a new contact sticker';

  @override
  String get beyondParkingProblems => 'Beyond parking problems';

  @override
  String get noParkings => 'No Parkings';

  @override
  String get emergencies => 'Emergencies';

  @override
  String get vehicleTowing => 'Vehicle towing';

  @override
  String get getInformedStayConnected =>
      'Get informed & stay connected\nwith your vehicle';

  @override
  String get securedCalls => 'Secured Calls';

  @override
  String get securedCallsDesc =>
      'Internet-masked calls-keeps your phone number private.';

  @override
  String get notificationHistory => 'Notification History';

  @override
  String get notificationHistoryDesc =>
      'Keep track of all the current and previous notifications';

  @override
  String get beInformed => 'Be Informed';

  @override
  String get beInformedDesc =>
      'Know instantly when someone scans your QR code & take prompt actions when they call you.';

  @override
  String get controlWhatOthersSee => 'Control What Others See';

  @override
  String get controlWhatOthersSeeDesc =>
      'Customize the details shown when someone scans the QR.';

  @override
  String get preventFrustrationDamage => 'Prevent Frustration & Damage';

  @override
  String get preventFrustrationDamageDesc =>
      'Avoid conflicts and vehicle damage caused by incorrect parking.';

  @override
  String get serviceLogsSubtitle =>
      'Never miss a vehicle service. Get reminders and track expenses to keep your vehicle in top condition.';

  @override
  String get addServiceLogs => 'Add Service Logs';

  @override
  String get uploadServicingBill => 'Upload Servicing bill';

  @override
  String get addImage => 'Add Image';

  @override
  String get maxFileSizeNote => 'Note: Maximum File Size is 5MB';

  @override
  String get serviceDate => 'Service Date';

  @override
  String get billingAmount => 'Billing Amount';

  @override
  String get serviceCenterName => 'Service Center Name';

  @override
  String get serviceCenterContact => 'Service Center Contact';

  @override
  String get additionalNote => 'Additional Note';

  @override
  String get saveDetails => 'Save Details';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get liveTab => 'LIVE';

  @override
  String get historyTab => 'HISTORY';

  @override
  String get liveLocationSharingActive => 'Live Location Sharing Active';

  @override
  String get noLiveLocationShared => 'No live location shared';

  @override
  String get realTimeSharingDesc =>
      'Your location is being shared in real-time with selected contacts.';

  @override
  String get startSharingPhoneDesc =>
      'Start sharing your phone\'s location to help others track you';

  @override
  String get noHistoryAvailable => 'No history available';

  @override
  String get historyDesc =>
      'Past location shares will appear here once they are completed.';

  @override
  String get stopSharing => 'Stop Sharing';

  @override
  String get shareLocation => 'Share Location';

  @override
  String get startSharing => 'Start Sharing';

  @override
  String get phoneTracking => 'Phone Tracking';

  @override
  String get liveRecordTab => 'Live Record';

  @override
  String get statsTab => 'Stats';

  @override
  String get timeLabel => 'Time';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get custom => 'Custom';

  @override
  String get quickStats => 'Quick Stats';

  @override
  String get totalRides => 'Total Rides';

  @override
  String get avgSpeed => 'Avg Speed';

  @override
  String get totalFuel => 'Total Fuel';

  @override
  String get overallDistance => 'Overall Distance';

  @override
  String get drivingTime => 'Driving Time';

  @override
  String get safetyScore => 'Safety Score';

  @override
  String get speedAlertInput => 'Speed alert input';

  @override
  String get alertTitle => 'Alert title';

  @override
  String get speedLimitKmH => 'Speed limit (km/h)';

  @override
  String get timeDurationSec => 'Time Duration (sec)';

  @override
  String get selectYourVehicle => 'Select your vehicle';

  @override
  String get submit => 'Submit';

  @override
  String get selectVehiclesOverspeedAlert =>
      'Select vehicles on which to add overspeed alert';

  @override
  String get selected => 'Selected';

  @override
  String get sec => 'sec';

  @override
  String get kmHr => 'km/hr';

  @override
  String get viewMore => 'View more';

  @override
  String get viewLess => 'View less';

  @override
  String get previousRides => 'Previous Rides';

  @override
  String get seeAll => 'See All';

  @override
  String get videosYouMightLike => 'Videos You Might Like';

  @override
  String get scrollToTop => 'Scroll to Top';

  @override
  String get noRecentRidesFound => 'No recent rides found';

  @override
  String get failedToLoadRides => 'Failed to load rides';

  @override
  String get hrMin => 'hr:min';

  @override
  String get vehicleLabel => 'Vehicle';

  @override
  String get switchLabel => 'Switch';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get rechargePlans => 'Recharge Plans';

  @override
  String get superComboPlan => 'Super Combo Plan';

  @override
  String get month12Validity => '12-Month Validity';

  @override
  String get month6Validity => '6-Month Validity';

  @override
  String saveAmount(Object amount) {
    return 'Save ₹$amount with this plan';
  }

  @override
  String get superComboPopularity => '95% of users choose the Super Combo Plan';

  @override
  String get appSimRecharge => 'App & SIM Recharge';

  @override
  String get extendedWarranty => 'Extended Warranty';

  @override
  String get plusMembership => 'Plus Membership';

  @override
  String get continueSuperCombo => 'Continue with Super Combo Plan';

  @override
  String get continue12Month => 'Continue with 12-Month Plan';

  @override
  String get continue6Month => 'Continue with 6-Month Plan';
}
