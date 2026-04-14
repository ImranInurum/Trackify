// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get selectLanguage => 'तुमची भाषा निवडा';

  @override
  String get letsGetStarted => 'सुरुवात करूया';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'ईमेल आवश्यक आहे';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक आहे';

  @override
  String get invalidEmail => 'कृपया वैध ईमेल पत्ता प्रविष्ट करा';

  @override
  String get forgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get signIn => 'साइन इन करा';

  @override
  String get or => 'किंवा';

  @override
  String get dontHaveAccount => 'खाते नाही? ';

  @override
  String get signUp => 'साइन अप करा';

  @override
  String welcome(String email) {
    return 'स्वागत आहे $email!';
  }

  @override
  String get loginFailed => 'लॉगिन अयशस्वी झाले';

  @override
  String get name => 'नाव';

  @override
  String get nameHint => 'जॉन डो';

  @override
  String get nameRequired => 'नाव आवश्यक आहे';

  @override
  String get mobileNumber => 'मोबाईल नंबर';

  @override
  String get mobileNumberHint => 'मोबाईल नंबर प्रविष्ट करा';

  @override
  String get mobileNumberRequired => 'मोबाईल नंबर आवश्यक आहे';

  @override
  String get invalidMobileNumber => 'कृपया वैध मोबाईल नंबर प्रविष्ट करा';

  @override
  String get country => 'देश';

  @override
  String get countryHint => 'देश प्रविष्ट करा';

  @override
  String get countryRequired => 'देश आवश्यक आहे';

  @override
  String get state => 'राज्य';

  @override
  String get stateHint => 'राज्य प्रविष्ट करा';

  @override
  String get stateRequired => 'राज्य आवश्यक आहे';

  @override
  String get city => 'शहर';

  @override
  String get cityHint => 'शहर प्रविष्ट करा';

  @override
  String get cityRequired => 'शहर आवश्यक आहे';

  @override
  String get selectProfileImage => 'प्रोफाइल प्रतिमा निवडा';

  @override
  String get role => 'भूमिका';

  @override
  String get roleAdmin => 'प्रशासक';

  @override
  String get roleCustomer => 'ग्राहक';

  @override
  String get selectRoleHint => 'भूमिका निवडा';

  @override
  String get roleRequired => 'कृपया एक भूमिका निवडा';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get registerSuccess =>
      'वापरकर्ता यशस्वीरित्या नोंदणीकृत झाला, कृपया लॉगिन करा';

  @override
  String get signUpFailed => 'साइन अप अयशस्वी झाले';

  @override
  String get otpSent => 'ओटीपी यशस्वीरित्या पाठवला गेला';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करा';

  @override
  String get resetPasswordDesc =>
      'तुमचा ईमेल पत्ता प्रविष्ट करा आणि आम्ही तुम्हाला तुमचा पासवर्ड रीसेट करण्यासाठी एक लिंक पाठवू.';

  @override
  String get sendResetLink => 'रीसेट लिंक पाठवा';

  @override
  String get otpVerified => 'ओटीपी यशस्वीरित्या सत्यापित झाला';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करा';

  @override
  String get otpHeader => 'ओटीपी सत्यापन';

  @override
  String otpDesc(String email) {
    return '$email वर पाठवलेला ओटीपी प्रविष्ट करा.';
  }

  @override
  String get otp => 'ओटीपी';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'ओटीपी आवश्यक आहे';

  @override
  String get passwordResetSuccess => 'पासवर्ड यशस्वीरित्या रीसेट झाला';

  @override
  String get createNewPassword => 'नवीन पासवर्ड तयार करा';

  @override
  String get passwordDesc =>
      'तुमचा नवीन पासवर्ड आधी वापरलेल्या पासवर्डपेक्षा वेगळा असला पाहिजे.';

  @override
  String get newPassword => 'नवीन पासवर्ड';

  @override
  String get newPasswordHint => 'तुमचा नवीन पासवर्ड प्रविष्ट करा';

  @override
  String get passwordMinLength => 'पासवर्ड किमान ६ अक्षरांचा असावा';

  @override
  String get confirmPassword => 'पासवर्डची पुष्टी करा';

  @override
  String get confirmPasswordHint => 'तुमच्या नवीन पासवर्डची पुष्टी करा';

  @override
  String get confirmPasswordRequired => 'पासवर्डची पुष्टी करणे आवश्यक आहे';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get selectDevice => 'डिव्हाइस निवडा';

  @override
  String get noDevicesFound => 'कोणतीही डिव्हाइसेस सापडली नाहीत.';

  @override
  String get proceed => 'पुढे जा';

  @override
  String get unknownDevice => 'अज्ञात डिव्हाइस';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'डिव्हाइसेस आणण्यासाठी प्रारंभ करा.';

  @override
  String get recordRide => 'राइड रेकॉर्ड करा';

  @override
  String get phoneAsGps => 'तुमचा फोन जीपीएस ट्रॅकिंग डिव्हाइस बनवा';

  @override
  String get goToDashboard => 'डॅशबोर्डवर जा';

  @override
  String get seeFullMap => 'पूर्ण नकाशा पहा';

  @override
  String get exploreMore => 'अधिक एक्सप्लोर करा';

  @override
  String get reachMeSticker => 'रिचमी स्टिकर';

  @override
  String get products => 'उत्पादने';

  @override
  String get fuelLogs => 'इंधन लॉग';

  @override
  String get locationSharing => 'स्थान सामायिकरण';

  @override
  String get documentFolder => 'दस्तऐवज फोल्डर';

  @override
  String get voiceMonitoring => 'व्हॉइस मॉनिटरिंग';

  @override
  String get remoteEngineOff => 'रिमोट इंजिन ऑफ';

  @override
  String get networkBooster => 'नेटवर्क बूस्टर';

  @override
  String get emergency => 'आणीबाणी';

  @override
  String get overspeedAlert => 'ओव्हरस्पीड अलर्ट';

  @override
  String get geoFenceAlert => 'जिओ-फेन्स अलर्ट';

  @override
  String get more => 'अधिक';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get bikeSmartMsg =>
      '१०००+ लोकांनी आमच्या डिव्हाइससह त्यांची बाईक स्मार्ट बनवली';

  @override
  String get features => 'वैशिष्ट्ये';

  @override
  String get contactUs => 'आमच्याशी संपर्क साधा';

  @override
  String get contactUsDesc => 'काही प्रश्न आहेत? आम्ही मदतीसाठी येथे आहोत.';

  @override
  String get userReviews => 'वापरकर्ता पुनरावलोकने';

  @override
  String get accidentAlert => 'अपघात अलर्ट';

  @override
  String get antiTheftAlert => 'अँटी-थेफ्ट अलर्ट';

  @override
  String get geoFence => 'जिओ फेन्स';

  @override
  String get statistics => 'आकडेवारी';

  @override
  String get myGarage => 'माझे गॅरेज';

  @override
  String get noVehiclesInGarage =>
      'तुमच्या गॅरेजमध्ये कोणतीही वाहने सापडली नाहीत.';

  @override
  String get unknownVehicle => 'अज्ञात वाहन';

  @override
  String get status => 'स्थिती';

  @override
  String get active => 'सक्रिय';

  @override
  String get subscription => 'सबस्क्रिप्शन';

  @override
  String get proPlan => 'प्रो प्लॅन';

  @override
  String get initializeGarage => 'तुमचे गॅरेज आणण्यासाठी प्रारंभ करा.';

  @override
  String get ourProducts => 'आमची उत्पादने';

  @override
  String get proTitle => 'ट्रॅकिफाय प्रो';

  @override
  String get proSubtitle => 'प्रगत ट्रॅकिंग';

  @override
  String get goTitle => 'ट्रॅकिफाय गो';

  @override
  String get goSubtitle => 'मानक ट्रॅकिंग';

  @override
  String get liteTitle => 'ट्रॅकिफाय लाइट';

  @override
  String get liteSubtitle => 'मूलभूत लोकेटर डिव्हाइस';

  @override
  String get realTime1s => 'रिअल-टाइम १ सेकंद ट्रॅकिंग';

  @override
  String get remoteEngineCutOff => 'रिअल-टाइम इंजिन कट-ऑफ';

  @override
  String get detailedFuelAnalytics => 'तपशीलवार इंधन विश्लेषण';

  @override
  String get realTime5s => 'रिअल-टाइम ५ सेकंदांचे ट्रॅकिंग';

  @override
  String get antiTheftAlerts => 'अँटी-थेफ्ट अलर्ट';

  @override
  String get basicJourneyLogs => 'मूलभूत प्रवास लॉग';

  @override
  String get locationUpdates => 'स्थान अपडेट';

  @override
  String get batteryMonitor => 'बॅटरी मॉनिटर';

  @override
  String get featuresLabel => 'वैशिष्ट्ये:';

  @override
  String addedToCart(String title) {
    return '$title कार्टमध्ये जोडले!';
  }

  @override
  String get buyNow => 'आत्ताच खरेदी करा';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String errorMsg(String message) {
    return 'त्रुटी: $message';
  }

  @override
  String get addVehicle => 'वाहन/डिव्हाइस जोडा';

  @override
  String get vehicleAdded => 'वाहन यशस्वीरित्या जोडले गेले!';

  @override
  String get vehicleType => 'वाहनाचा प्रकार';

  @override
  String get twoWheeler => 'दुचाकी';

  @override
  String get fourWheeler => 'चारचाकी';

  @override
  String get autoRickshaw => 'ऑटो रिक्ष';

  @override
  String get heavyVehicle => 'जड वाहन';

  @override
  String get fuelType => 'इंधनाचा प्रकार';

  @override
  String get petrol => 'पेट्रोल';

  @override
  String get electric => 'इलेक्ट्रिक';

  @override
  String get vehicleMake => 'वाहन मेक';

  @override
  String get vehicleModel => 'वाहन मॉडेल';

  @override
  String get vehicleNumber => 'वाहन क्रमांक';

  @override
  String get vehicleNumberHint => 'उदा: MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'कृपया वाहन क्रमांक प्रविष्ट करा';

  @override
  String get selectMake => 'वाहन मेक निवडा';

  @override
  String get selectModel => 'वाहन मॉडेल निवडा';

  @override
  String get installDevice => 'Trackify डिव्हाइस स्थापित करा';

  @override
  String get installDeviceDesc => 'तुमचे Ajjas स्मार्ट डिव्हाइस त्वरित सेट करा';

  @override
  String get activateSticker => 'संपर्क स्टिकर सक्रिय करा';

  @override
  String get activateStickerDesc =>
      'तुमचा संपर्क स्टिकर सक्रिय करण्यासाठी सोप्या पायऱ्या';

  @override
  String get exploreFreeApp => 'आमचे विनामूल्य अॅप एक्सप्लोर करा';

  @override
  String get exploreFreeAppDesc =>
      'आमच्या विनामूल्य अॅपचा वापर करून प्रवासाचा मागोवा ठेवा';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get alreadyHaveAccount => 'आधीच खाते आहे?';

  @override
  String get dataPlan => 'डेटा प्लॅन';

  @override
  String get warranty => 'वॉरंटी';

  @override
  String expiresInDays(String days) {
    return '$days दिवसात संपेल';
  }

  @override
  String get rechargeNow => 'आता रिचार्ज करा';

  @override
  String get renewNow => 'आता नूतनीकरण करा';

  @override
  String get secureYourVehicle => 'तुमचे वाहन सुरक्षित करा';

  @override
  String get secureYourVehicleDesc =>
      'रीअल-टाइम ट्रॅकिंगसाठी आता अजस डिव्हाइस खरेदी करा.';

  @override
  String get boughtDeviceInstallNow => 'डिव्हाइस विकत घेतले आहे? ';

  @override
  String get installNow => 'आता स्थापित करा';

  @override
  String get buyAjjasDevice => 'अजस डिव्हाइस खरेदी करा';

  @override
  String get lite4G => 'लाईट ४जी';

  @override
  String get swipeToLock => 'लॉक करण्यासाठी स्वाइप करा';

  @override
  String get upgradeToPlus => 'Ajjas Plus वर अपग्रेड करा';

  @override
  String get getMoreOutOfAjjas => 'Ajjas मधून अधिक मिळवा';

  @override
  String featuresExploredCount(Object count, Object total) {
    return 'तुम्ही $total पैकी $count वैशिष्ट्ये एक्सप्लोर केली आहेत';
  }

  @override
  String get manageVehiclesDesc => 'येथे तुमची सर्व वाहने व्यवस्थापित करा';

  @override
  String get settingsDesc => 'भाषा, खाते सेटिंग्ज आणि बरेच काही';

  @override
  String get notifications => 'सूचना';

  @override
  String get helpAndSupport => 'मदत आणि समर्थन';

  @override
  String get helpAndSupportDesc => 'मदत आणि वारंवार विचारले जाणारे प्रश्न';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get searchForSettings => 'सेटिंग्ज शोधा';

  @override
  String get backupAndRestore => 'बॅकअप आणि पुनर्संचयित करा';

  @override
  String get backupAndRestoreDesc =>
      'तुमच्या राइड डेटाचा बॅकअप घ्या आणि कधीही पुनर्संचयित करा.';

  @override
  String get appSettings => 'अॅप सेटिंग्ज';

  @override
  String get appSettingsDesc => 'अॅप थीम आणि आणीबाणी वैशिष्ट्य';

  @override
  String get notificationSettings => 'सूचना सेटिंग्ज';

  @override
  String get notificationSettingsDesc => 'सूचना प्राधान्ये';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get privacyDesc => 'पासवर्ड बदला, खाते हटवा';

  @override
  String get rateUsOnPlayStore => 'Play Store वर रेटिंग द्या';

  @override
  String get rateUsOnPlayStoreDesc => 'तुमचा अमूल्य अभिप्राय सामायिक करा';

  @override
  String get logoutDesc => 'या डिव्हाइसवरून लॉगआउट करा';

  @override
  String get helpAndSuggestion => 'मदत आणि सूचना';

  @override
  String get reportAnIssue => 'समस्या नोंदवा';

  @override
  String get suggestion => 'सूचना';

  @override
  String get whatIsYourIssueRelatedTo => 'तुमची समस्या कशाशी संबंधित आहे?';

  @override
  String get shortDescriptionHint =>
      'आम्हाला थोडक्यात वर्णन द्या (जास्तीत जास्त २०० अक्षरे)';

  @override
  String get selectCallSlot => 'कॉलची वेळ निवडा';

  @override
  String get myIssues => 'माझ्या समस्या';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get forceMigrate => 'फोर्स मायग्रेट';

  @override
  String get forceMigrateDesc1 =>
      'दैनंदिन राइड्स दुरुस्त करण्यासाठी हा पर्याय वापरा.';

  @override
  String get forceMigrateDesc2 => 'हे केवळ स्थानिकीकृत डेटा स्थलांतरित करते.';

  @override
  String get faq => 'वारंवार विचारले जाणारे प्रश्न';

  @override
  String get termsConditions => 'नियम आणि अटी';

  @override
  String get privacyPolicy => 'गोपनीयता धोरण';

  @override
  String get changeLog => 'बदल लॉग';

  @override
  String get todayLabel => '(आज)';

  @override
  String get ridingBehaviour => 'रायडिंग वर्तणूक';

  @override
  String get ridingBehaviourVacationDesc =>
      'निवडलेल्या कालावधीत तुम्ही कोणतीही राइड घेतली नाही';

  @override
  String get journey => 'प्रवास';

  @override
  String get distanceTravelled => 'कापलेले अंतर';

  @override
  String get timeDuration => 'कालावधी';

  @override
  String get speed => 'वेग';

  @override
  String get averageSpeed => 'सरासरी वेग';

  @override
  String get topSpeed => 'कमाल वेग';

  @override
  String get fuel => 'इंधन';

  @override
  String get fuelConsumed => 'वापरलेले इंधन';

  @override
  String get fuelCost => 'इंधनाचा खर्च';

  @override
  String vsPreviousPeriod(String value) {
    return 'मागील कालावधीच्या तुलनेत $value%';
  }

  @override
  String get vehicleMakeListEmpty =>
      'Vehicle make list is empty for this selection';

  @override
  String get vehicleModelListEmpty =>
      'Vehicle model list is empty for this selection';
}
