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
  String get mobileNumber => 'மொಬೈಲ್ ಸಂಖ್ಯೆ';

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
  String get retry => 'மீண்டும் முயற்சி';

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
  String get buyAjjasDevice => 'சாதனத்தை வாங்கு';

  @override
  String get lite4G => 'லைட் 4ஜி';

  @override
  String get swipeToLock => 'பூட்ட ஸ்வைப் செய்யவும்';

  @override
  String get upgradeToPlus => 'பிளஸ் திட்டத்திற்கு மாறு';

  @override
  String get getMoreOutOfAjjas => 'அதிக பலன்களைப் பெறு';

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
  String get openAjjasBoxInstruction =>
      'செயல்படுத்தும் QR குறியீட்டிற்கு Ajjas பெட்டியைத் திறக்கவும்.';

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
  String get skip => 'Skip';

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
  String get getMoreOutOfTrackify =>
      'Trackify-லிருந்து கூடுதல் பலன்களைப் பெறுங்கள்';

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
  String get buyTrackifyDevice => 'Trackify சாதனத்தை வாங்கவும்';

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
  String get addImage => 'படம் சேர்';

  @override
  String get maxFileSizeNote => 'குறிப்பு: அதிகபட்ச கோப்பு அளவு 5MB ஆகும்';

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
  String get gotIt => 'சரி';

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
  String get cancel => 'ரத்துசெய்';

  @override
  String get save => 'சேமி';

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
}
