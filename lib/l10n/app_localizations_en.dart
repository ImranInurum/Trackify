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
  String get proceed => 'PROCEED';

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
  String get vehicleImage => 'Vehicle Image';

  @override
  String get newLabel => 'NEW';

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
      'Quickly set up your Trackify smart device with simple steps';

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
  String expiresInDays(int days) {
    return 'Expires in $days days';
  }

  @override
  String get rechargeNow => 'Recharge Now';

  @override
  String get renewNow => 'Renew now';

  @override
  String get secureYourVehicle => 'Secure Your Vehicle';

  @override
  String get secureYourVehicleDesc =>
      'Buy Trackify device now for real-time tracking and complete peace of mind.';

  @override
  String get boughtDeviceInstallNow => 'Bought a device? ';

  @override
  String get installNow => 'Install now';

  @override
  String get buyTrackifyDevice => 'Buy Trackify Device';

  @override
  String get lite4G => 'Lite 4G';

  @override
  String get swipeToLock => 'SWIPE TO LOCK';

  @override
  String get upgradeToPlus => 'Upgrade to Plus';

  @override
  String get getMoreOutOfTrackify => 'Get more out of Trackify';

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
  String get whatIsYourIssueRelatedTo => 'What is your issue related to?';

  @override
  String get shortDescriptionHint =>
      'Give us a short description (max 200 characters)';

  @override
  String get selectCallSlot => 'Select Call Slot';

  @override
  String get myIssues => 'My Issues';

  @override
  String get mySuggestions => 'My Suggestions';

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
  String get deviceInstallation => 'Trackify Device Installation';

  @override
  String get scanActivationCode => 'Scan activation code';

  @override
  String get enterActivationCodeManually => 'Enter activation code manually';

  @override
  String get openTrackifyBoxInstruction =>
      'Open Trackify box for the activation QR code.';

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
  String get maxFileSizeNote => 'Note: Max file size is 5MB';

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

  @override
  String get vehicleDocumentsTitle => 'Vehicle Documents';

  @override
  String get personalDocumentsSubtitle =>
      'Keep your vehicle documents handy by uploading them';

  @override
  String get vehicleRC => 'Vehicle RC';

  @override
  String get insurance => 'Insurance';

  @override
  String get puc => 'PUC';

  @override
  String get vehicleRCTitle => 'Vehicle RC';

  @override
  String get insuranceTitle => 'Insurance Details';

  @override
  String get pucTitle => 'PUC Certificate';

  @override
  String get notificationControlsTitle => 'Notification Controls';

  @override
  String get ignitionOnOffTitle => 'Ignition ON/OFF';

  @override
  String get ignitionOnOffDesc =>
      'Get notification when vehicle ignition is ON or OFF';

  @override
  String get motionWithIgnitionOffTitle => 'Motion with Ignition OFF';

  @override
  String get motionWithIgnitionOffDesc =>
      'Get notification when vehicle moves when ignition is OFF';

  @override
  String get powerSupplyOffTitle => 'Power supply OFF';

  @override
  String get powerSupplyOffDesc =>
      'Get notification when Trackify is not receiving power';

  @override
  String get appNotification => 'App notification';

  @override
  String get odometerReading => 'Odometer Reading';

  @override
  String get update => 'Update';

  @override
  String get gpsReadingNote =>
      'GPS-based reading, minor differences may occur.';

  @override
  String get tankCapacity => 'Tank Capacity';

  @override
  String get afterLastRefuel => 'After Last Refuel';

  @override
  String get fuelRemaining => 'Fuel Remaining';

  @override
  String get distanceRemaining => 'Distance Remaining';

  @override
  String get mileageArai => 'Mileage (ARAI)';

  @override
  String get spendingOnFuel => 'Spending on Fuel';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get thisYear => 'This year';

  @override
  String get all => 'All';

  @override
  String get customDates => 'Custom dates';

  @override
  String get refuelHistory => 'Refuel History';

  @override
  String get addRefuelingDetails => 'Add Refueling Details';

  @override
  String get fuelStations => 'Fuel Stations';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get litersShort => 'L';

  @override
  String get fuelEstimateNote =>
      'These values are estimates based on your fuel entries. Add fuel logs regularly for better accuracy.';

  @override
  String get gotIt => 'Got it';

  @override
  String get currentOdometerReading => 'Current Odometer Reading';

  @override
  String get odometerUpdateDesc =>
      'Regularly update your odometer for accurate fuel and distance estimates';

  @override
  String get updateTankCapacity => 'Update Tank Capacity';

  @override
  String get tankCapacityDesc =>
      'Enter the maximum fuel capacity of your vehicle tank';

  @override
  String get litres => 'Litres';

  @override
  String get kms => 'Kms';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get updateMileageArai => 'Update Mileage (ARAI)';

  @override
  String get mileageDesc =>
      'Enter current mileage (Km/L) to track remaining fuel & distance accurately.';

  @override
  String get kmL => 'Km/L';

  @override
  String get serviceLogAddedSuccess => 'Service log added successfully';

  @override
  String get currencySymbol => '₹';

  @override
  String get validityLabel => 'Validity';

  @override
  String get plusGst => '+ GST';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get refuelHistoryComingSoon => 'Refuel History Coming Soon';

  @override
  String get fuelStationsComingSoon => 'Fuel Stations Coming Soon';

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String get totalFuelAdded => 'Total Fuel Added';

  @override
  String get totalSpendings => 'Total spendings';

  @override
  String get avgMileage => 'Avg Mileage';

  @override
  String get refuels => 'Refuels';

  @override
  String get refuelingHistory => 'Refueling History';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get oldestFirst => 'Oldest First';

  @override
  String get mostExpensive => 'Most Expensive';

  @override
  String get leastExpensive => 'Least Expensive';

  @override
  String get bestMileage => 'Best Mileage';

  @override
  String get worstMileage => 'Worst Mileage';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get error => 'Something went wrong';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String hintEg(String value) {
    return 'e.g., $value';
  }

  @override
  String get addStation => 'Add Station';

  @override
  String get nearby => 'Nearby';

  @override
  String get favourites => 'Favourites';

  @override
  String get addedByMe => 'Added by me';

  @override
  String get noFavourites => 'No favourites yet';

  @override
  String get noStationsAdded => 'No stations added yet';

  @override
  String get fuelStationNearVehicle => 'Fuel Station Near Vehicle';

  @override
  String get warranty_title => 'Device Warranty';

  @override
  String get warranty_benefitsTitle => 'Benefits you do not want to miss';

  @override
  String get warranty_extend =>
      'Extend warranty of your Trackify Lite by 1 year @ ?1/day';

  @override
  String get warranty_vehicle => 'Vehicle';

  @override
  String get warranty_expiry => 'Warranty expiry date';

  @override
  String get warranty_button => 'Extend warranty now @ ?365 ';

  @override
  String get warranty_button_old => '?730';

  @override
  String get benefit1_highlight => 'Guaranteed replacement';

  @override
  String get benefit1_normal => ' in case of failure';

  @override
  String get benefit2_highlight => 'Save upto ?1200';

  @override
  String get benefit2_normal => ' on device repair';

  @override
  String get benefit3_highlight => 'Instant support';

  @override
  String get benefit3_normal => ' for device related issues';

  @override
  String get benefit4_highlight => 'Free extended subscription upto ?2000';

  @override
  String get benefit4_normal => ' for faulty period';

  @override
  String get initiatingEmergencyAlert =>
      'Initiating Emergency Alert to Trackify users';

  @override
  String get pleaseUseResponsibly => 'Please use responsibly';

  @override
  String get secondsBeforeSendingAlert => 'seconds before sending alert';

  @override
  String get sendNow => 'Send Now';

  @override
  String get geoFenceTitle => 'Geo-fence';

  @override
  String geoFenceRadius(String radius) {
    return 'Radius: ${radius}m';
  }

  @override
  String get geoFenceLocating => 'Locating...';

  @override
  String get geoFenceNameRequired => 'Please enter a geo-fence name';

  @override
  String get geoFenceSaveSuccess => 'Geo-fence saved successfully!';

  @override
  String get geoFenceSearchHint => 'Search location...';

  @override
  String get geoFenceSelectType => 'Select Geo-fence type for ';

  @override
  String get geoFenceTypeHome => 'Home';

  @override
  String get geoFenceTypeOffice => 'Office';

  @override
  String get geoFenceTypeFamily => 'Family';

  @override
  String get geoFenceTypeParking => 'Parking';

  @override
  String get geoFenceTypeOthers => 'Others';

  @override
  String get geoFenceNameFieldHint => 'Enter Geo-fence name, eg: Home';

  @override
  String get geoFenceAddSmsContacts => 'Add Contacts for SMS Alert';

  @override
  String get geoFenceEmptyStateDesc =>
      'Draw a circle on the map and be alerted whenever a bike enters or exits the circle.';

  @override
  String get addGeoFenceButton => 'Add Geo-fence';

  @override
  String get safeParkingTitle => 'Safe Parking';

  @override
  String get schedule => 'Schedule';

  @override
  String get setupSafeParking => 'Set up Safe Parking';

  @override
  String get safeParkingSubtitle =>
      'Get call alerts for engine ON & towing alerts';

  @override
  String get activate => 'Activate';

  @override
  String get activated => 'Activated';

  @override
  String get safeParkingDescription =>
      'Enable alerts when engine is turned ON or towing is detected';

  @override
  String get geoFenceDeleteConfirmation =>
      'Are you sure you want to delete this Geo-Fence?';

  @override
  String get geoFenceTurnOffConfirmation =>
      'Are you sure you want to turn Off this geo fence?';

  @override
  String get turnOff => 'Turn off';

  @override
  String get plusMembershipTitle => 'PLUS MEMBERSHIP';

  @override
  String get membership => 'Membership';

  @override
  String get premiumBenefits => 'PREMIUM BENEFITS';

  @override
  String get otherBenefits => 'OTHER BENEFITS';

  @override
  String get trackifyPlusReviews => 'TRACKIFY PLUS REVIEWS';

  @override
  String get offerings => 'Offerings';

  @override
  String get plus => 'Plus';

  @override
  String get regular => 'Regular';

  @override
  String upgradeNowAtJust(String price) {
    return 'Upgrade Now at Just ₹$price';
  }

  @override
  String get viewMoreReviews => 'View More Reviews';

  @override
  String get speciallyForYou => 'Specially For You';

  @override
  String get footerMotto =>
      'Creating a future where every bike is SMART\nand every rider is SAFE';

  @override
  String get cropDocument => 'Crop Document';

  @override
  String get cropVehicleImage => 'Crop Vehicle Image';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get pdf => 'PDF';

  @override
  String get fileTooLarge => 'File is too large (max 5MB)';

  @override
  String get pickImageError => 'Error picking image';

  @override
  String get pickPdfError => 'Error picking PDF';

  @override
  String get pdfTooLarge => 'PDF size exceeds 5MB limit';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get frontSide => 'Front Side';

  @override
  String get backSide => 'Back Side';

  @override
  String get commitmentText =>
      'We are committed to protecting your privacy and ensuring your documents are safe with us.';

  @override
  String get documentsSafe => 'Your documents are safe with us';

  @override
  String get addDocument => 'Add Document';

  @override
  String get frontRequired => 'Front side document is required';

  @override
  String get successMessage => 'Document saved successfully';

  @override
  String get selectExpiryDate => 'Select Expiry Date';

  @override
  String get documentsEncrypted => 'Your documents are encrypted & safe';

  @override
  String get fileSizeNote => 'Note: Maximum File Size is 5MB';

  @override
  String get personalDocumentsTitle => 'Personal Documents';

  @override
  String get drivingLicense => 'Driving License';

  @override
  String get drivingLicenseTitle => 'Driving License';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get otherDocumentTitle => 'Other Documents';

  @override
  String get documentName => 'Document Name*';

  @override
  String get billsTitle => 'Bills';

  @override
  String get billsDescription => 'Upload and manage your vehicle-related bills';

  @override
  String get movedTo => 'Moved to';

  @override
  String get viewNow => 'View Now';

  @override
  String get accessoryBills => 'Accessory Bills';

  @override
  String get tutorialVideos => 'Tutorial Videos';

  @override
  String get videos => 'Videos';

  @override
  String get location => 'Location';

  @override
  String get amazingFeatures => 'Amazing Features';

  @override
  String get loading => 'Loading...';

  @override
  String get noVideos => 'No videos found';

  @override
  String get apply => 'Apply';

  @override
  String get noRecordsFound => 'No records found';

  @override
  String get selectDateRange => 'Select date range';

  @override
  String get notificationTypes => 'Notification types';

  @override
  String get motionSensed => 'Motion sensed';

  @override
  String get ignitionOff => 'Ignition off';

  @override
  String get ignitionOn => 'Ignition on';

  @override
  String get accidentDetected => 'Accident detected';

  @override
  String get stationaryFallDetected => 'Stationary fall detected';

  @override
  String get vehicleSwitchedOff => 'Vehicle switched off';

  @override
  String get vehicleSwitchedOn => 'Vehicle switched on';

  @override
  String get powerSupplyOn => 'Power supply on';

  @override
  String get vibrationSensed => 'Vibration sensed';

  @override
  String get editVehicle => 'Edit Vehicle';

  @override
  String get diesel => 'Diesel';

  @override
  String get cng => 'CNG';

  @override
  String get updateVehicle => 'Update Vehicle';

  @override
  String get vehicleMileage => 'Vehicle Mileage';

  @override
  String get notificationControls => 'Notification controls';

  @override
  String get changeNotificationPreferences =>
      'Change your notification preferences';

  @override
  String get unmapTrackify => 'Unmap your Trackify';

  @override
  String get unmapStep1 => 'Step 1: To un-map device, call at +918061971443';

  @override
  String get unmapStep2 => 'Step 2: Remove vehicle';

  @override
  String get updateMileage => 'Update Mileage';

  @override
  String get lastUpdated => 'Last updated: ';

  @override
  String get lockUnlockVehicle => 'Lock and Unlock Vehicle';

  @override
  String get sleepModeWarning =>
      'Your vehicle will not be Locked / Unlocked if the device is in sleep mode. ';

  @override
  String get journeyWithTrackify => 'Journey with Trackify';

  @override
  String get lifetime => 'Lifetime';

  @override
  String hrMinFormat(Object hr, Object min) {
    return '$hr hr $min min';
  }

  @override
  String get yourVehicleOnMap => 'Your vehicle on map';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get bike => 'Bike';

  @override
  String get scooty => 'Scooty';

  @override
  String get myVehicle => 'My Vehicle';

  @override
  String get selectColor => 'Select color';

  @override
  String get white => 'White';

  @override
  String get red => 'Red';

  @override
  String get aqua => 'Aqua';

  @override
  String get orange => 'Orange';

  @override
  String get sky => 'Sky';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get whatIsSleepMode => 'What is Sleep Mode?';

  @override
  String get sleepModeDesc1 =>
      'When the Trackify device doesn\'t detect any vibration or motion, it automatically enters sleep mode to save the vehicle\'s battery.';

  @override
  String get sleepModeDesc2 =>
      'The device instantly wakes up and begins tracking when it senses any motion and is in good network coverage.';

  @override
  String get hr => 'hr';

  @override
  String get min => 'min';

  @override
  String get filters => 'Filters';

  @override
  String get tankCapacityHint => 'e.g., 13';

  @override
  String get mileageHint => 'e.g., 50';

  @override
  String get powerSupplyOff => 'Power supply off';

  @override
  String get lastUpdatedLabel => 'Last updated: ';

  @override
  String get litresShort => 'L';

  @override
  String get discoverTrackifyFeatures => 'Discover Trackify Features';

  @override
  String get checkout => 'Checkout';

  @override
  String get address => 'Address';

  @override
  String get summary => 'Summary';

  @override
  String get pleaseEnterDetails => 'Please enter the details given below';

  @override
  String get fullName => 'Full Name';

  @override
  String get houseFloorLine => 'House, Floor, Line';

  @override
  String get landmark => 'Landmark';

  @override
  String get pinCode => 'Pin Code';

  @override
  String get homeAddress => 'Home Address';

  @override
  String get officeAddress => 'Office Address';

  @override
  String get product => 'Products';

  @override
  String get errorPickingImage => 'Error picking image';

  @override
  String get frontDocumentRequired => 'Front document image is required';

  @override
  String get documentUploadedSuccessfully => 'Document uploaded successfully';

  @override
  String get addAccessoryBill => 'Add Accessory Bill';

  @override
  String get accessoryName => 'Accessory Name';

  @override
  String get billingDate => 'Billing Date';

  @override
  String get shopName => 'Shop Name';

  @override
  String get shopContact => 'Shop Contact';

  @override
  String get uploadBill => 'Upload Bill';

  @override
  String get yearExtendedWarranty => '1 year extended warranty';

  @override
  String get paymentSummary => 'Payment Summary';

  @override
  String get boosterOffer => 'Booster offer @50% OFF';

  @override
  String get toPay => 'To Pay';

  @override
  String amountPayable(String amount) {
    return 'Amount Payable $amount';
  }

  @override
  String get distance => 'Distance';

  @override
  String get recentToOldest => 'Recent to Oldest';

  @override
  String get sorting => 'Sorting';

  @override
  String get backToDefault => 'Back to Default';

  @override
  String get sortBy => 'Sort By';

  @override
  String get duration => 'Duration';

  @override
  String get oldestToRecent => 'Oldest to Recent';

  @override
  String get longToShort => 'Long to Short';

  @override
  String get shortToLong => 'Short to Long';

  @override
  String get date => 'Date';

  @override
  String noTripsFound(String query) {
    return 'No trips found for \"$query\"';
  }

  @override
  String ridesCount(String count) {
    return '$count rides';
  }

  @override
  String get searchTrips => 'Search Trips';

  @override
  String get searchRides => 'Search Rides';

  @override
  String get notAvailable => 'N/A';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get yesImSure => 'Yes I\'m Sure';

  @override
  String get topSpeedLabel => 'Top Speed';

  @override
  String get rideDurationLabel => 'Ride Duration';

  @override
  String get editRides => 'Edit Rides';

  @override
  String get tripDetails => 'Trip Details';

  @override
  String get tripQuoteLabel => 'Trip Quote';

  @override
  String get unmerge => 'Unmerge';

  @override
  String get tripNameLabel => 'Trip Name';

  @override
  String get deleteTripConfirmation =>
      'This will permanently delete your trip. Are you sure you want to continue?';

  @override
  String get tripStats => 'Trip Stats';

  @override
  String get avgSpeedLabel => 'Avg Speed';

  @override
  String get tripQuoteDefault => 'Every trip has a story. Yours goes here.';

  @override
  String get deleteTrip => 'Delete Trip';

  @override
  String get hrLabel => 'hr';

  @override
  String ridesSelectedSummary(String count, String distance, String duration) {
    return '$count rides selected | $distance km • $duration';
  }

  @override
  String get clearSelection => 'Clear Selection';

  @override
  String get secLabel => 'sec';

  @override
  String get minLabel => 'min';

  @override
  String get selectionTooltipMessage =>
      'Select the rides you want to add to your trip.';

  @override
  String get selectRides => 'Select Rides';

  @override
  String get createTrip => 'Create Trip';

  @override
  String get bestAverageSpeed => 'Best average speed';

  @override
  String get topSpeedClocked => 'Top speed clocked';

  @override
  String get searchTripsHint => 'Search Trips by Name';

  @override
  String noRidesFound(String query) {
    return 'No rides found for \"$query\"';
  }

  @override
  String tripLabel(String number) {
    return 'Trip $number';
  }

  @override
  String get extraordinaryTrips => 'Extraordinary Trips';

  @override
  String get maxDistanceCovered => 'Max distance covered';

  @override
  String get searchRidesHint => 'Search Rides by City';

  @override
  String get healthInsurance => 'Health Insurance';

  @override
  String get bloodGroup => 'Blood Group';

  @override
  String get selectBloodGroup => 'Select Blood Group';

  @override
  String get healthInsuranceCardNumber => 'Health Insurance Card Number';

  @override
  String get policyNumber => 'Policy Number';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get editEmailAddress => 'Edit email address';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailNotVerified => 'Email not verified';

  @override
  String get saveAndVerify => 'Save & Verify';

  @override
  String get editMobileNumber => 'Edit mobile number';

  @override
  String get tenDigitMobileNumber => 'Ten digit mobile number';

  @override
  String get firstName => 'First name';

  @override
  String get middleName => 'Middle name';

  @override
  String get lastName => 'Last name';

  @override
  String get required => 'Required';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get optional => '(Optional)';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get selectState => 'Select State';

  @override
  String get selectCity => 'Select City';

  @override
  String get enterAddress => 'Enter Address (max 100 characters)';

  @override
  String get india => 'India';

  @override
  String get usa => 'USA';

  @override
  String get uk => 'UK';

  @override
  String get uae => 'UAE';

  @override
  String get madhyaPradesh => 'Madhya Pradesh';

  @override
  String get maharashtra => 'Maharashtra';

  @override
  String get rajasthan => 'Rajasthan';

  @override
  String get gujarat => 'Gujarat';

  @override
  String get karnataka => 'Karnataka';

  @override
  String get tamilNadu => 'Tamil Nadu';

  @override
  String get uttarPradesh => 'Uttar Pradesh';

  @override
  String get delhi => 'Delhi';

  @override
  String get indoreDistrict => 'Indore district';

  @override
  String get bhopal => 'Bhopal';

  @override
  String get gwalior => 'Gwalior';

  @override
  String get jabalpur => 'Jabalpur';

  @override
  String get ujjain => 'Ujjain';

  @override
  String get notificationSounds => 'Notification Sounds';

  @override
  String get changeSoundForNotification =>
      'Change sound for different Notification';

  @override
  String get vibrationAlert => 'Vibration Alerts';

  @override
  String get motionAlert => 'Motion Alert';

  @override
  String get ignitionAlert => 'Ignition Alerts';

  @override
  String get fallAlert => 'Fall Alerts';

  @override
  String get batteryAlert => 'Battery Alerts';

  @override
  String get geofenceAlert => 'Geofence Alerts';

  @override
  String get speedAlert => 'Speed Alerts';

  @override
  String get otherAlert => 'Other Alerts';

  @override
  String get customNotification => 'Custom Notifications';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get selectedPlan => 'Selected Plan';

  @override
  String get validity => 'Validity';

  @override
  String greatSaving(Object amount) {
    return 'Great! Saving ₹$amount with this plan';
  }

  @override
  String get billSummary => 'Bill Summary';

  @override
  String get planPrice => 'Plan Price';

  @override
  String get discount => 'Discount';

  @override
  String get total => 'Total';

  @override
  String get gstTaxes => 'GST (govt. taxes)';

  @override
  String payAmount(Object amount) {
    return 'Pay ₹$amount';
  }

  @override
  String get liveRecord => 'Live Record';

  @override
  String get history => 'History';

  @override
  String get stats => 'Stats';

  @override
  String get lastReportedPosition => 'Last Reported Position';

  @override
  String get time => 'Time';

  @override
  String get appUpdate => 'App Update';

  @override
  String get fuelStation => 'Fuel Station';

  @override
  String get change => 'Change';

  @override
  String get currentOdometer => 'Current Odometer (Km)';

  @override
  String get lastRecorded => 'Last Recorded: 32789km';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get pricePerLitre => 'Price / Litre';

  @override
  String get tankStatus => 'Tank Status';

  @override
  String get fullTank => 'Full tank';

  @override
  String get partialTank => 'Partial Tank';

  @override
  String get fuelBeforeRefuel => 'Fuel Before Refuel';

  @override
  String get liters => 'Liters';

  @override
  String get fuelBeforeRefuelDesc =>
      'Enter the estimated amount of fuel that was in the tank you refuelled.';

  @override
  String get savedSuccessfully => 'Saved Successfully';

  @override
  String get fuelStationName => 'C.M. Petro Point, BPCL petr...';

  @override
  String get yourPhoneLocation => 'Your Phone\'s Location';

  @override
  String get sharingActive => 'Sharing active';

  @override
  String get noActiveSharing => 'No active sharing';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get switchBetweenLightAndDarkThemes =>
      'Switch between light and dark themes';

  @override
  String get iHaveAnIssueWith => 'I have an issue with';

  @override
  String get iWantToProvideSuggestion => 'I want to provide a suggestion for';

  @override
  String get selectType => 'Select Type';

  @override
  String get whatIsSuggestionSubject =>
      'What is the subject of your suggestion?';

  @override
  String get giveShortDescription => 'Give short description';

  @override
  String get giveSuggestionFeedback =>
      'Give your suggestion/feedback (max 200 characters)';

  @override
  String get giveSuggestionFeedbackTitle => 'Give a suggestion/feedback';

  @override
  String get send => 'Send';

  @override
  String get bookCallSlotTitle => 'Book Call Slot';

  @override
  String get bookCallSlotHeading => 'Book Call Slot for Solving Your Issue';

  @override
  String get importantPoint => 'Important Point';

  @override
  String get callSlotDescription =>
      'You need to be next to your vehicle during the issue resolution. Please keep yourself free :)';

  @override
  String get selectDay => 'Select Day';

  @override
  String get selectTimeSlot => 'Select Time Slot';

  @override
  String get bookNow => 'Book now';

  @override
  String get slotUnavailable => 'Slot Unavailable';

  @override
  String get slotAvailable => 'Slot Available';

  @override
  String get distanceUnitSelection => 'Distance Unit';

  @override
  String get miles => 'Miles';

  @override
  String get locationSharedWithMe => 'Location shared with me';

  @override
  String get noOneSharedLocationTitle =>
      'No one has shared their vehicle\'s location with you right now';

  @override
  String get noOneSharedLocationSub =>
      'You\'ll find the names of individuals who have shared their location with you right here.';

  @override
  String get vehicleRemovedSuccessfully => 'Vehicle removed successfully';

  @override
  String get vehicleDetailsLabel => 'Vehicle Details';

  @override
  String get addOneMore => '..add 1 more';

  @override
  String removeVehicleNamed(String vehicleName, String vehicleNumber) {
    return 'Remove $vehicleName $vehicleNumber';
  }

  @override
  String get removeVehicleWarning =>
      'Warning: this cannot be undone. All your vehicle history will be deleted permanently.';

  @override
  String get removeVehicle => 'Remove Vehicle';

  @override
  String get removeVehicleConfirmDesc =>
      'Are you sure you want to remove this vehicle? This action cannot be undone.';

  @override
  String get removeBtn => 'Remove';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get buyFeatureComingSoon => 'Buy feature coming soon...';

  @override
  String get guest => 'Guest';

  @override
  String get vehicleLockedSuccessfully => 'Vehicle Locked successfully!';

  @override
  String get vehicleUnlockedSuccessfully => 'Vehicle Unlocked successfully!';

  @override
  String get failedToUpdateLockStatus => 'Failed to update lock status';

  @override
  String get registerNewVehicleDesc =>
      'Register a new Vehicle or Trackify Device';

  @override
  String get userSessionNotFound =>
      'User session not found. Please log in again.';

  @override
  String get comingSoonOption => 'Coming Soon';

  @override
  String get noDeviceFound => 'No device found';

  @override
  String get noVideosFound => 'No videos found';

  @override
  String get designOption => 'Design';

  @override
  String get functionalityOption => 'Functionality';

  @override
  String get otherOption => 'Other';

  @override
  String get allFieldsMandatory => 'ALL fields are mandatory';

  @override
  String get selectVehicleTypeForFuel =>
      'Select vehicle type to see fuel options';

  @override
  String get pleaseSelectFuelTypeFirst => 'Please select fuel type first';

  @override
  String get pleaseSelectVehicleMakeFirst => 'Please select vehicle make first';

  @override
  String get deleteFunctionalityComingSoon =>
      'Delete functionality coming soon';

  @override
  String get errorImeiNotFound => 'Error: IMEI not found';

  @override
  String get healthInsuranceSavedSuccess =>
      'Health insurance details saved successfully';

  @override
  String get noSlotsAvailable => 'No Slots Available';

  @override
  String get noIntroDataAvailable => 'No intro data available';

  @override
  String get retryBtn => 'Retry';

  @override
  String get areYouSureDeleteRefuelLog =>
      'Are you sure you want to delete this refuel log?';

  @override
  String get cancelBtn => 'Cancel';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get noAlertsCreated => 'No alerts created for this vehicle.';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordSubtitle =>
      'Change password & logout from all phones';

  @override
  String get currentSessions => 'Current sessions';

  @override
  String get manageLoggedInDevices => 'Manage logged-in devices';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountSubtitle => 'Delete your account permanently';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get confirmNewPasswordTitle => 'Confirm New Password';

  @override
  String get logoutOfAllDevices => 'Logout of all devices';

  @override
  String get otherDevices => 'Other devices';

  @override
  String get activeOnThisDevice => 'Active on this device';

  @override
  String get lastUsed => 'Last used -';

  @override
  String get osLabel => 'OS -';

  @override
  String get chromeNotificationDisabled => 'Chrome notification - disabled';

  @override
  String get logOut => 'Log out';

  @override
  String get hi => 'Hi';

  @override
  String get sorryToSeeYouGo => 'We\'re sorry to see you go.';

  @override
  String get note => 'Note:';

  @override
  String get deleteAccountNote1 =>
      'After 30 days, your account will be deleted permanently.';

  @override
  String get deleteAccountNote2 =>
      'You can reactivate the account within 30 Days by signing back.';

  @override
  String get deleteAccountExplanationPrompt =>
      'We would love to know why you are deleting your account, as we may be able to help with common issues. You can also just continue.';

  @override
  String get explanationOptionalHint =>
      'Your explanation is completely optional';

  @override
  String get deleteWarningPart1 =>
      'Your device will be unmapped, subscription will be ';

  @override
  String get terminated => 'terminated';

  @override
  String get deleteWarningPart2 =>
      ' and your all data will be lost from the server after 30 days of account deletion.';

  @override
  String get confirmDeleteAccount =>
      'Are you sure you want to delete your account?';

  @override
  String get expired => 'Expired';

  @override
  String daysLeftText(String days) {
    return '$days days left';
  }

  @override
  String get warrantyExpiringTitle => 'Warranty Expiring';

  @override
  String get warrantyExpiredDesc =>
      'Your device warranty has expired. Please renew your warranty to continue enjoying premium support and features.';

  @override
  String warrantyExpiringDesc(String days) {
    return 'Your device warranty will expire in $days day(s). Please renew it to avoid service interruption.';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get allTime => 'All Time';

  @override
  String get totalServices => 'Total Services';

  @override
  String get avgSpending => 'Avg Spending';

  @override
  String get perService => '/Service';

  @override
  String get avgInterval => 'Avg Interval';

  @override
  String get months => 'Months';

  @override
  String get deleteAlertTitle => 'Delete';

  @override
  String get deleteAlertDesc =>
      'Are you sure you want to delete this overspeed alert?';

  @override
  String get deleteServiceLogDesc =>
      'Are you sure you want to delete this service log?';

  @override
  String get serviceDetails => 'Service Details';

  @override
  String get amountText => 'Amount';

  @override
  String get unknownText => 'Unknown';

  @override
  String get notProvided => 'Not provided';

  @override
  String get contactCopied => 'Contact copied to clipboard';

  @override
  String get noImage => 'No Image';

  @override
  String get startTracking => 'Start Tracking';

  @override
  String get stopTracking => 'Stop Tracking';

  @override
  String get endRide => 'End Ride';

  @override
  String get maxSpeed => 'Max Speed';

  @override
  String get tapToResumeTracking => 'Tap to resume tracking';

  @override
  String get tapToPauseTracking => 'Tap to pause tracking';

  @override
  String get holdToStopTracking => 'Hold to stop tracking';

  @override
  String get exportLabel => 'Export';

  @override
  String get exportRide => 'Export Ride';

  @override
  String get shareRoute => 'Share Route';

  @override
  String get rideNameOptional => 'Ride Name (Optional)';

  @override
  String get rideNameHint => 'e.g., Morning Ride, Off-road trail';

  @override
  String get formatLabel => 'Format';

  @override
  String get gpxLabel => 'GPX';

  @override
  String get kmlLabel => 'KML';

  @override
  String get includeAnalytics => 'Include Analytics';

  @override
  String get includeAnalyticsDesc => 'Speed, elevation, etc.';

  @override
  String get exportingRide => 'Exporting ride...';

  @override
  String get shareRide => 'Share Ride';

  @override
  String get selectFormatToShare => 'Select a format to share your ride data';

  @override
  String get gpxFile => 'GPX File';

  @override
  String get gpxDesc =>
      'Standard GPS exchange format. Best for Strava, Garmin, etc.';

  @override
  String get kmlFile => 'KML File';

  @override
  String get kmlDesc => 'Keyhole Markup Language. Best for Google Earth.';

  @override
  String get imageScreenshot => 'Image (Screenshot)';

  @override
  String get imageScreenshotDesc => 'A beautiful map image with your route.';

  @override
  String get recordingInProgress => 'Recording in Progress';

  @override
  String get resumeTracking => 'Resume';

  @override
  String get discardRide => 'Discard Ride';

  @override
  String get discard => 'Discard';

  @override
  String get areYouSureDiscardRide =>
      'Are you sure you want to discard this ride?';

  @override
  String get kmhLabel => 'km/h';

  @override
  String get hrminLabel => 'hr:min';

  @override
  String get kmLabel => 'km';

  @override
  String get exportRideVideoDesc =>
      'Exported ride will be saved in Trackify Ride Videos folder of your Gallery app';

  @override
  String get chooseNicknameHint => 'Choose a unique nickname for this ride';

  @override
  String get myRideOnTrackify => 'My Ride on Trackify';

  @override
  String get locationAlwaysAccessWarning =>
      'Trackify ride recording feature only work correctly if it can access your location “all the time”';

  @override
  String get goToSettingsAndSelectAllowAllTheTime =>
      'Go to settings and select \"Allow all the time\"';

  @override
  String get locationPermissions => 'Location Permissions';

  @override
  String get allowAllTheTime => 'Allow all the time';

  @override
  String get onlyWhileUsingTheApp => 'Only while using the app';

  @override
  String get askEveryTime => 'Ask every time';

  @override
  String get dontAllow => 'Don\'t allow';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get selectRideMode => 'Select ride mode';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get continueBtn => 'Continue';

  @override
  String get selectRideLabel => 'Select a label for your ride';

  @override
  String get friendsVehicle => 'Friend\'s vehicle';

  @override
  String get train => 'Train';

  @override
  String get bus => 'Bus';

  @override
  String get auto => 'Auto';

  @override
  String get cab => 'Cab';

  @override
  String get cycle => 'Cycle';

  @override
  String get walk => 'Walk';

  @override
  String get others => 'Others';

  @override
  String get saveBtn => 'Save';

  @override
  String get startRideRecording => 'Start Ride Recording';

  @override
  String get stopRideRecording => 'Stop Ride Recording';

  @override
  String get saveOnline => 'Save online';

  @override
  String get saveOnlineDesc =>
      'Rides are saved online. You can login from any phone to fetch your past rides';

  @override
  String get saveOffline => 'Save offline';

  @override
  String get saveOfflineDesc => 'Rides are saved on this phone only';

  @override
  String get startRide => 'Start ride';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get rideOnLabel => 'Ride on';

  @override
  String get imageBtn => 'Image';

  @override
  String get videoLinkBtn => 'Video Link';

  @override
  String get avgLabel => 'AVG';

  @override
  String get meterLabel => 'M';

  @override
  String get recordViaPhoneTitle => 'Record via Phone';

  @override
  String get recordRidesTab => 'Record Rides';

  @override
  String get pastRidesTab => 'Past Rides';

  @override
  String get statisticsTab => 'Statistics';

  @override
  String get yourPhonesLocation => 'Your Phone\'s Location';

  @override
  String get justNow => 'Just now';

  @override
  String get hoursShort => 'h';

  @override
  String get exploreProducts => 'Explore Products';

  @override
  String get decideBestProductText => 'Not able to decide which product is';

  @override
  String get bestForYou => 'Best for you?';

  @override
  String get callUs => 'Call Us';

  @override
  String get happyTrackifyUsers => 'Happy Trackify Users';

  @override
  String get umeshDarwatkar => 'Umesh Darwatkar';

  @override
  String get umeshDarwatkarDuration => 'Trackify user from past 1 years';

  @override
  String get umeshDarwatkarReview =>
      'I highly recommend Trackify GPS device to anyone looking for a reliable and accurate navigation tool for bikes it has great features like Theft Detection, Accident Alert, Live Ride Sharing, Ride Recording & Fuel Tracking. Its easy to install & it Apps is very easy to use with lots of features.';

  @override
  String get rohitSharma => 'Rohit Sharma';

  @override
  String get rohitSharmaDuration => 'Trackify user from past 2 years';

  @override
  String get rohitSharmaReview =>
      'Using the device would like to highlight in movement tracking sharing it with the other people so that my friend can track me is the easiest way. The App is very responsive and useful.';

  @override
  String get peopleSmartIntro => 'people made their bike smart.\nExperience ';

  @override
  String get smartText => 'Smart ';

  @override
  String get featuresOfTrackify => 'features of Trackify 🏍️';

  @override
  String get accidentAlertCard => 'Accident alert';

  @override
  String get antiTheftAlertCard => 'Anti-Theft alert';

  @override
  String get liveGpsTrackingCard => 'Live GPS Tracking';

  @override
  String get chooseDeviceSuitsYou => 'Choose device which suits you well';

  @override
  String get lite => 'Lite';

  @override
  String get pro => 'Pro';

  @override
  String get go => 'Go';

  @override
  String get deviceSim => 'Device + Airtel/Vi SIM';

  @override
  String get ignitionOnOffAlert => 'Ignition ON/OFF Alert';

  @override
  String get tamperAlert => 'Tamper Alert';

  @override
  String get portable => 'Portable';

  @override
  String get replacementWarrantyMonths => 'Replacement Warranty\n(months)';

  @override
  String get trackifySmartGpsIot => 'Trackify Smart GPS IoT';

  @override
  String get monthAppSubscription => '12 Month App\nSubscription\n\n';

  @override
  String get simActivationCharges => 'SIM Activation Charges';

  @override
  String get selectProduct => 'Select Product';

  @override
  String usersBoughtProduct(String productName) {
    return '*31 users bought $productName yesterday';
  }

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get withText => 'with ';

  @override
  String buyNowForPrice(String price) {
    return 'Buy Now for ₹$price';
  }

  @override
  String get liveTracking => 'Live Tracking';

  @override
  String get googlePlay => 'Google Play';

  @override
  String get searchForItem => 'Search for an item...';

  @override
  String get completePersonalDetails => 'Complete Personal Details';

  @override
  String get personalDetailsDesc =>
      'Please provide these details before device installation.';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get requiredField => 'Required field';

  @override
  String get enterMobileNumber => 'Enter your mobile number';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get yourLocationLabel => 'Your location';

  @override
  String get deviceWarrantyExpired => 'Device warranty expired';

  @override
  String get receivedTrackifyDevicePrompt => 'Received your Trackify device?';

  @override
  String get fivePercentOffPromo => '5% off on buying from Trackify App';

  @override
  String get activateNow => 'Activate now';

  @override
  String get exploreExclusiveDeal => 'Explore Exclusive Deal';

  @override
  String get rechargePlan => 'Recharge Plan';

  @override
  String get rechargeExpired => 'Recharge expired';

  @override
  String get trackifyBrandLabel => 'TRACKIFY';

  @override
  String get hrMinLabel => 'hr:min';

  @override
  String get enterCustomTag => 'Enter custom tag';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get deleteAccountFailedNoUser =>
      'Failed to delete account: User ID not found.';

  @override
  String get deleteAccountSuccess => 'Account successfully deleted.';

  @override
  String errorDeletingAccount(String message) {
    return 'Error deleting account: $message';
  }

  @override
  String get invalidVehicleRegistrationNumber =>
      'Please enter a valid vehicle registration number.';

  @override
  String get cropImageTitle => 'Crop Image';

  @override
  String get pleaseEnterVehicleRegistrationNumber =>
      'Please enter a vehicle registration number.';

  @override
  String get vehicleRegNoRcHelpText =>
      'Enter your vehicle registration number as printed on the RC.';

  @override
  String get vehicleNumberHintAlternative => 'e.g. UP32AB1234';

  @override
  String get vehicleRegistrationNumberLabel => 'Vehicle Registration Number';

  @override
  String get notificationFallback => 'Notification';

  @override
  String get dateHeader => 'Date';

  @override
  String get timeHeader => 'Time';

  @override
  String get odometerHeader => 'Odometer';

  @override
  String get locationHeader => 'Location';

  @override
  String get amountHeader => 'Amount';

  @override
  String get rateHeader => 'Rate';

  @override
  String get litersHeader => 'Liters';

  @override
  String get mileageHeader => 'Mileage';

  @override
  String get downloadingStatus => 'Downloading...';

  @override
  String get downloadCsvButton => 'Download CSV';

  @override
  String get fileDownloadSuccess => 'File downloaded successfully!';

  @override
  String errorDownloadingFile(String error) {
    return 'Error downloading file: $error';
  }

  @override
  String get couldNotOpenFaq => 'Could not open FAQ';

  @override
  String get couldNotOpenTerms => 'Could not open Terms & Conditions';

  @override
  String get couldNotOpenPrivacy => 'Could not open privacy policy';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get pinsDoNotMatch => 'PINs do not match. Try again.';

  @override
  String get resetPinTitle => 'Reset PIN';

  @override
  String get resetPinDescription =>
      'Do you want to reset your PIN? This will clear the current PIN.';

  @override
  String get resetBtn => 'Reset';

  @override
  String get unlockVehiclePinTitle => 'Unlock Vehicle';

  @override
  String get lockVehiclePinTitle => 'Lock Vehicle';

  @override
  String get setNewPinTitle => 'Set New PIN';

  @override
  String get confirmNewPinTitle => 'Confirm New PIN';

  @override
  String get enterPinSubtitle => 'Enter your 4-digit PIN to proceed';

  @override
  String get createNewPinSubtitle => 'Create a 4-digit PIN for vehicle locking';

  @override
  String get confirmNewPinSubtitle => 'Re-enter your 4-digit PIN to confirm';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get noSavedRidesYet =>
      'No saved rides yet! Mark a ride as saved to add it here.';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get welcomeToTrackify => 'Welcome to Trackify!';

  @override
  String get thankYouForRegisteringDesc =>
      'Thank you for registering! Your account has been successfully created. Please sign in to access your dashboard and manage your vehicles.';

  @override
  String get continueToSignIn => 'Continue to Sign In';

  @override
  String get deviceNotInstalled => 'Device Not Installed';

  @override
  String deviceNotInstalledDesc(String vehicleName) {
    return 'Tracking device is not installed on $vehicleName. Please install a device to configure notification controls.';
  }

  @override
  String get noDevice => 'No Device';

  @override
  String get noDeviceNotificationBanner =>
      'No tracking device linked with this vehicle. Notification controls are disabled.';

  @override
  String get ok => 'OK';

  @override
  String get profile100PercentComplete => 'Your profile is 100% complete!';

  @override
  String get locationPermissionWarning =>
      'Sharing your phone\'s location works correctly only if it can access your location \"all the time\"';

  @override
  String get trackifyApp => 'Trackify';

  @override
  String get locationText => 'Location';

  @override
  String get tapIntoLocation => 'Tap into Location';

  @override
  String get goToSettingsBtn => 'Go to Settings';

  @override
  String get shareLiveLocationFor => 'Share your live location for';

  @override
  String get twoHours => '2 hours';

  @override
  String get fourHours => '4 hours';

  @override
  String get eightHours => '8 hours';

  @override
  String get untilStopped => 'Until Stopped';

  @override
  String get shareLocationLink => 'Share location link';

  @override
  String get documentNameText => 'Document Name';

  @override
  String get expiryDateText => 'Expiry Date';

  @override
  String get documentImagesText => 'Document Images';

  @override
  String get noImagesAvailableText => 'No images available';

  @override
  String get pdfDocumentText => 'PDF Document';

  @override
  String get deleteAlertDescription =>
      'Are you sure you want to delete this document?';

  @override
  String get deleteRideTitle => 'Delete Ride';

  @override
  String get deleteRideConfirmMessage =>
      'Are you sure you want to delete this ride record?';

  @override
  String get rideDeletedSuccess => 'Ride deleted successfully';

  @override
  String get onlineRideDeleteNotSupported =>
      'Online ride deletion not supported offline';

  @override
  String get rideDeleteFailedInvalidId => 'Ride deletion failed: Invalid ID';
}
