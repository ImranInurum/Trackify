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
}
