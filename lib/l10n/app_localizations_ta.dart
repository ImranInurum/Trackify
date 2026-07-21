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
  String get locationSharing => 'இடம் பகிர்வு';

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
  String get vehicleImage => 'வாகனப் படம்';

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
  String expiresInDays(int days) {
    return '$days நாட்களில் காலாவதியாகிறது';
  }

  @override
  String get rechargeNow => 'ரீசார்ஜ் செய்க';

  @override
  String get renewNow => 'இப்போது புதுப்பிக்கவும்';

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
  String get whatIsYourIssueRelatedTo => 'உங்கள் பிரச்சனை எதனைப் பற்றியது?';

  @override
  String get shortDescriptionHint => 'சுருக்கமான விளக்கம்';

  @override
  String get selectCallSlot => 'நேரத்தைத் தேர்ந்தெடு';

  @override
  String get myIssues => 'எனது பிரச்சனைகள்';

  @override
  String get mySuggestions => 'என் பரிந்துரைகள்';

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
  String get savedRides => 'சேமிக்கப்பட்ட பயணங்கள்';

  @override
  String get allRides => 'அனைத்து பயணங்கள்';

  @override
  String get trips => 'பயணங்கள்';

  @override
  String clicked(String value) {
    return '$value கிளிக் செய்யப்பட்டது';
  }

  @override
  String get noDailyRides => 'காட்ட தினசரி பயணங்கள் இல்லை';

  @override
  String get getStartedFirstRide =>
      'உங்கள் முதல் பயணத்தை தொடங்கி ஆரம்பிக்கவும்';

  @override
  String get durationLabel => 'காலம்';

  @override
  String get km => 'கிமீ';

  @override
  String get kmh => 'கிமீ/மணி';

  @override
  String get tripEmptyQuote =>
      '“உங்கள் பயணங்களை டிரிப்களாக குழுவாக்கி, நினைவுகளை சேர்த்து, பயணத்தை மீண்டும் அனுபவிக்கவும்”';

  @override
  String ridesCompletedCount(String completed, String total) {
    return 'முடிக்கப்பட்ட பயணங்கள்: $completed/$total';
  }

  @override
  String get unlockTripsRequirement =>
      'டிரிப்களை திறக்க குறைந்தது 3 பயணங்கள் தேவை';

  @override
  String get createNewTrip => 'புதிய டிரிப் உருவாக்கவும்';

  @override
  String get startByCreatingTrip => 'புதிய டிரிப் உருவாக்கி தொடங்கவும்';

  @override
  String get skip => 'தவிர்';

  @override
  String get todayText => 'இன்று';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get rideDuration => 'பயண கால அளவு';

  @override
  String get speedLabel => 'Speed';

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
  String get mobileNumberLabel => 'கைபேசி எண்';

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
  String get phoneTracking => 'தொலைபேசி கண்காணிப்பு';

  @override
  String get liveRecordTab => 'நேரடி பதிவு';

  @override
  String get statsTab => 'புள்ளிவிவரங்கள்';

  @override
  String get timeLabel => 'Time';

  @override
  String get weekly => 'வாராந்திரம்';

  @override
  String get monthly => 'மாதாந்திரம்';

  @override
  String get custom => 'தனிப்பயன்';

  @override
  String get quickStats => 'விரைவு புள்ளிவிவரங்கள்';

  @override
  String get totalRides => 'மொத்த பயணங்கள்';

  @override
  String get avgSpeed => 'சராசரி வேகம்';

  @override
  String get totalFuel => 'மொத்த எரிபொருள்';

  @override
  String get overallDistance => 'மொத்த தூரம்';

  @override
  String get drivingTime => 'ஓட்டும் நேரம்';

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
  String get vehicleLabel => 'வாகனம்';

  @override
  String get switchLabel => 'சுவிட்ச்';

  @override
  String get expiryDate => 'காலாவதி தேதி';

  @override
  String get rechargePlans => 'ரீசார்ஜ் திட்டங்கள்';

  @override
  String get superComboPlan => 'சூப்பர் காம்போ திட்டம்';

  @override
  String get month12Validity => '12-மாத செல்லுபடியாகும்';

  @override
  String get month6Validity => '6-மாத செல்லுபடியாகும்';

  @override
  String saveAmount(Object amount) {
    return 'இந்தத் திட்டத்தில் ₹$amount சேமிக்கவும்';
  }

  @override
  String get superComboPopularity =>
      '95% பயனர்கள் சூப்பர் காம்போ திட்டத்தைத் தேர்ந்தெடுக்கிறார்கள்';

  @override
  String get appSimRecharge => 'ஆப் மற்றும் சிம் ரீசார்ஜ்';

  @override
  String get extendedWarranty => 'நீட்டிக்கப்பட்ட உத்தரவாதம்';

  @override
  String get plusMembership => 'பிளஸ் மெம்பர்ஷிப்';

  @override
  String get continueSuperCombo => 'சூப்பர் காம்போ திட்டத்துடன் தொடரவும்';

  @override
  String get continue12Month => '12-மாத திட்டத்துடன் தொடரவும்';

  @override
  String get continue6Month => '6-மாத திட்டத்துடன் தொடரவும்';

  @override
  String get vehicleDocumentsTitle => 'வாகன ஆவணங்கள்';

  @override
  String get personalDocumentsSubtitle =>
      'உங்கள் வாகன ஆவணங்களை பதிவேற்றி எப்போதும் கையில் வைத்திருங்கள்';

  @override
  String get vehicleRC => 'வாகன RC';

  @override
  String get insurance => 'காப்பீடு';

  @override
  String get puc => 'PUC';

  @override
  String get vehicleRCTitle => 'வாகன RC';

  @override
  String get insuranceTitle => 'காப்பீட்டு விவரங்கள்';

  @override
  String get pucTitle => 'PUC சான்றிதழ்';

  @override
  String get notificationControlsTitle => 'அறிவிப்பு கட்டுப்பாடுகள்';

  @override
  String get ignitionOnOffTitle => 'இக்னிஷன் ஆன்/ஆஃப்';

  @override
  String get ignitionOnOffDesc =>
      'வாகன இக்னிஷன் ஆன் அல்லது ஆஃப் ஆகும்போது அறிவிப்பு பெறவும்';

  @override
  String get motionWithIgnitionOffTitle => 'இக்னிஷன் ஆஃப் உடன் இயக்கம்';

  @override
  String get motionWithIgnitionOffDesc =>
      'இக்னிஷன் ஆஃப் நிலையில் வாகனம் நகரும்போது அறிவிப்பு பெறவும்';

  @override
  String get powerSupplyOffTitle => 'மின்சாரம் நிறுத்தப்பட்டது';

  @override
  String get powerSupplyOffDesc =>
      'Trackify க்கு மின்சாரம் வரவில்லை என்றால் அறிவிப்பு பெறவும்';

  @override
  String get appNotification => 'ஆப் அறிவிப்பு';

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
  String get today => 'இன்று';

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
  String get addRefuelingDetails =>
      'எரிபொருள் நிரப்புதல் விவரங்களைச் சேர்க்கவும்';

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
  String get validityLabel => 'செல்லுபடியாகும் காலம்';

  @override
  String get plusGst => '+ GST';

  @override
  String get currentPlan => 'தற்போதைய திட்டம்';

  @override
  String get vehicle => 'வாகனம்';

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
  String get error => 'ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get noDataAvailable => 'தரவு எதுவும் இல்லை';

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
  String get geoFenceTitle => 'ஜியோ-பென்ஸ்';

  @override
  String geoFenceRadius(String radius) {
    return 'ஆரம்: $radiusமீ';
  }

  @override
  String get geoFenceLocating => 'இருப்பிடத்தைக் கண்டறிகிறது...';

  @override
  String get geoFenceNameRequired => 'ஜியோ-பென்ஸ் பெயரை உள்ளிடவும்';

  @override
  String get geoFenceSaveSuccess => 'ஜியோ-பென்ஸ் வெற்றிகரமாக சேமிக்கப்பட்டது!';

  @override
  String get geoFenceSearchHint => 'இருப்பிடத்தைத் தேடு...';

  @override
  String get geoFenceSelectType => 'ஜியோ-பென்ஸ் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get geoFenceTypeHome => 'வீடு';

  @override
  String get geoFenceTypeOffice => 'அலுவலகம்';

  @override
  String get geoFenceTypeFamily => 'குடும்பம்';

  @override
  String get geoFenceTypeParking => 'பார்க்கிங்';

  @override
  String get geoFenceTypeOthers => 'மற்றவை';

  @override
  String get geoFenceNameFieldHint =>
      'ஜியோ-பென்ஸ் பெயரை உள்ளிடவும், எ.கா: வீடு';

  @override
  String get geoFenceAddSmsContacts =>
      'SMS எச்சரிக்கைக்கு தொடர்புகளைச் சேர்க்கவும்';

  @override
  String get geoFenceEmptyStateDesc =>
      'வரைபடத்தில் ஒரு வட்டத்தை வரையவும், பைக் வட்டத்திற்குள் நுழையும்போது அல்லது வெளியேறும்போது எச்சரிக்கை பெறவும்.';

  @override
  String get addGeoFenceButton => 'ஜியோ-பென்ஸ் சேர்';

  @override
  String get safeParkingTitle => 'பாதுகாப்பான பார்க்கிங்';

  @override
  String get schedule => 'கால அட்டவணை';

  @override
  String get setupSafeParking => 'பாதுகாப்பான பார்க்கிங்கை அமைக்கவும்';

  @override
  String get safeParkingSubtitle =>
      'இன்ஜின் ஆன் மற்றும் இழுத்துச் செல்லும்போது அழைப்பு எச்சரிக்கைகளைப் பெறவும்';

  @override
  String get activate => 'செயல்படுத்து';

  @override
  String get activated => 'செயல்படுத்தப்பட்டது';

  @override
  String get safeParkingDescription =>
      'இன்ஜின் ஆன் செய்யும்போது அல்லது இழுத்துச் செல்லும்போது எச்சரிக்கைகளை இயக்கவும்';

  @override
  String get geoFenceDeleteConfirmation =>
      'இந்த ஜியோ-பென்ஸை நீக்க விரும்புகிறீர்களா?';

  @override
  String get geoFenceTurnOffConfirmation =>
      'இந்த ஜியோ-பென்ஸை அணைக்க விரும்புகிறீர்களா?';

  @override
  String get turnOff => 'அணைக்கவும்';

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
  String get cropDocument => 'ஆவணத்தை வெட்டுக';

  @override
  String get cropVehicleImage => 'வாகன படத்தை வெட்டுக';

  @override
  String get uploadImage => 'படத்தை பதிவேற்றுக';

  @override
  String get camera => 'கேமரா';

  @override
  String get gallery => 'கேலரி';

  @override
  String get pdf => 'PDF';

  @override
  String get fileTooLarge => 'கோப்பு அளவு 5MB வரம்பை மீறுகிறது';

  @override
  String get pickImageError => 'படத்தை தேர்வு செய்வதில் பிழை';

  @override
  String get pickPdfError => 'PDF தேர்வு செய்வதில் பிழை';

  @override
  String get pdfTooLarge => 'PDF அளவு 5MB வரம்பை மீறுகிறது';

  @override
  String get uploadDocuments => 'ஆவணங்களை பதிவேற்றுக';

  @override
  String get frontSide => 'முன்பக்கம்';

  @override
  String get backSide => 'பின்பக்கம்';

  @override
  String get commitmentText =>
      'உங்கள் தனியுரிமையை பாதுகாக்கவும் உங்கள் ஆவணங்களை பாதுகாப்பாக வைத்திருக்கவும் நாங்கள் உறுதியாக உள்ளோம்.';

  @override
  String get documentsSafe => 'உங்கள் ஆவணங்கள் எங்களுடன் பாதுகாப்பாக உள்ளன';

  @override
  String get addDocument => 'ஆவணம் சேர்க்கவும்';

  @override
  String get frontRequired => 'முன்பக்க ஆவணம் அவசியம்';

  @override
  String get successMessage => 'ஆவணம் வெற்றிகரமாக சேமிக்கப்பட்டது';

  @override
  String get selectExpiryDate => 'காலாவதி தேதியை தேர்வு செய்யவும்';

  @override
  String get documentsEncrypted =>
      'உங்கள் ஆவணங்கள் குறியாக்கம் செய்யப்பட்டு பாதுகாப்பாக உள்ளன';

  @override
  String get fileSizeNote => 'குறிப்பு: அதிகபட்ச கோப்பு அளவு 5MB';

  @override
  String get personalDocumentsTitle => 'தனிப்பட்ட ஆவணங்கள்';

  @override
  String get drivingLicense => 'ஓட்டுநர் உரிமம்';

  @override
  String get drivingLicenseTitle => 'ஓட்டுநர் உரிமம்';

  @override
  String get otherDocuments => 'மற்ற ஆவணங்கள்';

  @override
  String get otherDocumentTitle => 'மற்ற ஆவணங்கள்';

  @override
  String get documentName => 'ஆவண பெயர்*';

  @override
  String get billsTitle => 'பில்கள்';

  @override
  String get billsDescription =>
      'உங்கள் வாகன தொடர்பான பில்களை பதிவேற்றி நிர்வகிக்கவும்';

  @override
  String get movedTo => 'நகர்த்தப்பட்டது';

  @override
  String get viewNow => 'இப்போது பார்க்கவும்';

  @override
  String get accessoryBills => 'அக்சஸரி பில்கள்';

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
  String get apply => 'விண்ணப்பி';

  @override
  String get noRecordsFound => 'பதிவுகள் எதுவும் இல்லை';

  @override
  String get selectDateRange => 'தேதி வரம்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get notificationTypes => 'அறிவிப்பு வகைகள்';

  @override
  String get motionSensed => 'அசைவு கண்டறியப்பட்டது';

  @override
  String get ignitionOff => 'இக்னிஷன் ஆஃப்';

  @override
  String get ignitionOn => 'இக்னிஷன் ஆன்';

  @override
  String get accidentDetected => 'விபத்து கண்டறியப்பட்டது';

  @override
  String get stationaryFallDetected => 'நிலையான வீழ்ச்சி கண்டறியப்பட்டது';

  @override
  String get vehicleSwitchedOff => 'வாகனம் அணைக்கப்பட்டது';

  @override
  String get vehicleSwitchedOn => 'வாகனம் இயக்கப்பட்டது';

  @override
  String get powerSupplyOn => 'பவர் சப்ளை ஆன்';

  @override
  String get vibrationSensed => 'அதிர்வு கண்டறியப்பட்டது';

  @override
  String get editVehicle => 'வாகனத்தைத் திருத்து';

  @override
  String get diesel => 'டீசல்';

  @override
  String get cng => 'சிஎன்ஜி';

  @override
  String get updateVehicle => 'வாகனத்தைப் புதுப்பிக்கவும்';

  @override
  String get vehicleMileage => 'வாகன மைலேஜ்';

  @override
  String get notificationControls => 'அறிவிப்பு கட்டுப்பாடுகள்';

  @override
  String get changeNotificationPreferences =>
      'உங்கள் அறிவிப்பு விருப்பங்களை மாற்றவும்';

  @override
  String get unmapTrackify => 'உங்கள் Trackify ஐ அன்மேப் செய்யவும்';

  @override
  String get unmapStep1 =>
      'படி 1: சாதனத்தை அன்மேப் செய்ய, +918061971443 ஐ அழைக்கவும்';

  @override
  String get unmapStep2 => 'படி 2: வாகனத்தை அகற்றவும்';

  @override
  String get updateMileage => 'மைலேஜைப் புதுப்பிக்கவும்';

  @override
  String get lastUpdated => 'கடைசியாக புதுப்பிக்கப்பட்டது: ';

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
  String get discoverTrackifyFeatures => 'Trackify அம்சங்களைக் கண்டறியவும்';

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
  String get errorPickingImage => 'படத்தைத் தேர்ந்தெடுப்பதில் பிழை';

  @override
  String get frontDocumentRequired => 'முன்பக்க ஆவணப் படம் தேவை';

  @override
  String get documentUploadedSuccessfully =>
      'ஆவணம் வெற்றிகரமாக பதிவேற்றப்பட்டது';

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
  String get longToShort => 'நீண்டதிலிருந்து குறுகியது';

  @override
  String get shortToLong => 'குறுகியதிலிருந்து நீண்டது';

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
  String get notAvailable => 'கிடைக்கவில்லை';

  @override
  String get start => 'தொடக்கம்';

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
  String get avgSpeedLabel => 'Avg Speed';

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

  @override
  String get liveRecord => 'நேரடி பதிவு';

  @override
  String get history => 'வரலாறு';

  @override
  String get stats => 'புள்ளிவிவரங்கள்';

  @override
  String get lastReportedPosition => 'கடைசியாக பதிவான இடம்';

  @override
  String get time => 'நேரம்';

  @override
  String get appUpdate => 'ஆப் புதுப்பிப்பு';

  @override
  String get fuelStation => 'எரிபொருள் நிலையம்';

  @override
  String get change => 'மாற்று';

  @override
  String get currentOdometer => 'தற்போதைய ஓடோமீட்டர் (கிமீ)';

  @override
  String get lastRecorded => 'கடைசியாக பதிவு: 32789 கிமீ';

  @override
  String get totalAmount => 'மொத்த தொகை';

  @override
  String get pricePerLitre => 'ஒரு லிட்டரின் விலை';

  @override
  String get tankStatus => 'டேங்க் நிலை';

  @override
  String get fullTank => 'முழு டேங்க்';

  @override
  String get partialTank => 'பகுதி டேங்க்';

  @override
  String get fuelBeforeRefuel => 'எரிபொருள் நிரப்புவதற்கு முன்';

  @override
  String get liters => 'லிட்டர்கள்';

  @override
  String get fuelBeforeRefuelDesc =>
      'நீங்கள் எரிபொருள் நிரப்புவதற்கு முன் டேங்கில் இருந்த எரிபொருளின் மதிப்பிடப்பட்ட அளவை உள்ளிடவும்.';

  @override
  String get savedSuccessfully => 'வெற்றிகரமாக சேமிக்கப்பட்டது';

  @override
  String get fuelStationName => 'சி.எம். பெட்ரோ பாயிண்ட், பிபிசிஎல் பெட்ரோ...';

  @override
  String get yourPhoneLocation => 'உங்கள் தொலைபேசியின் இருப்பிடம்';

  @override
  String get sharingActive => 'பகிர்வு செயல்பாட்டில் உள்ளது';

  @override
  String get noActiveSharing => 'செயலில் உள்ள பகிர்வு இல்லை';

  @override
  String get darkMode => 'டார்க் மோடு';

  @override
  String get lightTheme => 'லைட் தீம்';

  @override
  String get switchBetweenLightAndDarkThemes =>
      'லைட் மற்றும் டார்க் தீம்களுக்கு இடையில் மாற்றவும்';

  @override
  String get iHaveAnIssueWith => 'இந்த விஷயத்தில் எனக்கு பிரச்சனை உள்ளது';

  @override
  String get iWantToProvideSuggestion =>
      'இதற்காக நான் ஒரு பரிந்துரை வழங்க விரும்புகிறேன்';

  @override
  String get selectType => 'வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get whatIsSuggestionSubject => 'உங்கள் பரிந்துரையின் பொருள் என்ன?';

  @override
  String get giveShortDescription => 'சுருக்கமான விளக்கம் அளிக்கவும்';

  @override
  String get giveSuggestionFeedback =>
      'உங்கள் பரிந்துரை/கருத்தை வழங்கவும் (அதிகபட்சம் 200 எழுத்துகள்)';

  @override
  String get giveSuggestionFeedbackTitle => 'பரிந்துரை/கருத்து வழங்கவும்';

  @override
  String get send => 'அனுப்பு';

  @override
  String get bookCallSlotTitle => 'அழைப்பு நேரத்தை பதிவு செய்யவும்';

  @override
  String get bookCallSlotHeading =>
      'உங்கள் பிரச்சினையை தீர்க்க அழைப்பு நேரத்தை பதிவு செய்யவும்';

  @override
  String get importantPoint => 'முக்கிய குறிப்பு';

  @override
  String get callSlotDescription =>
      'பிரச்சினை தீர்க்கும் போது நீங்கள் உங்கள் வாகனத்தின் அருகில் இருக்க வேண்டும். தயவுசெய்து உங்களை காலியாக வைத்திருங்கள் :)';

  @override
  String get selectDay => 'நாளை தேர்ந்தெடுக்கவும்';

  @override
  String get selectTimeSlot => 'நேர இடைவெளியை தேர்ந்தெடுக்கவும்';

  @override
  String get bookNow => 'இப்போது பதிவு செய்யவும்';

  @override
  String get slotUnavailable => 'நேரம் கிடைக்கவில்லை';

  @override
  String get slotAvailable => 'நேரம் கிடைக்கிறது';

  @override
  String get distanceUnitSelection => 'தூர அலகு';

  @override
  String get miles => 'மைல்';

  @override
  String get locationSharedWithMe => 'என்னிடம் பகிரப்பட்ட இருப்பிடம்';

  @override
  String get noOneSharedLocationTitle =>
      'தற்போது யாரும் தங்கள் வாகனத்தின் இருப்பிடத்தை உங்களுடன் பகிரவில்லை';

  @override
  String get noOneSharedLocationSub =>
      'உங்களுடன் இருப்பிடத்தைப் பகிர்ந்தவர்களின் பெயர்களை இங்கே காணலாம்.';

  @override
  String get vehicleRemovedSuccessfully => 'வாகனம் வெற்றிகரமாக அகற்றப்பட்டது';

  @override
  String get vehicleDetailsLabel => 'வாகன விவரங்கள்';

  @override
  String get addOneMore => '..மேலும் 1 சேர்';

  @override
  String removeVehicleNamed(String vehicleName, String vehicleNumber) {
    return '$vehicleName $vehicleNumber ஐ அகற்று';
  }

  @override
  String get removeVehicleWarning =>
      'எச்சரிக்கை: இதை செயல்தவிர்க்க முடியாது. உங்கள் அனைத்து வாகன வரலாறும் நிரந்தரமாக அழிக்கப்படும்.';

  @override
  String get removeVehicle => 'வாகனத்தை அகற்று';

  @override
  String get removeVehicleConfirmDesc =>
      'இந்த வாகனத்தை உறுதியாக அகற்ற விரும்புகிறீர்களா? இந்த செயலை செயல்தவிர்க்க முடியாது.';

  @override
  String get removeBtn => 'அகற்று';

  @override
  String get fieldRequired => 'இந்த புலம் அவசியம்';

  @override
  String get buyFeatureComingSoon => 'வாங்கும் அம்சம் விரைவில் வரும்...';

  @override
  String get guest => 'விருந்தினர்';

  @override
  String get vehicleLockedSuccessfully => 'வாகனம் வெற்றிகரமாக பூட்டப்பட்டது!';

  @override
  String get vehicleUnlockedSuccessfully =>
      'வாகனம் வெற்றிகரமாக திறக்கப்பட்டது!';

  @override
  String get failedToUpdateLockStatus =>
      'பூட்டு நிலையை புதுப்பிக்க முடியவில்லை';

  @override
  String get registerNewVehicleDesc =>
      'புதிய வாகனம் அல்லது Trackify சாதனத்தை பதிவு செய்யவும்';

  @override
  String get userSessionNotFound =>
      'பயனர் அமர்வு கிடைக்கவில்லை. மீண்டும் உள்நுழையவும்.';

  @override
  String get comingSoonOption => 'விரைவில்';

  @override
  String get noDeviceFound => 'எந்த சாதனமும் காணப்படவில்லை';

  @override
  String get noVideosFound => 'வீடியோ எதுவும் காணப்படவில்லை';

  @override
  String get designOption => 'வடிவமைப்பு';

  @override
  String get functionalityOption => 'செயல்பாடு';

  @override
  String get otherOption => 'மற்றவை';

  @override
  String get allFieldsMandatory => 'அனைத்து புலங்களும் கட்டாயம்';

  @override
  String get selectVehicleTypeForFuel =>
      'எரிபொருள் விருப்பங்களைக் காண வாகன வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectFuelTypeFirst =>
      'தயவுசெய்து முதலில் எரிபொருள் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectVehicleMakeFirst =>
      'தயவுசெய்து முதலில் வாகன தயாரிப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get deleteFunctionalityComingSoon => 'நீக்கும் அம்சம் விரைவில் வரும்';

  @override
  String get errorImeiNotFound => 'பிழை: IMEI காணப்படவில்லை';

  @override
  String get healthInsuranceSavedSuccess =>
      'சுகாதார காப்பீட்டு விவரங்கள் வெற்றிகரமாக சேமிக்கப்பட்டன';

  @override
  String get noSlotsAvailable => 'ஸ்லாட்டுகள் எதுவும் கிடைக்கவில்லை';

  @override
  String get noIntroDataAvailable => 'அறிமுக தரவு கிடைக்கவில்லை';

  @override
  String get retryBtn => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get areYouSureDeleteRefuelLog =>
      'இந்த எரிபொருள் பதிவை நிச்சயமாக நீக்க விரும்புகிறீர்களா?';

  @override
  String get cancelBtn => 'ரத்துசெய்';

  @override
  String get uploadFailed => 'பதிவேற்றம் தோல்வியடைந்தது';

  @override
  String get noAlertsCreated =>
      'இந்த வாகனத்திற்கு விழிப்பூட்டல்கள் எதுவும் உருவாக்கப்படவில்லை.';

  @override
  String get changePasswordTitle => 'கடவுச்சொல்லை மாற்றவும்';

  @override
  String get changePasswordSubtitle =>
      'கடவுச்சொல்லை மாற்றி அனைத்து போன்களிலிருந்தும் வெளியேறவும்';

  @override
  String get currentSessions => 'தற்போதைய அமர்வுகள்';

  @override
  String get manageLoggedInDevices => 'உள்நுழைந்துள்ள சாதனங்களை நிர்வகிக்கவும்';

  @override
  String get deleteAccountTitle => 'கணக்கை நீக்கு';

  @override
  String get deleteAccountSubtitle => 'உங்கள் கணக்கை நிரந்தரமாக நீக்கவும்';

  @override
  String get oldPassword => 'பழைய கடவுச்சொல்';

  @override
  String get confirmNewPasswordTitle => 'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get logoutOfAllDevices => 'அனைத்து சாதனங்களிலிருந்தும் வெளியேறவும்';

  @override
  String get otherDevices => 'பிற சாதனங்கள்';

  @override
  String get activeOnThisDevice => 'இந்த சாதனத்தில் செயலில் உள்ளது';

  @override
  String get lastUsed => 'கடைசியாக பயன்படுத்தியது -';

  @override
  String get osLabel => 'OS -';

  @override
  String get chromeNotificationDisabled => 'குரோம் அறிவிப்பு - முடக்கப்பட்டது';

  @override
  String get logOut => 'வெளியேறு';

  @override
  String get hi => 'வணக்கம்';

  @override
  String get sorryToSeeYouGo =>
      'நீங்கள் செல்வதைப் பார்த்து நாங்கள் வருந்துகிறோம்.';

  @override
  String get note => 'குறிப்பு:';

  @override
  String get deleteAccountNote1 =>
      '30 நாட்களுக்குப் பிறகு, உங்கள் கணக்கு நிரந்தரமாக நீக்கப்படும்.';

  @override
  String get deleteAccountNote2 =>
      'மீண்டும் உள்நுழைவதன் மூலம் 30 நாட்களுக்குள் கணக்கை மீண்டும் செயல்படுத்தலாம்.';

  @override
  String get deleteAccountExplanationPrompt =>
      'நீங்கள் ஏன் உங்கள் கணக்கை நீக்குகிறீர்கள் என்பதை அறிய விரும்புகிறோம், ஏனெனில் பொதுவான பிரச்சனைகளுக்கு நாங்கள் உதவலாம். நீங்கள் தொடர்ந்து செல்லவும் முடியும்.';

  @override
  String get explanationOptionalHint =>
      'உங்கள் விளக்கம் முற்றிலும் விருப்பத்திற்குரியது';

  @override
  String get deleteWarningPart1 => 'உங்கள் சாதனம் மேப் செய்யப்படாது, சந்தா ';

  @override
  String get terminated => 'ரத்து செய்யப்படும்';

  @override
  String get deleteWarningPart2 =>
      ' மற்றும் கணக்கு நீக்கப்பட்ட 30 நாட்களுக்குப் பிறகு சர்வவிலிருந்து உங்கள் எல்லா தரவும் இழக்கப்படும்.';

  @override
  String get confirmDeleteAccount => 'உங்கள் கணக்கை நீக்க விரும்புகிறீர்களா?';

  @override
  String get expired => 'காலாவதியானது';

  @override
  String daysLeftText(String days) {
    return '$days நாட்கள் மீதமுள்ளன';
  }

  @override
  String get warrantyExpiringTitle => 'உத்தரவாதம் முடிவடைகிறது';

  @override
  String get warrantyExpiredDesc =>
      'உங்கள் சாதனத்தின் உத்தரவாதம் காலாவதியாகிவிட்டது. பிரீமியம் ஆதரவு மற்றும் அம்சங்களைத் தொடர்ந்து அனுபவிக்க, உங்கள் உத்தரவாதத்தைப் புதுப்பிக்கவும்.';

  @override
  String warrantyExpiringDesc(String days) {
    return 'உங்கள் சாதனத்தின் உத்தரவாதம் $days நாட்களில் முடிவடையும். சேவை தடங்கலைத் தவிர்க்க இதைப் புதுப்பிக்கவும்.';
  }

  @override
  String get dismiss => 'நிராகரி';

  @override
  String get allTime => 'எல்லா நேரமும்';

  @override
  String get totalServices => 'மொத்த சேவைகள்';

  @override
  String get avgSpending => 'சராசரி செலவு';

  @override
  String get perService => '/சேவை';

  @override
  String get avgInterval => 'சராசரி இடைவெளி';

  @override
  String get months => 'மாதங்கள்';

  @override
  String get deleteAlertTitle => 'எச்சரிக்கையை நீக்கு';

  @override
  String get deleteAlertDesc =>
      'இந்த அதிக வேக எச்சரிக்கையை உறுதியாக நீக்க விரும்புகிறீர்களா?';

  @override
  String get deleteServiceLogDesc =>
      'இந்த சேவை பதிவை உறுதியாக நீக்க விரும்புகிறீர்களா?';

  @override
  String get serviceDetails => 'சேவை விவரங்கள்';

  @override
  String get amountText => 'தொகை';

  @override
  String get unknownText => 'தெரியாத';

  @override
  String get notProvided => 'வழங்கப்படவில்லை';

  @override
  String get contactCopied => 'தொடர்பு நகலெடுக்கப்பட்டது';

  @override
  String get noImage => 'படம் இல்லை';

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
  String get kmLabel => 'கிமீ';

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
      'Go to settings and select “Allow all the time”';

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
  String get exploreProducts => 'தயாரிப்புகளை ஆராயுங்கள்';

  @override
  String get decideBestProductText => 'எந்த தயாரிப்பு உங்களுக்கு';

  @override
  String get bestForYou => 'சிறந்தது என்று தீர்மானிக்க முடியவில்லையா?';

  @override
  String get callUs => 'எங்களை அழையுங்கள்';

  @override
  String get happyTrackifyUsers => 'மகிழ்ச்சியான ட்ராக்கிஃபை பயனர்கள்';

  @override
  String get umeshDarwatkar => 'உமேஷ் தர்வத்கர்';

  @override
  String get umeshDarwatkarDuration => 'கடந்த 1 வருடமாக ட்ராக்கிஃபை பயனர்';

  @override
  String get umeshDarwatkarReview =>
      'பைக்குகளுக்கு நம்பகமான மற்றும் துல்லியமான வழிசெலுத்தல் கருவியைத் தேடும் எவருக்கும் ட்ராக்கிஃபை ஜிபிஎஸ் சாதனத்தை நான் கடுமையாக பரிந்துரைக்கிறேன். இதில் திருட்டு கண்டறிதல், விபத்து எச்சரிக்கை, நேரலை சவாரி பகிர்வு, சவாரி பதிவு மற்றும் எரிபொருள் கண்காணிப்பு போன்ற சிறந்த அம்சங்கள் உள்ளன. இதை நிறுவுவது எளிது மற்றும் அதன் ஆப் பல அம்சங்களுடன் பயன்படுத்த மிகவும் எளிதானது.';

  @override
  String get rohitSharma => 'ரோஹித் சர்மா';

  @override
  String get rohitSharmaDuration => 'கடந்த 2 வருடமாக ட்ராக்கிஃபை பயனர்';

  @override
  String get rohitSharmaReview =>
      'சாதனத்தைப் பயன்படுத்தும் போது இயக்கக் கண்காணிப்பை மற்றவர்களுடன் பகிர்வது எளிதான வழியாகும், இதனால் எனது நண்பர் என்னைக் கண்காணிக்க முடியும். ஆப் மிகவும் பதிலளிக்கக்கூடியது மற்றும் பயனுள்ளது.';

  @override
  String get peopleSmartIntro =>
      'நபர்கள் தங்கள் பைக்கை ஸ்மார்ட் ஆக்கினர்.\nஅனுபவியுங்கள் ';

  @override
  String get smartText => 'ஸ்மார்ட் ';

  @override
  String get featuresOfTrackify => 'ட்ராக்கிஃபை அம்சங்கள் 🏍️';

  @override
  String get accidentAlertCard => 'விபத்து எச்சரிக்கை';

  @override
  String get antiTheftAlertCard => 'திருட்டு எதிர்ப்பு எச்சரிக்கை';

  @override
  String get liveGpsTrackingCard => 'நேரலை ஜிபிஎஸ் கண்காணிப்பு';

  @override
  String get chooseDeviceSuitsYou =>
      'உங்களுக்குப் பொருத்தமான சாதனத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get lite => 'லைட்';

  @override
  String get pro => 'ப்ரோ';

  @override
  String get go => 'கோ';

  @override
  String get deviceSim => 'சாதனம் + ஏர்டெல்/வி சிம்';

  @override
  String get ignitionOnOffAlert => 'இக்னிஷன் ஆன்/ஆಫ್ எச்சரிக்கை';

  @override
  String get tamperAlert => 'டேம்பர் எச்சரிக்கை';

  @override
  String get portable => 'போர்ட்டபிள்';

  @override
  String get replacementWarrantyMonths => 'மாற்று உத்தரவாதம்\n(மாதங்கள்)';

  @override
  String get trackifySmartGpsIot => 'ட்ராக்கிஃபை ஸ்மார்ட் ஜிபிஎஸ் IoT';

  @override
  String get monthAppSubscription => '12 மாத ஆப்\nசந்தா\n\n';

  @override
  String get simActivationCharges => 'சிம் செயல்படுத்தும் கட்டணம்';

  @override
  String get selectProduct => 'தயாரிப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String usersBoughtProduct(String productName) {
    return '*நேற்று 31 பயனர்கள் $productName வாங்கினர்';
  }

  @override
  String get outOfStock => 'இருப்பு இல்லை';

  @override
  String get withText => 'உடன் ';

  @override
  String buyNowForPrice(String price) {
    return '₹$price க்கு இப்போது வாங்கவும்';
  }

  @override
  String get liveTracking => 'நேரலை கண்காணிப்பு';

  @override
  String get googlePlay => 'கூகுள் பிளே';

  @override
  String get searchForItem => 'பொருளைத் தேடுங்கள்...';

  @override
  String get completePersonalDetails => 'தனிப்பட்ட விவரங்களை பூர்த்தி செய்க';

  @override
  String get personalDetailsDesc =>
      'சாதன நிறுவலுக்கு முன் இந்த விவரங்களை வழங்கவும்.';

  @override
  String get lastNameLabel => 'இறுதி பெயர்';

  @override
  String get enterLastName => 'உங்கள் கடைசி பெயரை உள்ளிடவும்';

  @override
  String get requiredField => 'தேவையான புலம்';

  @override
  String get enterMobileNumber => 'உங்கள் மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get saveAndContinue => 'சேமித்து தொடரவும்';

  @override
  String get yourLocationLabel => 'உங்கள் இருப்பிடம்';

  @override
  String get deviceWarrantyExpired => 'சாதனத்தின் உத்தரவாதம் முடிவடைந்தது';

  @override
  String get receivedTrackifyDevicePrompt =>
      'உங்கள் டிராகிஃபை சாதனத்தைப் பெற்றீர்களா?';

  @override
  String get fivePercentOffPromo =>
      'டிராகிஃபை பயன்பாட்டிலிருந்து வாங்கினால் 5% தள்ளுபடி';

  @override
  String get activateNow => 'இப்போது செயல்படுத்தவும்';

  @override
  String get exploreExclusiveDeal => 'பிரத்யேக சலுகையை ஆராயுங்கள்';

  @override
  String get rechargePlan => 'ரீசார்ஜ் திட்டம்';

  @override
  String get rechargeExpired => 'ரீசார்ஜ் காலாவதியானது';

  @override
  String get trackifyBrandLabel => 'டிராகிஃபை';

  @override
  String get hrMinLabel => 'மணி:நிமி';

  @override
  String get enterCustomTag => 'தனிப்பயன் குறிச்சொல்லை உள்ளிடவும்';

  @override
  String get locationNotAvailable => 'இருப்பிடம் கிடைக்கவில்லை';

  @override
  String get deleteAccountFailedNoUser =>
      'கணக்கை நீக்க முடியவில்லை: பயனர் ஐடி கிடைக்கவில்லை.';

  @override
  String get deleteAccountSuccess => 'கணக்கு வெற்றிகரமாக நீக்கப்பட்டது.';

  @override
  String errorDeletingAccount(String message) {
    return 'கணக்கை நீக்குவதில் பிழை: $message';
  }

  @override
  String get invalidVehicleRegistrationNumber =>
      'செல்லுபடியாகும் வாகன பதிவு எண்ணை உள்ளிடவும்.';

  @override
  String get cropImageTitle => 'படத்தை பயிர் செய்க';

  @override
  String get pleaseEnterVehicleRegistrationNumber =>
      'வாகன பதிவு எண்ணை உள்ளிடவும்.';

  @override
  String get vehicleRegNoRcHelpText =>
      'பதிவுச் சான்றிதழில் (RC) அச்சிடப்பட்டுள்ளபடி உங்கள் வாகனப் பதிவு எண்ணை உள்ளிடவும்.';

  @override
  String get vehicleNumberHintAlternative => 'எ.கா. UP32AB1234';

  @override
  String get vehicleRegistrationNumberLabel => 'வாகன பதிவு எண்';

  @override
  String get notificationFallback => 'அறிவிப்பு';

  @override
  String get dateHeader => 'தேதி';

  @override
  String get timeHeader => 'நேரம்';

  @override
  String get odometerHeader => 'ஓடோமீட்டர்';

  @override
  String get locationHeader => 'இடம்';

  @override
  String get amountHeader => 'தொகை';

  @override
  String get rateHeader => 'விகிதம்';

  @override
  String get litersHeader => 'லிட்டர்';

  @override
  String get mileageHeader => 'மைலேஜ்';

  @override
  String get downloadingStatus => 'பதிவிறக்குகிறது...';

  @override
  String get downloadCsvButton => 'CSV பதிவிறக்கவும்';

  @override
  String get fileDownloadSuccess =>
      'கோப்பு வெற்றிகரமாக பதிவிறக்கம் செய்யப்பட்டது!';

  @override
  String errorDownloadingFile(String error) {
    return 'கோப்பைப் பதிவிறக்குவதில் பிழை: $error';
  }

  @override
  String get couldNotOpenFaq => 'FAQ-ஐத் திறக்க முடியவில்லை';

  @override
  String get couldNotOpenTerms =>
      'விதிமுறைகள் மற்றும் நிபந்தனைகளைத் திறக்க முடியவில்லை';

  @override
  String get couldNotOpenPrivacy => 'தனியுரிமைக் கொள்கையைத் திறக்க முடியவில்லை';

  @override
  String get incorrectPin => 'தவறான பின்';

  @override
  String get pinsDoNotMatch =>
      'பின்கள் பொருந்தவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get resetPinTitle => 'பின்னை மீட்டமை';

  @override
  String get resetPinDescription =>
      'உங்கள் பின்னை மீட்டமைக்க விரும்புகிறீர்களா? இது தற்போதைய பின்னை அழிக்கும்.';

  @override
  String get resetBtn => 'மீட்டமை';

  @override
  String get unlockVehiclePinTitle => 'வாகனத்தைத் திறக்கவும்';

  @override
  String get lockVehiclePinTitle => 'வாகனத்தைப் பூட்டவும்';

  @override
  String get setNewPinTitle => 'புதிய பின்னை அமைக்கவும்';

  @override
  String get confirmNewPinTitle => 'புதிய பின்னை உறுதிப்படுத்தவும்';

  @override
  String get enterPinSubtitle => 'தொடர உங்கள் 4-இலக்க பின்னை உள்ளிடவும்';

  @override
  String get createNewPinSubtitle =>
      'வாகனத்தை பூட்ட 4-இலக்க பின்னை உருவாக்கவும்';

  @override
  String get confirmNewPinSubtitle =>
      'உறுதிப்படுத்த உங்கள் 4-இலக்க பின்னை மீண்டும் உள்ளிடவும்';

  @override
  String get forgotPin => 'பின் மறந்துவிட்டதா?';

  @override
  String get noSavedRidesYet =>
      'No saved rides yet! Mark a ride as saved to add it here.';

  @override
  String welcomeUser(String name) {
    return 'நல்வரவு, $name!';
  }

  @override
  String get welcomeToTrackify => 'டிராக்கிஃபைக்கு நல்வரவு!';

  @override
  String get thankYouForRegisteringDesc =>
      'பதிவு செய்தமைக்கு நன்றி! உங்கள் கணக்கு வெற்றிகரமாக உருவாக்கப்பட்டது. உங்கள் டாஷ்போர்டை அணுகவும் வாகனங்களை நிர்வகிக்கவும் உள்நுழையவும்.';

  @override
  String get continueToSignIn => 'உள்நுழையத் தொடரவும்';

  @override
  String get deviceNotInstalled => 'சாதனம் நிறுவப்படவில்லை';

  @override
  String deviceNotInstalledDesc(String vehicleName) {
    return '$vehicleName இல் டிராக்கிங் சாதனம் நிறுவப்படவில்லை. அறிவிப்பு கட்டுப்பாடுகளை உள்ளமைக்க சாதனத்தை நிறுவவும்.';
  }

  @override
  String get noDevice => 'சாதனம் இல்லை';

  @override
  String get noDeviceNotificationBanner =>
      'இந்த வாகனத்துடன் எந்த டிராக்கிங் சாதனமும் இணைக்கப்படவில்லை. அறிவிப்பு கட்டுப்பாடுகள் முடுக்கப்பட்டுள்ளன.';

  @override
  String get ok => 'சரி';

  @override
  String get profile100PercentComplete => 'உங்கள் சுயவிவரம் 100% முடிந்தது!';
}
