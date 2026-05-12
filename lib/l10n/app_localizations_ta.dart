// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get selectLanguage => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get letsGetStarted => 'தொடங்குவோம்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'மின்னஞ்சல் தேவை';

  @override
  String get passwordRequired => 'கடவுச்சொல் தேவை';

  @override
  String get invalidEmail => 'செல்லுபடியாகும் மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get forgotPassword => 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?';

  @override
  String get signIn => 'உள்நுழைய';

  @override
  String get or => 'அல்லது';

  @override
  String get dontHaveAccount => 'கணக்கு இல்லையா? ';

  @override
  String get signUp => 'பதிவு செய்யவும்';

  @override
  String welcome(String email) {
    return 'வரவேற்கிறோம் $email!';
  }

  @override
  String get loginFailed => 'உள்நுழைவு தோல்வியடைந்தது';

  @override
  String get name => 'பெயர்';

  @override
  String get nameHint => 'ஜான் டோ';

  @override
  String get nameRequired => 'பெயர் தேவை';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get mobileNumberHint => 'மொಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು உள்ளிடவும்';

  @override
  String get mobileNumberRequired => 'மொபைல் எண் தேவை';

  @override
  String get invalidMobileNumber => 'செல்லுபடியாகும் மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get country => 'நாடு';

  @override
  String get countryHint => 'நாட்டை உள்ளிடவும்';

  @override
  String get countryRequired => 'நாடு தேவை';

  @override
  String get state => 'மாநிலம்';

  @override
  String get stateHint => 'மாநிலத்தை உள்ளிடவும்';

  @override
  String get stateRequired => 'மாநிலம் தேவை';

  @override
  String get city => 'நகரம்';

  @override
  String get cityHint => 'நகரத்தை உள்ளிடவும்';

  @override
  String get cityRequired => 'நகரம் தேவை';

  @override
  String get selectProfileImage => 'சுயவிவரப் படத்தை மாற்றவும்';

  @override
  String get role => 'பங்கு';

  @override
  String get roleAdmin => 'நிர்வாகி';

  @override
  String get roleCustomer => 'வாடிக்கையாளர்';

  @override
  String get selectRoleHint => 'பங்கைத் தேர்ந்தெடுக்கவும்';

  @override
  String get roleRequired => 'தயவுசெய்து பங்கைத் தேர்ந்தெடுக்கவும்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கவும்';

  @override
  String get registerSuccess => 'பதிவு வெற்றிகரமாக முடிந்தது, உள்நுழையவும்';

  @override
  String get signUpFailed => 'பதிவு தோல்வியடைந்தது';

  @override
  String get otpSent => 'OTP வெற்றிகரமாக அனுப்பப்பட்டது';

  @override
  String get resetPassword => 'கடவுச்சொல்லை மீட்டமைக்கவும்';

  @override
  String get resetPasswordDesc =>
      'உங்கள் மின்னஞ்சலை உள்ளிடவும், மீட்டமைப்பு இணைப்பை அனுப்புவோம்.';

  @override
  String get sendResetLink => 'இணைப்பை அனுப்பு';

  @override
  String get otpVerified => 'OTP சரிபார்க்கப்பட்டது';

  @override
  String get verifyOtp => 'OTP சரிபார்க்கவும்';

  @override
  String get otpHeader => 'OTP சரிபார்ப்பு';

  @override
  String otpDesc(String email) {
    return '$email க்கு அனுப்பப்பட்ட OTP ஐ உள்ளிடவும்.';
  }

  @override
  String get otp => 'OTP';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'OTP தேவை';

  @override
  String get passwordResetSuccess => 'கடவுச்சொல் மீட்டமைக்கப்பட்டது';

  @override
  String get createNewPassword => 'புதிய கடவுச்சொல்லை உருவாக்கவும்';

  @override
  String get passwordDesc =>
      'புதிய கடவுச்சொல் பழையவற்றிலிருந்து வேறுபட்டிருக்க வேண்டும்.';

  @override
  String get newPassword => 'புதிய கடவுச்சொல்';

  @override
  String get newPasswordHint => 'புதிய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get passwordMinLength =>
      'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்துக';

  @override
  String get confirmPasswordHint => 'உறுதிப்படுத்துக';

  @override
  String get confirmPasswordRequired => 'உறுதிப்படுத்துதல் தேவை';

  @override
  String get passwordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get selectDevice => 'சாதனத்தைத் தேர்ந்தெடு';

  @override
  String get noDevicesFound => 'சாதனங்கள் எதுவும் இல்லை';

  @override
  String get proceed => 'தொடரவும்';

  @override
  String get unknownDevice => 'அறியப்படாத சாதனம்';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'சாதனங்களைப் பெற தொடங்கவும்';

  @override
  String get recordRide => 'பயணத்தை பதிவு செய்';

  @override
  String get phoneAsGps => 'உங்கள் போனைக் கருவியாக மாற்றவும்';

  @override
  String get goToDashboard => 'டாஷ்போர்டிற்குச் செல்க';

  @override
  String get seeFullMap => 'வரைபடத்தைப் பார்';

  @override
  String get exploreMore => 'மேலும் ஆராய்';

  @override
  String get reachMeSticker => 'ReachMe ஸ்டிக்கர்';

  @override
  String get products => 'தயாரிப்புகள்';

  @override
  String get fuelLogs => 'எரிபொருள் பதிவுகள்';

  @override
  String get locationSharing => 'இருப்பிடப் பகிர்வு';

  @override
  String get documentFolder => 'ஆவணக் கோப்புறை';

  @override
  String get voiceMonitoring => 'குரல் கண்காணிப்பு';

  @override
  String get remoteEngineOff => 'ரிமோட் எஞ்சின் ஆஃப்';

  @override
  String get networkBooster => 'நெட்வೊர்க் பூஸ்டர்';

  @override
  String get emergency => 'அவசரம்';

  @override
  String get overspeedAlert => 'அதிவேக எச்சரிக்கை';

  @override
  String get geoFenceAlert => 'ஜியோ-பென்ஸ் எச்சரிக்கை';

  @override
  String get more => 'மேலும்';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get bikeSmartMsg => '1000+ பேர் எங்கள் சாதனத்தைப் பயன்படுத்துகின்றனர்';

  @override
  String get features => 'அம்சங்கள்';

  @override
  String get contactUs => 'தொடர்பு கொள்க';

  @override
  String get contactUsDesc => 'நாங்கள் உதவ இங்கே இருக்கிறோம்';

  @override
  String get userReviews => 'பயனர் விமர்சனங்கள்';

  @override
  String get accidentAlert => 'விபத்து எச்சரிக்கை';

  @override
  String get antiTheftAlert => 'திருட்டு எச்சரிக்கை';

  @override
  String get geoFence => 'ஜியோ பென்ஸ்';

  @override
  String get statistics => 'புள்ளிவிவரங்கள்';

  @override
  String get myGarage => 'எனது கேரேஜ்';

  @override
  String get noVehiclesInGarage => 'வாகனங்கள் எதுவும் இல்லை';

  @override
  String get unknownVehicle => 'அறியப்படாத வாகனம்';

  @override
  String get status => 'நிலை';

  @override
  String get active => 'செயலில்';

  @override
  String get subscription => 'சந்தா';

  @override
  String get proPlan => 'புரோ திட்டம்';

  @override
  String get initializeGarage => 'கேரேஜைத் தொடங்கவும்';

  @override
  String get ourProducts => 'தயாரிப்புகள்';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'மேம்பட்ட கண்காணிப்பு';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'சாதாரண கண்காணிப்பு';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'அடிப்படை சாதனம்';

  @override
  String get realTime1s => 'ரியல்-டைம் 1செ கண்காணிப்பு';

  @override
  String get remoteEngineCutOff => 'எஞ்சின் நிறுத்தம்';

  @override
  String get detailedFuelAnalytics => 'எரிபொருள் பகுப்பாய்வு';

  @override
  String get realTime5s => 'ரியல்-டைம் 5செ கண்காணிப்பு';

  @override
  String get antiTheftAlerts => 'திருட்டு எச்சரிக்கைகள்';

  @override
  String get basicJourneyLogs => 'பயண பதிவுகள்';

  @override
  String get locationUpdates => 'இருப்பிட புதுப்பிப்புகள்';

  @override
  String get batteryMonitor => 'பேட்டரி மானிட்டர்';

  @override
  String get featuresLabel => 'அம்சங்கள்:';

  @override
  String addedToCart(String title) {
    return '$title கார்ட்டில் சேர்க்கப்பட்டது!';
  }

  @override
  String get buyNow => 'வாங்கு';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String errorMsg(String message) {
    return 'பிழை: $message';
  }

  @override
  String get addVehicle => 'வாகனத்தைச் சேர்';

  @override
  String get vehicleAdded => 'வாகனம் சேர்க்கப்பட்டது!';

  @override
  String get vehicleType => 'வாகன வகை';

  @override
  String get twoWheeler => 'இருசக்கர வாகனம்';

  @override
  String get fourWheeler => 'நான்கு சக்கர வாகனம்';

  @override
  String get autoRickshaw => 'ஆட்டோ ரிக்ஷா';

  @override
  String get heavyVehicle => 'கனரக வாகனம்';

  @override
  String get fuelType => 'எரிபொருள் வகை';

  @override
  String get petrol => 'பெட்ரோல்';

  @override
  String get electric => 'எலக்ட்ரிக்';

  @override
  String get vehicleImage => 'Vehicle Image';

  @override
  String get newLabel => 'NEW';

  @override
  String get vehicleMake => 'வாகன பிராண்ட்';

  @override
  String get vehicleModel => 'வாகன மாடல்';

  @override
  String get vehicleNumber => 'வாகன எண்';

  @override
  String get vehicleNumberHint => 'உதாரணமாக: MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'வாகன எண்ணை உள்ளிடவும்';

  @override
  String get selectMake => 'பிராண்டைத் தேர்ந்தெடு';

  @override
  String get selectModel => 'மாடலைத் தேர்ந்தெடு';

  @override
  String get installDevice => 'சாதனத்தை நிறுவு';

  @override
  String get installDeviceDesc => 'எளிமையான படிகளில் சாதனத்தை அமைக்கவும்';

  @override
  String get activateSticker => 'ஸ்டிக்கரைச் செயல்படுத்து';

  @override
  String get activateStickerDesc => 'ஸ்டிக்கரைச் செயல்படுத்த எளிய படிகள்';

  @override
  String get exploreFreeApp => 'இலவச ஆப்';

  @override
  String get exploreFreeAppDesc =>
      'எங்கள் இலவச ஆப் மூலம் பயணங்களை கண்காணிக்கவும்';

  @override
  String get logout => 'உள்நுழைவு விலகல்';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get dataPlan => 'டேட்டா திட்டம்';

  @override
  String get warranty => 'உத்தரவாதம்';

  @override
  String expiresInDays(String days) {
    return '$days நாட்களில் முடிவடைகிறது';
  }

  @override
  String get rechargeNow => 'ரீசார்ஜ் செய்க';

  @override
  String get renewNow => 'புதுப்பிக்கவும்';

  @override
  String get secureYourVehicle => 'வாகனத்தைப் பாதுகாக்கவும்';

  @override
  String get secureYourVehicleDesc =>
      'அடிப்படை கண்காணிப்புக்காக சாதனத்தை வாங்கவும்';

  @override
  String get boughtDeviceInstallNow => 'சாதனம் வாங்கினீர்களா? ';

  @override
  String get installNow => 'நிறுவு';

  @override
  String get buyTrackifyDevice => 'Trackify சாதனத்தை வாங்கவும்';

  @override
  String get lite4G => 'லைட் 4ஜி';

  @override
  String get swipeToLock => 'பூட்ட ஸ்வைப் செய்யவும்';

  @override
  String get upgradeToPlus => 'பிளஸ் திட்டத்திற்கு மாறு';

  @override
  String get getMoreOutOfTrackify =>
      'Trackify-லிருந்து கூடுதல் பலன்களைப் பெறுங்கள்';

  @override
  String featuresExploredCount(Object count, Object total) {
    return '$total இல் $count அம்சங்களை ஆராய்ந்துள்ளீர்கள்';
  }

  @override
  String get manageVehiclesDesc => 'வாகனங்களை நிர்வகி';

  @override
  String get settingsDesc => 'அமைப்புகள்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get noNotifications => 'அறிவிப்புகள் எதுவும் இல்லை';

  @override
  String get notificationsFetchedSuccessfully =>
      'அறிவிப்புகள் வெற்றிகரமாகப் பெறப்பட்டன';

  @override
  String get errorFetchingNotifications => 'அறிவிப்புகளைப் பெறுவதில் பிழை';

  @override
  String get helpAndSupport => 'உதவி';

  @override
  String get helpAndSupportDesc => 'உதவி மற்றும் ஆதரவு';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get searchForSettings => 'தேடு';

  @override
  String get backupAndRestore => 'பேக்கப்';

  @override
  String get backupAndRestoreDesc => 'தரவைச் சேமி';

  @override
  String get appSettings => 'ஆப் அமைப்புகள்';

  @override
  String get appSettingsDesc => 'விதிமுறைகள் மற்றும் அமைப்புகள்';

  @override
  String get notificationSettings => 'அறிவிப்பு அமைப்புகள்';

  @override
  String get notificationSettingsDesc => 'விருப்பங்கள்';

  @override
  String get privacy => 'தனியுரிமை';

  @override
  String get privacyDesc => 'கடவுச்சொல் மாற்றம்';

  @override
  String get rateUsOnPlayStore => 'எங்களை மதிப்பீடு செய்க';

  @override
  String get rateUsOnPlayStoreDesc => 'கருத்துக்களைப் பகிரவும்';

  @override
  String get logoutDesc => 'வெளியேறு';

  @override
  String get helpAndSuggestion => 'நிர்வாகம்';

  @override
  String get reportAnIssue => 'புகார் அளிக்கவும்';

  @override
  String get suggestion => 'சலுகை';

  @override
  String get whatIsYourIssueRelatedTo => 'உங்கள் பிரச்சனை என்ன?';

  @override
  String get shortDescriptionHint => 'சுருக்கமான விளக்கம்';

  @override
  String get selectCallSlot => 'நேரத்தைத் தேர்ந்தெடு';

  @override
  String get myIssues => 'எனது பிரச்சனைகள்';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get forceMigrate => 'தரவு மாற்றம்';

  @override
  String get forceMigrateDesc1 => 'தரவைச் சரிசெய்யவும்';

  @override
  String get forceMigrateDesc2 => 'இது உள்ளூர் தரவை மட்டுமே பாதிக்கும்';

  @override
  String get faq => 'கேள்விகள்';

  @override
  String get termsConditions => 'விதிமுறைகள்';

  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get changeLog => 'மாற்றங்கள்';

  @override
  String get todayLabel => '(இன்று)';

  @override
  String get ridingBehaviour => 'சவாரி நடத்தை';

  @override
  String get ridingBehaviourVacationDesc =>
      'நீங்கள் சவாரி எதையும் மேற்கொள்ளவில்லை';

  @override
  String get journey => 'பயணம்';

  @override
  String get distanceTravelled => 'பயணித்த தூரம்';

  @override
  String get timeDuration => 'பயண நேரம்';

  @override
  String get speed => 'வேகம்';

  @override
  String get averageSpeed => 'சராசரி வேகம்';

  @override
  String get topSpeed => 'அதிகபட்ச வேகம்';

  @override
  String get fuel => 'எரிபொருள்';

  @override
  String get fuelConsumed => 'எரிபொருள் பயன்பாடு';

  @override
  String get fuelCost => 'செலவு';

  @override
  String vsPreviousPeriod(String value) {
    return 'முந்தைய காலத்துடன் ஒப்பிடுகையில் $value%';
  }

  @override
  String get vehicleMakeListEmpty =>
      'இந்தத் தேர்வுக்கு வாகன பிராண்ட் பட்டியல் காலியாக உள்ளது';

  @override
  String get vehicleModelListEmpty =>
      'இந்தத் தேர்வுக்கு வாகன மாடல் பட்டியல் காலியாக உள்ளது';

  @override
  String get deviceInstallation => 'சாதன நிறுவல்';

  @override
  String get scanActivationCode => 'செயல்படுத்தும் குறியீட்டை ஸ்கேன் செய்யவும்';

  @override
  String get enterActivationCodeManually =>
      'செயல்படுத்தும் குறியீட்டை கைமுறையாக உள்ளிடவும்';

  @override
  String get openTrackifyBoxInstruction =>
      'செயல்படுத்தும் QR குறியீட்டிற்கு Trackify பெட்டியைத் திறக்கவும்.';

  @override
  String get continueText => 'தொடரவும்';

  @override
  String get enterUID => 'UID ஐ உள்ளிடவும்';

  @override
  String get enterIMEINumber => 'IMEI எண்ணை உள்ளிடவும்';

  @override
  String get close => 'மூடு';

  @override
  String get uidRequired => 'UID தேவை';

  @override
  String get imeiRequired => 'IMEI எண் தேவை';

  @override
  String get deviceAssignedSuccess =>
      'சாதனம் வெற்றிகரமாக வாகனத்துடன் இணைக்கப்பட்டது!';

  @override
  String get assigningDevice => 'சாதனம் இணைக்கப்படுகிறது...';

  @override
  String get invalidImeiError =>
      'தயவுசெய்து செல்லுபடியாகும் 15-இலக்க IMEI எண்ணை உள்ளிடவும்';

  @override
  String get sharedRides => 'பகிரப்பட்ட பயணங்கள்';

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
  String get skip => 'தவிர்';

  @override
  String get todayText => 'இன்று';

  @override
  String get distanceLabel => 'தூரம்';

  @override
  String get rideDuration => 'பயண கால அளவு';

  @override
  String get speedLabel => 'வேகம்';

  @override
  String get minutesShort => 'நி';

  @override
  String get secondsShort => 'வி';

  @override
  String get discoverMoreDesc =>
      'மேலும் பலவற்றை ಅನ್ವೇಷಿಸಿ — அருமையான விஷயங்கள் காத்திருக்கின்றன!';

  @override
  String get serviceLogs => 'சேவை பதிவுகள்';

  @override
  String get safeParking => 'பாதுகாப்பான நிறுத்தம்';

  @override
  String get appUpdates => 'செயலி புதுப்பிப்புகள்';

  @override
  String get deviceDataPlanLabel => 'சாதன தரவு திட்டம்';

  @override
  String get deviceWarrantyLabel => 'சாதன உத்தரவாதம்';

  @override
  String get videoTutorials => 'வீடியோ பயிற்சிகள்';

  @override
  String get exploreNow => 'இப்போது ஆராயுங்கள்';

  @override
  String get plusLabel => 'பிளஸ்';

  @override
  String get mapStyleLabel => 'வரைபட நடை';

  @override
  String get darkStyle => 'டார்க்';

  @override
  String get lightStyle => 'லைட்';

  @override
  String get simpleStyle => 'சிம்பிள்';

  @override
  String get satelliteStyle => 'சேட்டிலைட்';

  @override
  String get mapOptionsLabel => 'வரைபட விருப்பங்கள்';

  @override
  String get trafficLabel => 'போக்குவரத்து';

  @override
  String get labelsLabel => 'லேபிள்கள்';

  @override
  String get sharedWithMe => 'என்னுடன் பகிரப்பட்டது';

  @override
  String get todaysStats => 'இன்றைய புள்ளிவிவரங்கள்';

  @override
  String parkedSinceTime(String time) {
    return 'முதல் நிறுத்தப்பட்டுள்ளது: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return 'இன்னும் $value கிமீ தூரம் செல்ல வேண்டியுள்ளது';
  }

  @override
  String get recordViaPhone => 'தொலைபேசி வழியாகப் பதிவு செய்யவும்';

  @override
  String progressPercentage(String value) {
    return '$value%';
  }

  @override
  String labelColon(String label) {
    return '$label:';
  }

  @override
  String get fuelEmpty => 'இ';

  @override
  String get fuelFull => 'எஃப்';

  @override
  String get vehicleNamePlaceholder => 'SP 125';

  @override
  String get vehicleNumberPlaceholder => 'MP09QV8269';

  @override
  String get myProfile => 'எனது சுயவிவரம்';

  @override
  String get profileCompleteness => 'சுயவிவர நிறைவு';

  @override
  String lastUpdatedOn(String date) {
    return 'கடைசியாக $date அன்று புதுப்பிக்கப்பட்டது';
  }

  @override
  String get addProfilePicture => 'உங்கள் சுயவிவரப் படத்தைச் சேர்க்கவும்';

  @override
  String get personalDetails => 'தனிப்பட்ட விவரங்கள்';

  @override
  String get userNameLabel => 'பெயர்';

  @override
  String get emailAddressLabel => 'மின்னஞ்சல் முகவரி';

  @override
  String get mobileNumberLabel => 'மொபைல் எண்';

  @override
  String get countryLabel => 'நாடு';

  @override
  String get stateLabel => 'மாநிலம்';

  @override
  String get cityLabel => 'நகரம்';

  @override
  String get medicalInsuranceInfo => 'மருத்துவ காப்பீடு தகவல்';

  @override
  String get addMedicalInsuranceInfo => 'மருத்துவ காப்பீடு தகவலைச் சேர்க்கவும்';

  @override
  String get vehicleInsuranceInfo => 'வாகன காப்பீடு தகவல்';

  @override
  String get editViewVehicleInsuranceDesc =>
      'வாகன அமைப்புகளில் வாகன காப்பீடு விவரங்களைத் திருத்தவும் மற்றும் பார்க்கவும்.';

  @override
  String get myGarageVehiclePath => 'எனது கேரேஜ் > வாகனம்';

  @override
  String get emergencyContacts => 'அவசர தொடர்புகள்';

  @override
  String get addEditEmergencyContactDesc =>
      'வாகன அமைப்புகளில் அவசர தொடர்பு பட்டியலைச் சேர்க்கவும் மற்றும் திருத்தவும்.';

  @override
  String get smartContactSticker => 'ஸ்மார்ட் தொடர்பு ஸ்டிக்கர்';

  @override
  String get stickerSubtitle =>
      'உங்கள் வாகனத்தைப் பாதுகாப்பாகவும் புத்திசாலித்தனமாகவும் மாற்ற ஒரு படி முன்னே';

  @override
  String get activateContactSticker => 'தொடர்பு ஸ்டிக்கரைச் செயல்படுத்தவும்';

  @override
  String get buyNewContactSticker => 'புதிய தொடர்பு ஸ்டிக்கரை வாங்கவும்';

  @override
  String get beyondParkingProblems => 'பார்க்கிங் பிரச்சனைகளுக்கு அப்பால்';

  @override
  String get noParkings => 'பார்க்கிங் இல்லை';

  @override
  String get emergencies => 'அவசரநிலைகள்';

  @override
  String get vehicleTowing => 'வாகன டோயிಂಗ್';

  @override
  String get getInformedStayConnected =>
      'தகவல் பெறுங்கள் மற்றும் உங்கள் வாகனத்துடன்\nஇணைந்திருங்கள்';

  @override
  String get securedCalls => 'பாதுகாப்பான அழைப்புகள்';

  @override
  String get securedCallsDesc =>
      'இணையம்-மறைக்கப்பட்ட அழைப்புகள் - உங்கள் தொலைபேசி எண்ணைத் தனிப்பட்டதாக வைத்திருக்கும்.';

  @override
  String get notificationHistory => 'அறிவிப்பு வரலாறு';

  @override
  String get notificationHistoryDesc =>
      'தற்போதைய மற்றும் முந்தைய அனைத்து அறிவிப்புகளையும் கண்காணிக்கவும்';

  @override
  String get beInformed => 'தகவலுடன் இருங்கள்';

  @override
  String get beInformedDesc =>
      'யாராவது உங்கள் QR குறியீட்டை ஸ்கேன் செய்யும்போது உடனடியாகத் தெரிந்துகொள்ளுங்கள் மற்றும் அவர்கள் உங்களை அழைக்கும்போது உடனடி நடவடிக்கை எடுக்கவும்.';

  @override
  String get controlWhatOthersSee =>
      'மற்றவர்கள் எதைப் பார்க்கிறார்கள் என்பதைக் கட்டுப்படுத்தவும்';

  @override
  String get controlWhatOthersSeeDesc =>
      'யாராவது QR ஐ ஸ்கேன் செய்யும்போது காண்பிக்கப்படும் விவரங்களைத் தனிப்பயனாக்கவும்.';

  @override
  String get preventFrustrationDamage =>
      'ஏமாற்றம் மற்றும் சேதத்தைத் தடுக்கவும்';

  @override
  String get preventFrustrationDamageDesc =>
      'தவறான பார்க்கிங்கால் ஏற்படும் மோதல்கள் மற்றும் வாகன சேதத்தைத் தவிர்க்கவும்.';

  @override
  String get serviceLogsSubtitle =>
      'வாகன சேவையை ஒருபோதும் தவறவிடாதீர்கள். உங்கள் வாகனத்தை சிறந்த நிலையில் வைத்திருக்க நினைவூட்டல்களைப் பெறவும் மற்றும் செலவுகளைக் கண்காணிக்கவும்.';

  @override
  String get addServiceLogs => 'சேவை பதிவுகளைச் சேர்';

  @override
  String get uploadServicingBill => 'சேவை மசோதாவை பதிவேற்றவும்';

  @override
  String get addImage => 'படம் சேர்க்கவும்';

  @override
  String get maxFileSizeNote => 'குறிப்பு: அதிகபட்ச கோப்பு அளவு 5MB';

  @override
  String get serviceDate => 'சேவை தேதி';

  @override
  String get billingAmount => 'பில்லிங் தொகை';

  @override
  String get serviceCenterName => 'சேவை மையத்தின் பெயர்';

  @override
  String get serviceCenterContact => 'சேவை மைய தொடர்பு';

  @override
  String get additionalNote => 'கூடுதல் குறிப்பு';

  @override
  String get saveDetails => 'விவரங்களைச் சேமி';

  @override
  String get selectVehicle => 'வாகனத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get liveTab => 'நேரலை';

  @override
  String get historyTab => 'வரலாறு';

  @override
  String get liveLocationSharingActive =>
      'நேரலை இருப்பிடப் பகிர்வு செயலில் உள்ளது';

  @override
  String get noLiveLocationShared => 'நேரலை இருப்பிடம் எதுவும் பகிரப்படவில்லை';

  @override
  String get realTimeSharingDesc =>
      'உங்கள் இருப்பிடம் தேர்ந்தெடுக்கப்பட்ட தொடர்புகளுடன் நிகழ்நேரத்தில் பகிரப்படுகிறது.';

  @override
  String get startSharingPhoneDesc =>
      'மற்றவர்கள் உங்களைக் கண்காணிக்க உதவ உங்கள் தொலைபேசியின் இருப்பிடத்தைப் பகிரத் தொடங்குங்கள்';

  @override
  String get noHistoryAvailable => 'வரலாறு எதுவும் இல்லை';

  @override
  String get historyDesc =>
      'கடந்த இருப்பிடப் பகிர்வுகள் முடிந்ததும் இங்கே தோன்றும்.';

  @override
  String get stopSharing => 'பகிர்வதை நிறுத்து';

  @override
  String get shareLocation => 'இருப்பிடத்தைப் பகிர்';

  @override
  String get startSharing => 'பகிரத் தொடங்கு';

  @override
  String get phoneTracking => 'போன் டிராக்கிங்';

  @override
  String get liveRecordTab => 'நேரடி பதிவு';

  @override
  String get statsTab => 'புள்ளிவிவரங்கள்';

  @override
  String get timeLabel => 'நேரம்';

  @override
  String get weekly => 'வாராந்திர';

  @override
  String get monthly => 'மாதாந்திர';

  @override
  String get custom => 'தனிப்பயன்';

  @override
  String get quickStats => 'விரைவான புள்ளிவிவரங்கள்';

  @override
  String get totalRides => 'மொத்த சவாரிகள்';

  @override
  String get avgSpeed => 'சராசரி வேகம்';

  @override
  String get totalFuel => 'மொத்த எரிபொருள்';

  @override
  String get overallDistance => 'மொத்த தூரம்';

  @override
  String get drivingTime => 'ஓட்டுநர் நேரம்';

  @override
  String get safetyScore => 'பாதுகாப்பு மதிப்பெண்';

  @override
  String get speedAlertInput => 'வேக எச்சரிக்கை உள்ளீடு';

  @override
  String get alertTitle => 'எச்சரிக்கை தலைப்பு';

  @override
  String get speedLimitKmH => 'வேக வரம்பு (கிமீ/மணி)';

  @override
  String get timeDurationSec => 'நேர காலம் (வினாடி)';

  @override
  String get selectYourVehicle => 'உங்கள் வாகனத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get selectVehiclesOverspeedAlert =>
      'அதிக வேக எச்சரிக்கையை சேர்க்க வேண்டிய வாகனங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selected => 'தேர்ந்தெடுக்கப்பட்டது';

  @override
  String get sec => 'வினாடி';

  @override
  String get kmHr => 'கிமீ/மணி';

  @override
  String get viewMore => 'மேலும் பார்க்க';

  @override
  String get viewLess => 'குறைவாக பார்க்க';

  @override
  String get previousRides => 'முந்தைய சவாரிகள்';

  @override
  String get seeAll => 'அனைத்தையும் பார்க்க';

  @override
  String get videosYouMightLike => 'உங்களுக்குப் பிடிக்கக்கூடிய வீடியோக்கள்';

  @override
  String get scrollToTop => 'மேலே செல்லவும்';

  @override
  String get noRecentRidesFound => 'சமீಪத்திய சவாரிகள் எதுவும் கிடைக்கவில்லை';

  @override
  String get failedToLoadRides => 'சவாரிகளை ஏற்றுவதில் தோல்வி';

  @override
  String get hrMin => 'மணி:நிமிடம்';

  @override
  String get vehicleLabel => 'Vehicle';

  @override
  String get switchLabel => 'Switch';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get rechargePlans => 'Recharge Plans';

  @override
  String get superComboPlan => 'சூப்பர் காம்போ திட்டம்';

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
  String get extendedWarranty => 'நீட்டிக்கப்பட்ட உத்தரவாதம்';

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
  String get insurance => 'Insurance Details';

  @override
  String get puc => 'PUC Certificate';

  @override
  String get vehicleRCTitle => 'Vehicle RC';

  @override
  String get insuranceTitle => 'Insurance Details';

  @override
  String get pucTitle => 'PUC Certificate';

  @override
  String get notificationControlsTitle => 'ஒலி சமநிலை';

  @override
  String get ignitionOnOffTitle => 'Ignition ON/OFF';

  @override
  String get ignitionOnOffDesc =>
      'Get notified when vehicle ignition is turned ON or OFF';

  @override
  String get motionWithIgnitionOffTitle => 'Motion with Ignition OFF';

  @override
  String get motionWithIgnitionOffDesc =>
      'Get notified when vehicle is moving while ignition is OFF';

  @override
  String get powerSupplyOffTitle => 'Power Supply OFF';

  @override
  String get powerSupplyOffDesc =>
      'Get notified when Trackify is not receiving power';

  @override
  String get appNotification => 'App Notification';

  @override
  String get odometerReading => 'ஓடோமீட்டர் ரீடிங்';

  @override
  String get update => 'புதுப்பி';

  @override
  String get gpsReadingNote =>
      'GPS அடிப்படையிலான ரீடிங், சிறிய வித்தியாசம் இருக்கலாம்.';

  @override
  String get tankCapacity => 'டேங்க் கொள்ளளவு';

  @override
  String get afterLastRefuel => 'கடைசி எரிபொருள் நிரப்பலுக்குப் பிறகு';

  @override
  String get fuelRemaining => 'மீதமுள்ள எரிபொருள்';

  @override
  String get distanceRemaining => 'மீதமுள்ள தூரம்';

  @override
  String get mileageArai => 'மைலேஜ் (ARAI)';

  @override
  String get spendingOnFuel => 'எரிபொருள் செலவு';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'இந்த வாரம்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get thisYear => 'இந்த ஆண்டு';

  @override
  String get all => 'அனைத்தும்';

  @override
  String get customDates => 'தனிப்பயன் தேதிகள்';

  @override
  String get refuelHistory => 'எரிபொருள் வரலாறு';

  @override
  String get addRefuelingDetails => 'எரிபொருள் விவரங்களைச் சேர்க்கவும்';

  @override
  String get fuelStations => 'எரிபொருள் நிலையங்கள்';

  @override
  String get dashboard => 'டாஷ்போர்டு';

  @override
  String get litersShort => 'லி.';

  @override
  String get fuelEstimateNote =>
      'இந்த மதிப்புகள் உங்கள் எரிபொருள் உள்ளீடுகளின் அடிப்படையிலான மதிப்பீடுகள். சிறந்த துல்லியத்திற்கு எரிபொருள் பதிவுகளைத் தவறாமல் சேர்க்கவும்.';

  @override
  String get gotIt => 'புரிந்தது';

  @override
  String get currentOdometerReading => 'தற்போதைய ஓடோமீட்டர் ரீடிங்';

  @override
  String get odometerUpdateDesc =>
      'துல்லியமான எரிபொருள் மற்றும் தூர மதிப்பீடுகளுக்கு உங்கள் ஓடோமீட்டரைத் தவறாமல் புதுப்பிக்கவும்';

  @override
  String get updateTankCapacity => 'டேங்க் கொள்ளளவைப் புதுப்பிக்கவும்';

  @override
  String get tankCapacityDesc =>
      'உங்கள் வாகன டேங்கின் அதிகபட்ச எரிபொருள் கொள்ளளவை உள்ளிடவும்';

  @override
  String get litres => 'லிட்டர்';

  @override
  String get kms => 'கி.மீ';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get save => 'சேமிக்கவும்';

  @override
  String get updateMileageArai => 'மைலேஜைப் புதுப்பிக்கவும் (ARAI)';

  @override
  String get mileageDesc =>
      'ARAI தரநிலைகளின்படி உங்கள் வாகனத்தின் மைலேஜை உள்ளிடவும்';

  @override
  String get kmL => 'கி.மீ/லி';

  @override
  String get serviceLogAddedSuccess => 'சேவை பதிவு வெற்றிகரமாக சேர்க்கப்பட்டது';

  @override
  String get currencySymbol => '₹';

  @override
  String get refuelHistoryComingSoon => 'எரிபொருள் வரலாறு விரைவில் வரும்';

  @override
  String get fuelStationsComingSoon => 'எரிபொருள் நிலையங்கள் விரைவில் வரும்';

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String get totalFuelAdded => 'சேர்க்கப்பட்ட மொத்த எரிபொருள்';

  @override
  String get totalSpendings => 'மொத்த செலவுகள்';

  @override
  String get avgMileage => 'சராசரி மைலேஜ்';

  @override
  String get refuels => 'எரிபொருள் நிரப்பல்கள்';

  @override
  String get refuelingHistory => 'எரிபொருள் வரலாறு';

  @override
  String get newestFirst => 'புதியவை முதலில்';

  @override
  String get oldestFirst => 'பழையவை முதலில்';

  @override
  String get mostExpensive => 'மிகவும் விலை உயர்ந்தது';

  @override
  String get leastExpensive => 'குறைந்த விலை';

  @override
  String get bestMileage => 'சிறந்த மைலேஜ்';

  @override
  String get worstMileage => 'மோசமான மைಲೇಜ್';

  @override
  String get edit => 'திருத்து';

  @override
  String get delete => 'அழி';

  @override
  String get error => 'Something went wrong';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String hintEg(String value) {
    return 'உதாரணமாக: $value';
  }

  @override
  String get addStation => 'நிலையத்தைச் சேர்';

  @override
  String get nearby => 'அருகிலுள்ள';

  @override
  String get favourites => 'பிடித்தவை';

  @override
  String get addedByMe => 'என்னால் சேர்க்கப்பட்டது';

  @override
  String get noFavourites => 'இன்னும் பிடித்தவை எதுவும் இல்லை';

  @override
  String get noStationsAdded => 'இன்னும் நிலையங்கள் எதுவும் சேர்க்கப்படவில்லை';

  @override
  String get fuelStationNearVehicle =>
      'வாகனத்திற்கு அருகிலுள்ள எரிபொருள் நிலையம்';

  @override
  String get warranty_title => 'சாதன உத்தரவாதம்';

  @override
  String get warranty_benefitsTitle => 'நீங்கள் இழக்க விரும்பாத நன்மைகள்';

  @override
  String get warranty_extend =>
      'உங்கள் Trackify Lite உத்தரவாதத்தை 1 ஆண்டுக்கு நீட்டிக்கவும் @ ₹1/நாள்';

  @override
  String get warranty_vehicle => 'வாகனம்';

  @override
  String get warranty_expiry => 'உத்தரவாதம் காலாவதியாகும் தேதி';

  @override
  String get warranty_button => 'இப்போது உத்தரவாதத்தை நீட்டிக்கவும் @ ₹365 ';

  @override
  String get warranty_button_old => '₹730';

  @override
  String get benefit1_highlight => 'உத்தரவாதமான மாற்றீடு';

  @override
  String get benefit1_normal => ' செயலிழப்பு ஏற்பட்டால்';

  @override
  String get benefit2_highlight => '₹1200 வரை சேமிக்கவும்';

  @override
  String get benefit2_normal => ' சாதன பழுதுபார்ப்பில்';

  @override
  String get benefit3_highlight => 'உடனடி ஆதரவு';

  @override
  String get benefit3_normal => ' சாதன தொடர்பான சிக்கல்களுக்கு';

  @override
  String get benefit4_highlight => '₹2000 வரை இலவச நீட்டிக்கப்பட்ட சந்தா';

  @override
  String get benefit4_normal => ' தவறான காலத்திற்கு';

  @override
  String get initiatingEmergencyAlert =>
      'Trackify பயனர்களுக்கு அவசர எச்சரிக்கை அனுப்பப்படுகிறது';

  @override
  String get pleaseUseResponsibly => 'தயவுசெய்து பொறுப்புடன் பயன்படுத்தவும்';

  @override
  String get secondsBeforeSendingAlert =>
      'எச்சரிக்கை அனுப்புவதற்கு முன் விநாடிகள்';

  @override
  String get sendNow => 'இப்போது அனுப்பு';

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
  String get plusMembershipTitle => 'பிளஸ் மெம்பர்ஷிப்';

  @override
  String get membership => 'மெம்பர்ஷிப்';

  @override
  String get premiumBenefits => 'பிரீமியம் நன்மைகள்';

  @override
  String get otherBenefits => 'இதர நன்மைகள்';

  @override
  String get trackifyPlusReviews => 'டிராக்கிஃபை பிளஸ் மதிப்புரைகள்';

  @override
  String get offerings => 'வழங்குதல்கள்';

  @override
  String get plus => 'பிளஸ்';

  @override
  String get regular => 'வழக்கமான';

  @override
  String upgradeNowAtJust(String price) {
    return 'இப்போதே ₹$price விலையில் அப்கிரேட் செய்யுங்கள்';
  }

  @override
  String get viewMoreReviews => 'மேலும் மதிப்புரைகளைக் காண்க';

  @override
  String get speciallyForYou => 'உங்களுக்காக பிரத்யேகமாக';

  @override
  String get footerMotto =>
      'ஒவ்வொரு பைக்கும் ஸ்மார்ட்டாகவும், ஒவ்வொரு ரைடரும் பாதுகாப்பாகவும் இருக்கும்\nஎதிர்காலத்தை உருவாக்குதல்';

  @override
  String get cropDocument => 'Crop Document';

  @override
  String get cropVehicleImage => 'Crop Vehicle Image';

  @override
  String get uploadImage => 'படத்தை பதிவேற்றவும்';

  @override
  String get camera => 'கேமரா';

  @override
  String get gallery => 'கேலரி';

  @override
  String get pdf => 'PDF';

  @override
  String get fileTooLarge => 'File size exceeds 5MB';

  @override
  String get pickImageError => 'Error picking image';

  @override
  String get pickPdfError => 'Error picking PDF';

  @override
  String get pdfTooLarge => 'PDF size exceeds 5MB';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get frontSide => 'Front Side*';

  @override
  String get backSide => 'Back Side';

  @override
  String get commitmentText => 'Your Documents\nOur Commitment';

  @override
  String get documentsSafe => 'Your documents are encrypted and safe';

  @override
  String get addDocument => 'ஆவணம் சேர்க்கவும்';

  @override
  String get frontRequired => 'Front side document is required';

  @override
  String get successMessage => 'Document added successfully';

  @override
  String get selectExpiryDate => 'Select Expiry Date';

  @override
  String get documentsEncrypted => 'Your documents are encrypted & safe';

  @override
  String get fileSizeNote => 'Note: Max file size is 5MB';

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
  String get billsDescription =>
      'Add and set reminders for your vehicle servicing days, upload bills and more';

  @override
  String get movedTo => 'Moved to';

  @override
  String get viewNow => 'View Now';

  @override
  String get accessoryBills => 'Accessory Bills';

  @override
  String get tutorialVideos => 'பயிற்சி வீடியோக்கள்';

  @override
  String get videos => 'வீடியோக்கள்';

  @override
  String get location => 'இடம்';

  @override
  String get amazingFeatures => 'அற்புதமான அம்சங்கள்';

  @override
  String get loading => 'ஏற்றப்படுகிறது...';

  @override
  String get noVideos => 'வீடியோக்கள் இல்லை';

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
      'உங்கள் அறிவிப்பு விருப்பங்களை மாற்றவும்';

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
  String get lockUnlockVehicle => 'வாகனத்தைப் பூட்டு மற்றும் திறக்கவும்';

  @override
  String get sleepModeWarning =>
      'சாதனம் தூக்க பயன்முறையில் இருந்தால் உங்கள் வாகனம் பூட்டப்படாது / திறக்கப்படாது.';

  @override
  String get journeyWithTrackify => 'Trackify உடன் பயணம்';

  @override
  String get lifetime => 'வாழ்நாள்';

  @override
  String hrMinFormat(Object hr, Object min) {
    return '$hr மணி $min நிமிடம்';
  }

  @override
  String get yourVehicleOnMap => 'வரைபடத்தில் உங்கள் வாகனம்';

  @override
  String get selectIcon => 'ஐகானைத் தேர்ந்தெடுக்கவும்';

  @override
  String get bike => 'பைக்';

  @override
  String get scooty => 'ஸ்கூட்டி';

  @override
  String get myVehicle => 'எனது வாகனம்';

  @override
  String get selectColor => 'நிறத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get white => 'வெள்ளை';

  @override
  String get red => 'சிவப்பு';

  @override
  String get aqua => 'அக்வா';

  @override
  String get orange => 'ஆரஞ்சு';

  @override
  String get sky => 'வானம்';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமிக்கவும்';

  @override
  String get whatIsSleepMode => 'தூக்க பயன்முறை என்றால் என்ன?';

  @override
  String get sleepModeDesc1 =>
      'Trackify சாதனம் எந்த அதிர்வையும் அல்லது அசைவையும் கண்டறியாதபோது, வாகனத்தின் பேட்டரியைச் சேமிக்க அது தானாகவே தூக்க பயன்முறையில் நுழைகிறது.';

  @override
  String get sleepModeDesc2 =>
      'சாதனம் அசைவை உணரும்போது உடனடியாக விழித்தெழுந்து, நல்ல நெட்வொர்க் கவரேஜில் இருக்கும்போது கண்காணிக்கத் தொடங்கும்.';

  @override
  String get hr => 'மணி';

  @override
  String get min => 'நிமி';

  @override
  String get filters => 'வடிப்பான்கள்';

  @override
  String get tankCapacityHint => 'உதாரணமாக. 13';

  @override
  String get mileageHint => 'உதாரணமாக. 50';

  @override
  String get powerSupplyOff => 'மின்சாரம் நிறுத்தப்பட்டது';

  @override
  String get lastUpdatedLabel => 'கடைசியாக புதுப்பிக்கப்பட்டது: ';

  @override
  String get litresShort => 'லி';

  @override
  String get discoverTrackifyFeatures => 'Discover Trackify Features';

  @override
  String get checkout => 'செக்அவுட்';

  @override
  String get address => 'முகவரி';

  @override
  String get summary => 'சுருக்கம்';

  @override
  String get pleaseEnterDetails => 'கீழே உள்ள விவரங்களை உள்ளிடவும்';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get houseFloorLine => 'வீடு, மாடி, தெரு';

  @override
  String get landmark => 'அடையாளம்';

  @override
  String get pinCode => 'அஞ்சல் குறியீடு';

  @override
  String get homeAddress => 'வீட்டு முகவரி';

  @override
  String get officeAddress => 'அலுவலக முகவரி';

  @override
  String get product => 'தயாரிப்புகள்';

  @override
  String get errorPickingImage => 'Error picking image';

  @override
  String get frontDocumentRequired => 'Front document image is required';

  @override
  String get documentUploadedSuccessfully => 'Document uploaded successfully';

  @override
  String get addAccessoryBill => 'துணைக்கருவி பில் சேர்க்கவும்';

  @override
  String get accessoryName => 'துணைக்கருவி பெயர்';

  @override
  String get billingDate => 'பில்லிங் தேதி';

  @override
  String get shopName => 'கடை பெயர்';

  @override
  String get shopContact => 'கடை தொடர்பு';

  @override
  String get uploadBill => 'பில் பதிவேற்றவும்';

  @override
  String get yearExtendedWarranty => '1 ஆண்டு நீட்டிக்கப்பட்ட உத்தரவாதம்';

  @override
  String get paymentSummary => 'கட்டணச் சுருக்கம்';

  @override
  String get boosterOffer => 'பூஸ்டர் சலுகை @50% தள்ளுபடி';

  @override
  String get toPay => 'செலுத்த வேண்டியது';

  @override
  String amountPayable(String amount) {
    return 'செலுத்த வேண்டிய தொகை $amount';
  }

  @override
  String get distance => 'தூரம்';

  @override
  String get recentToOldest => 'புதியது முதல் பழையது வரை';

  @override
  String get sorting => 'வரிசைப்படுத்துதல்';

  @override
  String get backToDefault => 'இயல்புநிலைக்குத் திரும்பு';

  @override
  String get sortBy => 'இதன் மூலம் வரிசைப்படுத்து';

  @override
  String get duration => 'கால அளவு';

  @override
  String get oldestToRecent => 'பழையது முதல் புதியது வரை';

  @override
  String get date => 'தேதி';

  @override
  String noTripsFound(String query) {
    return '\"$query\" க்கான பயணங்கள் எதுவும் கிடைக்கவில்லை';
  }

  @override
  String ridesCount(String count) {
    return '$count சவாரிகள்';
  }

  @override
  String get searchTrips => 'பயணங்களைத் தேடுங்கள்';

  @override
  String get searchRides => 'சவாரிகளைத் தேடுங்கள்';

  @override
  String get notAvailable => 'கிடைப்பதில்லை';

  @override
  String get start => 'தொடங்கு';

  @override
  String get end => 'முடிவு';

  @override
  String get yesImSure => 'ஆம் எனக்கு நிச்சயமாக தெரியும்';

  @override
  String get topSpeedLabel => 'அதிக வேகம்';

  @override
  String get rideDurationLabel => 'சவாரி காலம்';

  @override
  String get editRides => 'சவாரிகளைத் திருத்தவும்';

  @override
  String get tripDetails => 'பயண விவரங்கள்';

  @override
  String get tripQuoteLabel => 'பயண மேற்கோள்';

  @override
  String get unmerge => 'பிரிக்கவும்';

  @override
  String get tripNameLabel => 'பயணத்தின் பெயர்';

  @override
  String get deleteTripConfirmation =>
      'இது உங்கள் பயணத்தை நிரந்தரமாக நீக்கிவிடும். தொடர விரும்புகிறீர்களா?';

  @override
  String get tripStats => 'பயண புள்ளிவிவரங்கள்';

  @override
  String get avgSpeedLabel => 'சராசரி வேகம்';

  @override
  String get tripQuoteDefault =>
      'ஒவ்வொரு பயணத்திற்கும் ஒரு கதை உண்டு. உங்களுடையது இங்கே.';

  @override
  String get deleteTrip => 'பயணத்தை நீக்கு';

  @override
  String get hrLabel => 'மணி';

  @override
  String ridesSelectedSummary(String count, String distance, String duration) {
    return '$count சவாரிகள் தேர்ந்தெடுக்கப்பட்டுள்ளன | $distance கிமீ • $duration';
  }

  @override
  String get clearSelection => 'தேர்வை நீக்கு';

  @override
  String get secLabel => 'விநாடி';

  @override
  String get minLabel => 'நிமிடம்';

  @override
  String get selectionTooltipMessage =>
      'உங்கள் பயணத்தில் சேர்க்க விரும்பும் சவாரிகளைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get selectRides => 'சவாரிகளைத் தேர்ந்தெடுக்கவும்';

  @override
  String get createTrip => 'பயணத்தை உருவாக்கவும்';

  @override
  String get bestAverageSpeed => 'சிறந்த சராசரி வேகம்';

  @override
  String get topSpeedClocked => 'பதிவு செய்யப்பட்ட அதிகபட்ச வேகம்';

  @override
  String get searchTripsHint => 'பெயரால் பயணங்களைத் தேடுங்கள்';

  @override
  String noRidesFound(String query) {
    return '\"$query\" க்கான சவாரிகள் எதுவும் கிடைக்கவில்லை';
  }

  @override
  String tripLabel(String number) {
    return 'பயணம் $number';
  }

  @override
  String get extraordinaryTrips => 'அசாதாரண பயணங்கள்';

  @override
  String get maxDistanceCovered => 'கடந்து சென்ற அதிகபட்ச தூரம்';

  @override
  String get searchRidesHint => 'நகரத்தின் மூலம் சவாரிகளைத் தேடுங்கள்';

  @override
  String get healthInsurance => 'சுகாதார காப்பீடு';

  @override
  String get bloodGroup => 'இரத்த வகை';

  @override
  String get selectBloodGroup => 'இரத்த வகையை தேர்ந்தெடுக்கவும்';

  @override
  String get healthInsuranceCardNumber => 'சுகாதார காப்பீட்டு அட்டை எண்';

  @override
  String get policyNumber => 'பாலிசி எண்';

  @override
  String get profileUpdatedSuccessfully =>
      'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get editEmailAddress => 'மின்னஞ்சல் முகவரியைத் திருத்தவும்';

  @override
  String get emailAddress => 'மின்னஞ்சல் முகவரி';

  @override
  String get emailNotVerified => 'மின்னஞ்சல் சரிபார்க்கப்படவில்லை';

  @override
  String get saveAndVerify => 'சேமித்து சரிபார்க்கவும்';

  @override
  String get editMobileNumber => 'மொபைல் எண்ணைத் திருத்தவும்';

  @override
  String get tenDigitMobileNumber => 'பத்து இலக்க மொபைல் எண்';

  @override
  String get firstName => 'முதல் பெயர்';

  @override
  String get middleName => 'நடுத்தர பெயர்';

  @override
  String get lastName => 'கடைசி பெயர்';

  @override
  String get required => 'தேவை';

  @override
  String get dateOfBirth => 'பிறந்த தேதி';

  @override
  String get optional => '(விருப்பத்தேர்வு)';

  @override
  String get selectCountry => 'நாட்டைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectState => 'மாநிலத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectCity => 'நகரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get enterAddress => 'முகவரியை உள்ளிடவும் (அதிகபட்சம் 100 எழுத்துகள்)';

  @override
  String get india => 'இந்தியா';

  @override
  String get usa => 'அமெரிக்கா';

  @override
  String get uk => 'இங்கிலாந்து';

  @override
  String get uae => 'யுஏஇ';

  @override
  String get madhyaPradesh => 'மத்திய பிரதேசம்';

  @override
  String get maharashtra => 'மகாராஷ்டிரா';

  @override
  String get rajasthan => 'ராஜஸ்தான்';

  @override
  String get gujarat => 'குஜராத்';

  @override
  String get karnataka => 'கர்நாடகா';

  @override
  String get tamilNadu => 'தமிழ்நாடு';

  @override
  String get uttarPradesh => 'உத்தர பிரதேசம்';

  @override
  String get delhi => 'டெல்லி';

  @override
  String get indoreDistrict => 'இந்தோர் மாவட்டம்';

  @override
  String get bhopal => 'போபால்';

  @override
  String get gwalior => 'குவாலியர்';

  @override
  String get jabalpur => 'ஜபல்பூர்';

  @override
  String get ujjain => 'உஜ்ஜெயின்';

  @override
  String get notificationSounds => 'அறிவிப்பு ஒலிகள்';

  @override
  String get changeSoundForNotification =>
      'வேறு அறிவிப்பிற்கான ஒலியை மாற்றவும்';

  @override
  String get vibrationAlert => 'அதிர்வு எச்சரிக்கைகள்';

  @override
  String get motionAlert => 'இயக்கு எச்சரிக்கை';

  @override
  String get ignitionAlert => 'இயக்கு எச்சரிக்கைகள்';

  @override
  String get fallAlert => 'விழும் எச்சரிக்கைகள்';

  @override
  String get batteryAlert => 'பேட்டரி எச்சரிக்கைகள்';

  @override
  String get geofenceAlert => 'ஜியோபென்ஸ் எச்சரிக்கைகள்';

  @override
  String get speedAlert => 'வேகம் எச்சரிக்கைகள்';

  @override
  String get otherAlert => 'பிற எச்சரிக்கைகள்';

  @override
  String get customNotification => 'தனிப்பயன் அறிவிப்புகள்';

  @override
  String get orderSummary => 'ஆர்டர் சுருக்கம்';

  @override
  String get selectedPlan => 'தேர்ந்தெடுக்கப்பட்ட திட்டம்';

  @override
  String get validity => 'செல்லுபடியாகும் காலம்';

  @override
  String greatSaving(Object amount) {
    return 'அருமை! இந்த திட்டத்தில் ₹$amount சேமிக்கிறீர்கள்';
  }

  @override
  String get billSummary => 'பில் சுருக்கம்';

  @override
  String get planPrice => 'திட்ட விலை';

  @override
  String get discount => 'தள்ளுபடி';

  @override
  String get total => 'மொத்தம்';

  @override
  String get gstTaxes => 'GST (அரசு வரிகள்)';

  @override
  String payAmount(Object amount) {
    return '₹$amount செலுத்தவும்';
  }
}
