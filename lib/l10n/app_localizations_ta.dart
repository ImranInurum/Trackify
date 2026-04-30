// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get selectLanguage => 'உங்கள் மொழியை தேர்வு செய்யவும்';

  @override
  String get letsGetStarted => 'நாம் தொடங்கலாம்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'மின்னஞ்சல் அவசியம்';

  @override
  String get passwordRequired => 'கடவுச்சொல் அவசியம்';

  @override
  String get invalidEmail => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get forgotPassword => 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?';

  @override
  String get signIn => 'உள்நுழைய';

  @override
  String get or => 'அல்லது';

  @override
  String get dontHaveAccount => 'உங்களிடம் கணக்கு இல்லையா? ';

  @override
  String get signUp => 'பதிவு செய்யவும்';

  @override
  String welcome(String email) {
    return 'வரவேற்கிறோம் $email!';
  }

  @override
  String get loginFailed => 'உள்நுழைவு தோல்வி';

  @override
  String get name => 'பெயர்';

  @override
  String get nameHint => 'John Doe';

  @override
  String get nameRequired => 'பெயர் அவசியம்';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get mobileNumberHint => 'மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get mobileNumberRequired => 'மொபைல் எண் அவசியம்';

  @override
  String get invalidMobileNumber => 'சரியான மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get country => 'நாடு';

  @override
  String get countryHint => 'நாட்டை உள்ளிடவும்';

  @override
  String get countryRequired => 'நாடு அவசியம்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get stateHint => 'மாநிலத்தை உள்ளிடவும்';

  @override
  String get stateRequired => 'மாநிலம் அவசியம்';

  @override
  String get city => 'நகரம்';

  @override
  String get cityHint => 'நகரத்தை உள்ளிடவும்';

  @override
  String get cityRequired => 'நகரம் அவசியம்';

  @override
  String get selectProfileImage => 'சுயவிவர படத்தைத் தேர்வு செய்யவும்';

  @override
  String get role => 'பங்கு';

  @override
  String get roleAdmin => 'அட்மின்';

  @override
  String get roleCustomer => 'வாடிக்கையாளர்';

  @override
  String get selectRoleHint => 'பங்கைத் தேர்வு செய்யவும்';

  @override
  String get roleRequired => 'தயவுசெய்து ஒரு பங்கைத் தேர்வு செய்யவும்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கவும்';

  @override
  String get registerSuccess =>
      'பயனர் வெற்றிகரமாக பதிவு செய்யப்பட்டார், தயவுசெய்து உள்நுழையவும்';

  @override
  String get signUpFailed => 'பதிவு தோல்வி';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get otpSent => 'OTP வெற்றிகரமாக அனுப்பப்பட்டது';

  @override
  String get resetPassword => 'கடவுச்சொல்லை மீட்டமைக்கவும்';

  @override
  String get resetPasswordDesc =>
      'உங்கள் மின்னஞ்சலை உள்ளிடவும், கடவுச்சொல்லை மீட்டமைக்க ஒரு இணைப்பை அனுப்புவோம்.';

  @override
  String get sendResetLink => 'மீட்டமைப்பு இணைப்பை அனுப்பவும்';

  @override
  String get otpVerified => 'OTP வெற்றிகரமாக சரிபார்க்கப்பட்டது';

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
  String get otpRequired => 'OTP அவசியம்';

  @override
  String get passwordResetSuccess =>
      'கடவுச்சொல் வெற்றிகரமாக மீட்டமைக்கப்பட்டது';

  @override
  String get createNewPassword => 'புதிய கடவுச்சொல்லை உருவாக்கவும்';

  @override
  String get passwordDesc =>
      'உங்கள் புதிய கடவுச்சொல் முன்பு பயன்படுத்திய கடவுச்சொற்களிலிருந்து மாறுபட்டதாக இருக்க வேண்டும்.';

  @override
  String get newPassword => 'புதிய கடவுச்சொல்';

  @override
  String get newPasswordHint => 'புதிய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get passwordMinLength =>
      'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get confirmPasswordHint =>
      'உங்கள் புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get confirmPasswordRequired => 'கடவுச்சொல் உறுதிப்படுத்தல் அவசியம்';

  @override
  String get passwordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get selectDevice => 'சாதனத்தைத் தேர்வு செய்யவும்';

  @override
  String get noDevicesFound => 'சாதனங்கள் எதுவும் கிடைக்கவில்லை.';

  @override
  String get proceed => 'தொடரவும்';

  @override
  String get unknownDevice => 'அறியப்படாத சாதனம்';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'சாதனங்களை பெற தொடங்கவும்.';

  @override
  String get recordRide => 'பயணத்தை பதிவு செய்யவும்';

  @override
  String get phoneAsGps => 'உங்கள் மொபைலை GPS டிராக்கிங் சாதனமாக மாற்றவும்';

  @override
  String get goToDashboard => 'டாஷ்போர்டுக்கு செல்லவும்';

  @override
  String get seeFullMap => 'முழு வரைபடத்தை பார்க்கவும்';

  @override
  String get exploreMore => 'மேலும் ஆராயவும்';

  @override
  String get reachMeSticker => 'ReachMe ஸ்டிக்கர்';

  @override
  String get products => 'பொருட்கள்';

  @override
  String get fuelLogs => 'எரிபொருள் பதிவுகள்';

  @override
  String get locationSharing => 'இடத்தை பகிர்வு';

  @override
  String get documentFolder => 'ஆவண கோப்புறை';

  @override
  String get voiceMonitoring => 'குரல் கண்காணிப்பு';

  @override
  String get remoteEngineOff => 'ரிமோட் எஞ்சின் ஆஃப்';

  @override
  String get networkBooster => 'நெட்வொர்க் பூஸ்டர்';

  @override
  String get emergency => 'அவசரம்';

  @override
  String get overspeedAlert => 'அதிக வேக எச்சரிக்கை';

  @override
  String get geoFenceAlert => 'ஜியோ-பென்ஸ் எச்சரிக்கை';

  @override
  String get more => 'மேலும்';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get bikeSmartMsg =>
      '1000+ பேர் எங்கள் சாதனத்தின் மூலம் தங்கள் பைக்கை ஸ்மார்ட் ஆக்கியுள்ளனர்';

  @override
  String get features => 'அம்சங்கள்';

  @override
  String get contactUs => 'எங்களை தொடர்பு கொள்ளவும்';

  @override
  String get contactUsDesc => 'கேள்விகள் உள்ளதா? உதவ நாங்கள் இருக்கிறோம்.';

  @override
  String get userReviews => 'பயனர் விமர்சனங்கள்';

  @override
  String get accidentAlert => 'விபத்து எச்சரிக்கை';

  @override
  String get antiTheftAlert => 'திருட்டு எதிர்ப்பு எச்சரிக்கை';

  @override
  String get geoFence => 'ஜியோ பென்ஸ்';

  @override
  String get statistics => 'புள்ளிவிவரங்கள்';

  @override
  String get myGarage => 'என் கேரேஜ்';

  @override
  String get noVehiclesInGarage => 'உங்கள் கேரேஜில் எந்த வாகனமும் இல்லை.';

  @override
  String get unknownVehicle => 'அறியப்படாத வாகனம்';

  @override
  String get status => 'நிலை';

  @override
  String get active => 'செயலில்';

  @override
  String get subscription => 'சந்தா';

  @override
  String get proPlan => 'ப்ரோ திட்டம்';

  @override
  String get initializeGarage => 'உங்கள் கேரேஜை பெற தொடங்கவும்.';

  @override
  String get ourProducts => 'எங்கள் பொருட்கள்';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'அதிக அம்சங்களுடன் மேம்பட்ட டிராக்கிங்';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'தினசரி பயன்பாட்டிற்கான ஸ்டாண்டர்ட் டிராக்கிங்';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'அடிப்படை லொகேட்டர் சாதனம்';

  @override
  String get realTime1s => 'நேரடி 1 விநாடி டிராக்கிங்';

  @override
  String get remoteEngineCutOff => 'ரிமோட் எஞ்சின் கட்-ஆஃப்';

  @override
  String get detailedFuelAnalytics => 'விரிவான எரிபொருள் பகுப்பாய்வு';

  @override
  String get realTime5s => 'நேரடி 5 விநாடி டிராக்கிங்';

  @override
  String get antiTheftAlerts => 'திருட்டு எதிர்ப்பு எச்சரிக்கைகள்';

  @override
  String get basicJourneyLogs => 'அடிப்படை பயண பதிவுகள்';

  @override
  String get locationUpdates => 'இடம் புதுப்பிப்புகள்';

  @override
  String get batteryMonitor => 'பேட்டரி கண்காணிப்பு';

  @override
  String get featuresLabel => 'அம்சங்கள்:';

  @override
  String addedToCart(String title) {
    return '$title கார்டில் சேர்க்கப்பட்டது!';
  }

  @override
  String get buyNow => 'இப்போது வாங்கவும்';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String errorMsg(String message) {
    return 'பிழை: $message';
  }

  @override
  String get addVehicle => 'வாகனம்/சாதனம் சேர்க்கவும்';

  @override
  String get vehicleAdded => 'வாகனம் வெற்றிகரமாக சேர்க்கப்பட்டது!';

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
  String get electric => 'மின்சாரம்';

  @override
  String get vehicleMake => 'வாகன நிறுவனம்';

  @override
  String get vehicleModel => 'வாகன மாதிரி';

  @override
  String get vehicleNumber => 'வாகன எண்';

  @override
  String get vehicleNumberHint => 'எ.கா. MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'தயவுசெய்து வாகன எண்ணை உள்ளிடவும்';

  @override
  String get selectMake => 'வாகன நிறுவனம் தேர்ந்தெடுக்கவும்';

  @override
  String get selectModel => 'வாகன மாதிரி தேர்ந்தெடுக்கவும்';

  @override
  String get installDevice => 'Trackify சாதனத்தை நிறுவவும்';

  @override
  String get installDeviceDesc =>
      'எளிய படிகளில் உங்கள் Ajjas சாதனத்தை அமைக்கவும்';

  @override
  String get activateSticker => 'கான்டாக்ட் ஸ்டிக்கரை செயல்படுத்தவும்';

  @override
  String get activateStickerDesc =>
      'சில எளிய படிகளில் ஸ்டிக்கரை செயல்படுத்தவும்';

  @override
  String get exploreFreeApp => 'எங்கள் இலவச செயலியை பாருங்கள்';

  @override
  String get exploreFreeAppDesc => 'போனில் ரைட்களை பதிவு செய்து கண்காணிக்கவும்';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get dataPlan => 'டேட்டா திட்டம்';

  @override
  String get warranty => 'உத்தரவாதம்';

  @override
  String expiresInDays(String days) {
    return '$days நாட்களில் முடியும்';
  }

  @override
  String get rechargeNow => 'இப்போது ரீசார்ஜ் செய்யவும்';

  @override
  String get renewNow => 'இப்போது புதுப்பிக்கவும்';

  @override
  String get secureYourVehicle => 'உங்கள் வாகனத்தை பாதுகாக்கவும்';

  @override
  String get secureYourVehicleDesc =>
      'நேரடி கண்காணிப்புக்கு Ajjas சாதனத்தை வாங்கவும்';

  @override
  String get boughtDeviceInstallNow => 'சாதனம் வாங்கியிருக்கிறீர்களா? ';

  @override
  String get installNow => 'இப்போது நிறுவவும்';

  @override
  String get buyAjjasDevice => 'Ajjas சாதனம் வாங்கவும்';

  @override
  String get lite4G => 'Lite 4G';

  @override
  String get swipeToLock => 'பூட்ட ஸ்வைப் செய்யவும்';

  @override
  String get upgradeToPlus => 'Ajjas Plus-க்கு மேம்படுத்தவும்';

  @override
  String get getMoreOutOfAjjas => 'Ajjas-ஐ அதிகமாக பயன்படுத்துங்கள்';

  @override
  String featuresExploredCount(String count, String total) {
    return '$count / $total அம்சங்களை பார்த்துள்ளீர்கள்';
  }

  @override
  String get manageVehiclesDesc =>
      'உங்கள் அனைத்து வாகனங்களையும் இங்கே நிர்வகிக்கவும்';

  @override
  String get settingsDesc => 'மொழி, கணக்கு அமைப்புகள் மற்றும் மேலும்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get noNotifications => 'அறிவிப்புகள் இல்லை';

  @override
  String get notificationsFetchedSuccessfully =>
      'அறிவிப்புகள் வெற்றிகரமாக பெறப்பட்டது';

  @override
  String get errorFetchingNotifications => 'அறிவிப்புகளை பெறுவதில் பிழை';

  @override
  String get helpAndSupport => 'உதவி & ஆதரவு';

  @override
  String get helpAndSupportDesc => 'உதவி மற்றும் FAQ பெறுங்கள்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get searchForSettings => 'அமைப்புகளை தேடுங்கள்';

  @override
  String get backupAndRestore => 'காப்புப்பிரதி & மீட்டமை';

  @override
  String get backupAndRestoreDesc => 'தரவை காப்புப் பெற்று மீட்டமைக்கவும்';

  @override
  String get appSettings => 'செயலி அமைப்புகள்';

  @override
  String get appSettingsDesc => 'தீம், ஹீட்மேப் மற்றும் அவசர அம்சம்';

  @override
  String get notificationSettings => 'அறிவிப்பு அமைப்புகள்';

  @override
  String get notificationSettingsDesc => 'அறிவிப்பு விருப்பங்கள் & ஒலி';

  @override
  String get privacy => 'தனியுரிமை';

  @override
  String get privacyDesc => 'கடவுச்சொல் மாற்றம், கணக்கு மேலாண்மை';

  @override
  String get rateUsOnPlayStore => 'Play Store-ல் மதிப்பிடுங்கள்';

  @override
  String get rateUsOnPlayStoreDesc => 'உங்கள் கருத்தை பகிருங்கள்';

  @override
  String get logoutDesc => 'இந்த சாதனத்திலிருந்து வெளியேறு';

  @override
  String get helpAndSuggestion => 'உதவி & பரிந்துரை';

  @override
  String get reportAnIssue => 'பிரச்சினையை தெரிவிக்கவும்';

  @override
  String get suggestion => 'பரிந்துரை';

  @override
  String get whatIsYourIssueRelatedTo =>
      'உங்கள் பிரச்சினை எதுடன் தொடர்புடையது?';

  @override
  String get shortDescriptionHint =>
      'சுருக்கமான விளக்கம் அளிக்கவும் (அதிகபட்சம் 200 எழுத்துகள்)';

  @override
  String get selectCallSlot => 'அழைப்பு நேரத்தை தேர்ந்தெடுக்கவும்';

  @override
  String get myIssues => 'என் பிரச்சினைகள்';

  @override
  String get whatsApp => 'வாட்ஸ்அப்';

  @override
  String get forceMigrate => 'கட்டாய மாற்றம்';

  @override
  String get forceMigrateDesc1 =>
      'அப் அப்டேட்டின் போது தவறவிட்ட பேக்கப் ரைட்களை சரிசெய்ய இந்த விருப்பத்தை பயன்படுத்தவும்.';

  @override
  String get forceMigrateDesc2 =>
      'கவனிக்கவும், இது சர்வரில் உள்ள பழைய ரைட்களை மீட்டெடுக்காது. இது உங்கள் லோக்கல் ஸ்டோரேஜ் தரவை புதிய வடிவத்திற்கு மாற்றும்.';

  @override
  String get faq => 'அடிக்கடி கேட்கப்படும் கேள்விகள்';

  @override
  String get termsConditions => 'விதிமுறைகள் மற்றும் நிபந்தனைகள்';

  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get changeLog => 'மாற்றப் பதிவு';

  @override
  String get todayLabel => '(இன்று)';

  @override
  String get ridingBehaviour => 'ஓட்டுநர் பழக்கம்';

  @override
  String get ridingBehaviourVacationDesc =>
      'தேர்ந்தெடுத்த காலத்தில் நீங்கள் எந்த பயணமும் மேற்கொள்ளவில்லை போல தெரிகிறது';

  @override
  String get journey => 'பயணம்';

  @override
  String get distanceTravelled => 'பயணித்த தூரம்';

  @override
  String get timeDuration => 'நேர அளவு';

  @override
  String get speed => 'வேகம்';

  @override
  String get averageSpeed => 'சராசரி வேகம்';

  @override
  String get topSpeed => 'அதிகபட்ச வேகம்';

  @override
  String get fuel => 'எரிபொருள்';

  @override
  String get fuelConsumed => 'பயன்படுத்திய எரிபொருள்';

  @override
  String get fuelCost => 'எரிபொருள் செலவு';

  @override
  String vsPreviousPeriod(String value) {
    return 'முந்தைய காலத்துடன் ஒப்பிடும்போது $value%';
  }

  @override
  String get vehicleMakeListEmpty =>
      'இந்த தேர்விற்கு வாகன நிறுவன பட்டியல் காலியாக உள்ளது';

  @override
  String get vehicleModelListEmpty =>
      'இந்த தேர்விற்கு வாகன மாதிரி பட்டியல் காலியாக உள்ளது';

  @override
  String get deviceInstallation => 'சாதன நிறுவல்';

  @override
  String get scanActivationCode => 'செயல்படுத்தும் குறியீட்டை ஸ்கேன் செய்யவும்';

  @override
  String get enterActivationCodeManually =>
      'செயல்படுத்தும் குறியீட்டை கையால் உள்ளிடவும்';

  @override
  String get openAjjasBoxInstruction =>
      'QR குறியீட்டிற்காக Ajjas பெட்டியை திறக்கவும்';

  @override
  String get continueText => 'தொடரவும்';

  @override
  String get enterUID => 'UID உள்ளிடவும்';

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
  String get invalidImeiError => 'சரியான 15 இலக்க IMEI எண்ணை உள்ளிடவும்';

  @override
  String get sharedRides => 'பகிரப்பட்ட பயணங்கள்';

  @override
  String get savedRides => 'சேமிக்கப்பட்ட பயணங்கள்';

  @override
  String get allRides => 'அனைத்து பயணங்கள்';

  @override
  String get trips => 'ட்ரிப்ஸ்';

  @override
  String clicked(String value) {
    return '$value கிளிக் செய்யப்பட்டது';
  }

  @override
  String get noDailyRides => 'தினசரி பயணங்கள் இல்லை';

  @override
  String get getStartedFirstRide => 'முதல் பயணத்தை தொடங்குங்கள்';

  @override
  String get durationLabel => 'நேர அளவு';

  @override
  String get km => 'கிமீ';

  @override
  String get kmh => 'கிமீ/மணி';

  @override
  String get tripEmptyQuote =>
      '“உங்கள் பயணங்களை ட்ரிப்ஸாக குழுவாக்கி நினைவுகளை சேகரிக்கவும்”';

  @override
  String ridesCompletedCount(String completed, String total) {
    return 'முடிந்த பயணங்கள்: $completed/$total';
  }

  @override
  String get unlockTripsRequirement =>
      'ட்ரிப்ஸை திறக்க குறைந்தது 3 பயணங்கள் தேவை';

  @override
  String get createNewTrip => 'புதிய ட்ரிப் உருவாக்கவும்';

  @override
  String get startByCreatingTrip => 'புதிய ட்ரிப் உருவாக்கி தொடங்கவும்';

  @override
  String get skip => 'தவிர்க்கவும்';

  @override
  String get todayText => 'இன்று';

  @override
  String get distanceLabel => 'தூரம்';

  @override
  String get rideDuration => 'பயண நேரம்';

  @override
  String get speedLabel => 'வேகம்';

  @override
  String get minutesShort => 'நி';

  @override
  String get secondsShort => 'வி';

  @override
  String get getMoreOutOfTrackify => 'Trackify-ஐ மேலும் பயன்படுத்துங்கள்';

  @override
  String get discoverMoreDesc =>
      'மேலும் கண்டறியுங்கள் — அருமையான விஷயங்கள் காத்திருக்கின்றன!';

  @override
  String get serviceLogs => 'சேவை பதிவுகள்';

  @override
  String get safeParking => 'பாதுகாப்பான நிறுத்தம்';

  @override
  String get appUpdates => 'அப் புதுப்பிப்புகள்';

  @override
  String get deviceDataPlanLabel => 'சாதன டேட்டா திட்டம்';

  @override
  String get deviceWarrantyLabel => 'சாதன உத்தரவாதம்';

  @override
  String get videoTutorials => 'வீடியோ பாடங்கள்';

  @override
  String get exploreNow => 'இப்போது பாருங்கள்';

  @override
  String get plusLabel => 'ப்ளஸ்';

  @override
  String get mapStyleLabel => 'வரைபட பாணி';

  @override
  String get darkStyle => 'டார்க்';

  @override
  String get lightStyle => 'லைட்';

  @override
  String get simpleStyle => 'சிம்பிள்';

  @override
  String get satelliteStyle => 'சாட்லைட்';

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
    return 'நிறுத்தப்பட்டது: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return 'இன்னும் $value கிமீ செல்ல வேண்டும்';
  }

  @override
  String get buyTrackifyDevice => 'Trackify சாதனத்தை வாங்கவும்';

  @override
  String get recordViaPhone => 'போன் மூலம் பதிவு செய்யவும்';

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
  String get myProfile => 'என் சுயவிவரம்';

  @override
  String get profileCompleteness => 'சுயவிவர முழுமை';

  @override
  String lastUpdatedOn(String date) {
    return '$date அன்று கடைசியாக புதுப்பிக்கப்பட்டது';
  }

  @override
  String get addProfilePicture => 'உங்கள் சுயவிவர படத்தை சேர்க்கவும்';

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
  String get emergencyContacts => 'அவசர தொடர்புகள்';

  @override
  String get addEditEmergencyContactDesc =>
      'Add and edit emergency contact list in vehicle settings.';

  @override
  String get smartContactSticker => 'ஸ்மார்ட் தொடர்பு ஸ்டிக்கர்';

  @override
  String get stickerSubtitle =>
      'A step forward to make your vehicle SAFE and SMART';

  @override
  String get activateContactSticker => 'ஸ்டிக்கரை செயல்படுத்தவும்';

  @override
  String get buyNewContactSticker => 'புதிய ஸ்டிக்கர் வாங்கவும்';

  @override
  String get beyondParkingProblems => 'Beyond parking problems';

  @override
  String get noParkings => 'பார்க்கிங் இல்லை';

  @override
  String get emergencies => 'அவசர நிலைகள்';

  @override
  String get vehicleTowing => 'வாகன இழுத்தல்';

  @override
  String get getInformedStayConnected =>
      'Get informed & stay connected\nwith your vehicle';

  @override
  String get securedCalls => 'பாதுகாப்பான அழைப்புகள்';

  @override
  String get securedCallsDesc =>
      'Internet-masked calls-keeps your phone number private.';

  @override
  String get notificationHistory => 'அறிவிப்பு வரலாறு';

  @override
  String get notificationHistoryDesc =>
      'Keep track of all the current and previous notifications';

  @override
  String get beInformed => 'தகவலுடன் இருங்கள்';

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
  String get addServiceLogs => 'சேவை பதிவு சேர்க்கவும்';

  @override
  String get uploadServicingBill => 'சேவை பில் பதிவேற்றவும்';

  @override
  String get addImage => 'படம் சேர்க்கவும்';

  @override
  String get maxFileSizeNote => 'Note: Maximum File Size is 5MB';

  @override
  String get serviceDate => 'சேவை தேதி';

  @override
  String get billingAmount => 'பில் தொகை';

  @override
  String get serviceCenterName => 'Service Center Name';

  @override
  String get serviceCenterContact => 'Service Center Contact';

  @override
  String get additionalNote => 'Additional Note';

  @override
  String get saveDetails => 'விவரங்களை சேமிக்கவும்';

  @override
  String get selectVehicle => 'வாகனத்தை தேர்வு செய்யவும்';

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
  String get stopSharing => 'பகிர்வை நிறுத்தவும்';

  @override
  String get shareLocation => 'இடத்தை பகிரவும்';

  @override
  String get startSharing => 'பகிர்வை தொடங்கவும்';

  @override
  String get phoneTracking => 'போன் டிராக்கிங்';

  @override
  String get liveRecordTab => 'Live Record';

  @override
  String get statsTab => 'Stats';

  @override
  String get timeLabel => 'நேரம்';

  @override
  String get weekly => 'வாராந்திர';

  @override
  String get monthly => 'மாதாந்திர';

  @override
  String get custom => 'தனிப்பயன்';

  @override
  String get quickStats => 'விரைவு புள்ளிவிவரங்கள்';

  @override
  String get totalRides => 'மொத்த பயணங்கள்';

  @override
  String get avgSpeed => 'சராசரி வேகம்';

  @override
  String get totalFuel => 'Total Fuel';

  @override
  String get overallDistance => 'மொத்த தூரம்';

  @override
  String get drivingTime => 'ஓட்ட நேரம்';

  @override
  String get safetyScore => 'பாதுகாப்பு மதிப்பெண்';

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
  String get submit => 'சமர்ப்பிக்கவும்';

  @override
  String get selectVehiclesOverspeedAlert =>
      'Select vehicles on which to add overspeed alert';

  @override
  String get selected => 'Selected';

  @override
  String get sec => 'sec';

  @override
  String get viewMore => 'மேலும் பார்க்க';

  @override
  String get viewLess => 'குறைவாக பார்க்க';

  @override
  String get previousRides => 'முந்தைய பயணங்கள்';

  @override
  String get seeAll => 'அனைத்தையும் பார்க்க';

  @override
  String get videosYouMightLike => 'Videos You Might Like';

  @override
  String get scrollToTop => 'Scroll to Top';

  @override
  String get noRecentRidesFound => 'சமீபத்திய பயணங்கள் இல்லை';

  @override
  String get failedToLoadRides => 'பயணங்களை ஏற்ற முடியவில்லை';

  @override
  String get hrMin => 'hr:min';

  @override
  String get kmHr => 'km/hr';

  @override
  String get warranty_title => 'சாதன உத்தரவாதம்';

  @override
  String get warranty_extend =>
      'Extend warranty of your Trackify Lite by 1 year @ ₹1/day';

  @override
  String get warranty_vehicle => 'வாகனம்';

  @override
  String get warranty_expiry => 'உத்தரவாத முடிவு தேதி';

  @override
  String warranty_daysLeft(String days) {
    return '$days days left';
  }

  @override
  String get warranty_benefitsTitle => 'நீங்கள் தவறவிடக்கூடாத நன்மைகள்';

  @override
  String get benefit1_highlight => 'உத்தரவாத மாற்று ';

  @override
  String get benefit1_normal => 'பழுதானால்';

  @override
  String get benefit2_highlight => '₹1200 வரை சேமிக்கவும் ';

  @override
  String get benefit2_normal => 'சாதன பழுதுparuக்கு';

  @override
  String get benefit3_highlight => 'உடனடி ஆதரவு ';

  @override
  String get benefit3_normal => 'சாதன தொடர்பான பிரச்சினைகளுக்கு';

  @override
  String get benefit4_highlight => '₹2000 வரை இலவச நீட்டிக்கப்பட்ட சந்தா ';

  @override
  String get benefit4_normal => 'பழுது காலத்திற்கு';

  @override
  String get warranty_button => 'இப்போது உத்தரவாதத்தை நீட்டிக்கவும் @ ₹365 ';

  @override
  String get warranty_button_old => '₹730';
}
