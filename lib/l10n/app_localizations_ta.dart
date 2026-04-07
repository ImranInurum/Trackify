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
  String get role => 'பகிர்வு';

  @override
  String get roleRequired => 'ஒரு பங்கினைத் தேர்ந்தெடுக்கவும்';

  @override
  String get createAccount => 'கணக்கை உருவாக்கவும்';

  @override
  String get registerSuccess =>
      'பயனர் வெற்றிகரமாக பதிவு செய்யப்பட்டார், தயவுசெய்து உள்நுழையவும்';

  @override
  String get signUpFailed => 'பதிவு தோல்வியடைந்தது';

  @override
  String get otpSent => 'OTP வெற்றிகரமாக அனுப்பப்பட்டது';

  @override
  String get resetPassword => 'கடவுச்சொல்லை மீட்டமைக்கவும்';

  @override
  String get resetPasswordDesc =>
      'உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும், உங்கள் கடவுச்சொல்லை மீட்டமைக்க ஒரு இணைப்பை அனுப்புவோம்.';

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
  String get otpRequired => 'OTP தேவை';

  @override
  String get passwordResetSuccess =>
      'கடவுச்சொல் வெற்றிகரமாக மீட்டமைக்கப்பட்டது';

  @override
  String get createNewPassword => 'புதிய கடவுச்சொல்லை உருவாக்கவும்';

  @override
  String get passwordDesc =>
      'உங்கள் புதிய கடவுச்சொல் முந்தைய கடவுச்சொற்களிலிருந்து வேறுபட்டதாக இருக்க வேண்டும்.';

  @override
  String get newPassword => 'புதிய கடவுச்சொல்';

  @override
  String get newPasswordHint => 'உங்கள் புதிய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get passwordMinLength =>
      'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get confirmPasswordHint =>
      'உங்கள் புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get confirmPasswordRequired => 'கடவுச்சொல்லை உறுதிப்படுத்துவது தேவை';

  @override
  String get passwordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get selectDevice => 'சாதனத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get noDevicesFound => 'சாதனங்கள் எதுவும் இல்லை.';

  @override
  String get proceed => 'தொடரவும்';

  @override
  String get unknownDevice => 'அறியப்படாத சாதனம்';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'சாதனங்களைப் பெற தொடங்கவும்.';

  @override
  String get recordRide => 'பயணத்தை பதிவு செய்க';

  @override
  String get phoneAsGps =>
      'உங்கள் தொலைபேசியை ஜிபிஎஸ் கண்காணிப்பு சாதனமாக மாற்றவும்';

  @override
  String get goToDashboard => 'டாஷ்போர்டிற்குச் செல்க';

  @override
  String get seeFullMap => 'முழு வரைபடத்தைப் பார்க்கவும்';

  @override
  String get exploreMore => 'மேலும் ஆராயுங்கள்';

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
  String get networkBooster => 'நெட்வொர்க் பூஸ்டர்';

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
  String get bikeSmartMsg =>
      '1000+ பேர் எங்கள் சாதனம் மூலம் தங்கள் பைக்கை ஸ்மார்ட் ஆக்கியுள்ளனர்';

  @override
  String get features => 'அம்சங்கள்';

  @override
  String get contactUs => 'எங்களைத் தொடர்பு கொள்க';

  @override
  String get contactUsDesc =>
      'கேள்விகள் உள்ளதா? நாங்கள் உதவ இங்கே இருக்கிறோம்.';

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
  String get myGarage => 'எனது கேரேஜ்';

  @override
  String get noVehiclesInGarage => 'உங்கள் கேரேஜில் வாகனங்கள் எதுவும் இல்லை.';

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
  String get initializeGarage => 'உங்கள் கேரேஜை பெற தொடங்கவும்.';

  @override
  String get ourProducts => 'எங்கள் தயாரிப்புகள்';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'அதிகபட்ச அம்சங்களுடன் மேம்பட்ட கண்காணிப்பு';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'அன்றாட பயன்பாட்டிற்கான நிலையான கண்காணிப்பு';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'அடிப்படை லொக்கேட்டர் சாதனம்';

  @override
  String get realTime1s => 'ரியல்-டைம் 1செ கண்காணிப்பு';

  @override
  String get remoteEngineCutOff => 'ரிமோட் எஞ்சின் கட்-ஆஃப்';

  @override
  String get detailedFuelAnalytics => 'விரிவான எரிபொருள் பகுப்பாய்வு';

  @override
  String get realTime5s => 'ரியல்-டைம் 5செ கண்காணிப்பு';

  @override
  String get antiTheftAlerts => 'திருட்டு எதிர்ப்பு எச்சரிக்கைகள்';

  @override
  String get basicJourneyLogs => 'அடிப்படை பயண பதிவுகள்';

  @override
  String get locationUpdates => 'இருப்பிட புதுப்பிப்புகள்';

  @override
  String get batteryMonitor => 'பேட்டரி மானிட்டர்';

  @override
  String get featuresLabel => 'அம்சங்கள்:';

  @override
  String addedToCart(String title) {
    return '$title கார்ட்டில் வெற்றிகரமாக சேர்க்கப்பட்டது!';
  }

  @override
  String get buyNow => 'இப்போது வாங்கவும்';

  @override
  String get retry => 'மீண்டும் முயற்சி செய்';

  @override
  String errorMsg(String message) {
    return 'பிழை: $message';
  }
}
