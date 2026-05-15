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
  String get vehicleImage => 'वाहनाची प्रतिमा';

  @override
  String get newLabel => 'NEW';

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
  String get installDeviceDesc =>
      'तुमचे Trackify स्मार्ट डिव्हाइस त्वरित सेट करा';

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
  String get buyTrackifyDevice => 'Trackify डिव्हाइस खरेदी करा';

  @override
  String get lite4G => 'लाईट ४जी';

  @override
  String get swipeToLock => 'लॉक करण्यासाठी स्वाइप करा';

  @override
  String get upgradeToPlus => 'Trackify Plus वर अपग्रेड करा';

  @override
  String get getMoreOutOfTrackify => 'Trackify मधून अधिक मिळवा';

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
  String get noNotifications => 'कोणतीही सूचना सापडली नाही';

  @override
  String get notificationsFetchedSuccessfully =>
      'सूचना यशस्वीरित्या प्राप्त झाल्या';

  @override
  String get errorFetchingNotifications => 'सूचना प्राप्त करताना त्रुटी आली';

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
  String get ridingBehaviour => 'ड्रायव्हिंग वर्तन';

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
      'या निवडीसाठी वाहन निर्माता सूची रिकामी आहे';

  @override
  String get vehicleModelListEmpty => 'या निवडीसाठी वाहन मॉडेल सूची रिकामी आहे';

  @override
  String get deviceInstallation => 'डिव्हाइस इंस्टॉलेशन';

  @override
  String get scanActivationCode => 'सक्रियन कोड स्कॅन करा';

  @override
  String get enterActivationCodeManually =>
      'सक्रियन कोड मॅन्युअली प्रविष्ट करा';

  @override
  String get openTrackifyBoxInstruction =>
      'सक्रियन क्यूआर कोडसाठी अजस बॉक्स उघडा.';

  @override
  String get continueText => 'सुरू ठेवा';

  @override
  String get enterUID => 'UID प्रविष्ट करा';

  @override
  String get enterIMEINumber => 'IMEI नंबर प्रविष्ट करा';

  @override
  String get close => 'बंद करा';

  @override
  String get uidRequired => 'UID आवश्यक आहे';

  @override
  String get imeiRequired => 'IMEI नंबर आवश्यक आहे';

  @override
  String get deviceAssignedSuccess =>
      'डिव्हाइस यशस्वीरित्या वाहनाला नियुक्त केले गेले!';

  @override
  String get assigningDevice => 'डिव्हाइस नियुक्त केले जात आहे...';

  @override
  String get invalidImeiError => 'कृपया वैध १५-अंकी IMEI नंबर प्रविष्ट करा';

  @override
  String get sharedRides => 'सामायिक केलेल्या राइड्स';

  @override
  String get savedRides => 'जतन केलेल्या राईड्स';

  @override
  String get allRides => 'सर्व राईड्स';

  @override
  String get trips => 'ट्रिप्स';

  @override
  String clicked(String value) {
    return '$value क्लिक केले';
  }

  @override
  String get noDailyRides => 'दाखवण्यासाठी कोणत्याही दैनंदिन राईड्स नाहीत';

  @override
  String get getStartedFirstRide => 'तुमची पहिली राईड घेऊन सुरुवात करा';

  @override
  String get durationLabel => 'कालावधी';

  @override
  String get km => 'कि.मी.';

  @override
  String get kmh => 'कि.मी./ता.';

  @override
  String get tripEmptyQuote =>
      '“तुमच्या राईड्स ट्रिपमध्ये गटबद्ध करा, आठवणी जोडा आणि प्रवास पुन्हा जगा”';

  @override
  String ridesCompletedCount(String completed, String total) {
    return 'पूर्ण झालेल्या राईड्स: $completed/$total';
  }

  @override
  String get unlockTripsRequirement =>
      'ट्रिप्स अनलॉक करण्यासाठी किमान 3 राईड्स आवश्यक आहेत';

  @override
  String get createNewTrip => 'नवीन ट्रिप तयार करा';

  @override
  String get startByCreatingTrip => 'नवीन ट्रिप तयार करून सुरुवात करा';

  @override
  String get skip => 'वगळा';

  @override
  String get todayText => 'आज';

  @override
  String get distanceLabel => 'अंतर';

  @override
  String get rideDuration => 'राइडचा कालावधी';

  @override
  String get speedLabel => 'वेग';

  @override
  String get minutesShort => 'मि';

  @override
  String get secondsShort => 'से';

  @override
  String get discoverMoreDesc =>
      'अधिक शोधा — जबरदस्त गोष्टी तुमची वाट पाहत आहेत!';

  @override
  String get serviceLogs => 'सर्व्हिस लॉग';

  @override
  String get safeParking => 'सुरक्षित पार्किंग';

  @override
  String get appUpdates => 'अ‍ॅप अपडेट्स';

  @override
  String get deviceDataPlanLabel => 'डिव्हाइस डेटा प्लॅन';

  @override
  String get deviceWarrantyLabel => 'डिव्हाइस वॉरंटी';

  @override
  String get videoTutorials => 'व्हिडिओ ट्यूटोरियल';

  @override
  String get exploreNow => 'आता शोधा';

  @override
  String get plusLabel => 'प्लस';

  @override
  String get mapStyleLabel => 'मॅप स्टाईल';

  @override
  String get darkStyle => 'डार्क';

  @override
  String get lightStyle => 'लाईट';

  @override
  String get simpleStyle => 'सिंपल';

  @override
  String get satelliteStyle => 'सॅटेलाईट';

  @override
  String get mapOptionsLabel => 'मॅप पर्याय';

  @override
  String get trafficLabel => 'ट्रॅफिक';

  @override
  String get labelsLabel => 'लेबल्स';

  @override
  String get sharedWithMe => 'माझ्यासोबत शेअर केलेले';

  @override
  String get todaysStats => 'आजची आकडेवारी';

  @override
  String parkedSinceTime(String time) {
    return 'पासून पार्क केलेले: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return 'अजून $value किमी जायचे आहे';
  }

  @override
  String get recordViaPhone => 'फोनद्वारे रेकॉर्ड करा';

  @override
  String progressPercentage(String value) {
    return '$value%';
  }

  @override
  String labelColon(String label) {
    return '$label:';
  }

  @override
  String get fuelEmpty => 'ई';

  @override
  String get fuelFull => 'एफ';

  @override
  String get vehicleNamePlaceholder => 'SP 125';

  @override
  String get vehicleNumberPlaceholder => 'MP09QV8269';

  @override
  String get myProfile => 'माझी प्रोफाइल';

  @override
  String get profileCompleteness => 'प्रोफाइल पूर्णता';

  @override
  String lastUpdatedOn(String date) {
    return 'शेवटचे $date रोजी अपडेट केले';
  }

  @override
  String get addProfilePicture => 'तुमचा प्रोफाइल फोटो जोडा';

  @override
  String get personalDetails => 'वैयक्तिक माहिती';

  @override
  String get userNameLabel => 'नाव';

  @override
  String get emailAddressLabel => 'ईमेल पत्ता';

  @override
  String get mobileNumberLabel => 'मोबाईल नंबर';

  @override
  String get countryLabel => 'देश';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get cityLabel => 'शहर';

  @override
  String get medicalInsuranceInfo => 'वैद्यकीय विमा माहिती';

  @override
  String get addMedicalInsuranceInfo => 'वैद्यकीय विमा माहिती जोडा';

  @override
  String get vehicleInsuranceInfo => 'वाहन विमा माहिती';

  @override
  String get editViewVehicleInsuranceDesc =>
      'वाहन सेटिंग्जमध्ये तुमचे वाहन विमा तपशील संपादित करा आणि पहा.';

  @override
  String get myGarageVehiclePath => 'माझी गॅरेज > वाहन';

  @override
  String get emergencyContacts => 'आणीबाणीचे संपर्क';

  @override
  String get addEditEmergencyContactDesc =>
      'वाहन सेटिंग्जमध्ये आणीबाणीच्या संपर्कांची यादी जोडा आणि संपादित करा.';

  @override
  String get smartContactSticker => 'स्मार्ट संपर्क स्टिकर';

  @override
  String get stickerSubtitle =>
      'तुमच्या वाहनाला सुरक्षित आणि स्मार्ट बनवण्याच्या दिशेने एक पाऊल';

  @override
  String get activateContactSticker => 'संपर्क स्टिकर सक्रिय करा';

  @override
  String get buyNewContactSticker => 'नवीन संपर्क स्टिकर खरेदी करा';

  @override
  String get beyondParkingProblems => 'पार्किंगच्या समस्यांच्या पलीकडे';

  @override
  String get noParkings => 'नो पार्किंग';

  @override
  String get emergencies => 'आणीबाणी';

  @override
  String get vehicleTowing => 'वाहन टोइंग';

  @override
  String get getInformedStayConnected =>
      'माहिती मिळवा आणि तुमच्या वाहनाशी कनेक्ट रहा';

  @override
  String get securedCalls => 'सुरक्षित कॉल';

  @override
  String get securedCallsDesc =>
      'इंटरनेट-मास्क्ड कॉल - तुमचा फोन नंबर खाजगी ठेवतो.';

  @override
  String get notificationHistory => 'सूचना इतिहास';

  @override
  String get notificationHistoryDesc =>
      'सर्व वर्तमान आणि मागील सूचनांचा मागोवा ठेवा';

  @override
  String get beInformed => 'माहिती मिळवा';

  @override
  String get beInformedDesc =>
      'जेव्हा कोणी तुमचा QR कोड स्कॅन करेल तेव्हा त्वरित जाणून घ्या आणि जेव्हा ते तुम्हाला कॉल करतील तेव्हा त्वरित कृती करा.';

  @override
  String get controlWhatOthersSee => 'दुसरे काय पाहतात ते नियंत्रित करा';

  @override
  String get controlWhatOthersSeeDesc =>
      'जेव्हा कोणी QR स्कॅन करते तेव्हा दर्शविलेले तपशील सानुकूलित करा.';

  @override
  String get preventFrustrationDamage => 'निराशा आणि नुकसान टाळा';

  @override
  String get preventFrustrationDamageDesc =>
      'अयोग्य पार्किंगमुळे होणारे संघर्ष आणि वाहनाचे नुकसान टाळा.';

  @override
  String get serviceLogsSubtitle =>
      'वाहनाची सर्व्हिस कधीही चुकवू नका. वेळेवर स्मरणपत्रे मिळवा आणि खर्चाचा मागोवा ठेवा, ज्यामुळे तुमचे वाहन उत्तम स्थितीत राहील.';

  @override
  String get addServiceLogs => 'सर्व्हिस नोंदी जोडा';

  @override
  String get uploadServicingBill => 'सर्व्हिस बिल अपलोड करा';

  @override
  String get addImage => 'प्रतिमा जोडा';

  @override
  String get maxFileSizeNote => 'टीप: कमाल फाइल आकार 5MB आहे';

  @override
  String get serviceDate => 'सर्व्हिस दिनांक';

  @override
  String get billingAmount => 'बिलिंग रक्कम';

  @override
  String get serviceCenterName => 'सर्व्हिस सेंटरचे नाव';

  @override
  String get serviceCenterContact => 'सर्व्हिस सेंटर संपर्क';

  @override
  String get additionalNote => 'अतिरिक्त नोंद';

  @override
  String get saveDetails => 'तपशील जतन करा';

  @override
  String get selectVehicle => 'वाहन निवडा';

  @override
  String get liveTab => 'थेट';

  @override
  String get historyTab => 'इतिहास';

  @override
  String get liveLocationSharingActive => 'थेट स्थान शेअरिंग सक्रिय';

  @override
  String get noLiveLocationShared => 'थेट स्थान शेअर केलेले नाही';

  @override
  String get realTimeSharingDesc =>
      'निवडलेल्या संपर्कांसोबत तुमचे स्थान रिअल-टाइममध्ये शेअर केले जात आहे.';

  @override
  String get startSharingPhoneDesc =>
      'तुमचा शोध घेण्यास इतरांना मदत करण्यासाठी तुमच्या फोनचे स्थान शेअर करणे सुरू करा';

  @override
  String get noHistoryAvailable => 'इतिहास उपलब्ध नाही';

  @override
  String get historyDesc => 'मागील स्थान शेअरिंग पूर्ण झाल्यावर येथे दिसेल.';

  @override
  String get stopSharing => 'शेअरिंग थांबवा';

  @override
  String get shareLocation => 'स्थान शेअर करा';

  @override
  String get startSharing => 'शेअरिंग सुरू करा';

  @override
  String get phoneTracking => 'फोन ट्रॅकिंग';

  @override
  String get liveRecordTab => 'थेट रेकॉर्ड';

  @override
  String get statsTab => 'आकडेवारी';

  @override
  String get timeLabel => 'वेळ';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get custom => 'कस्टम';

  @override
  String get quickStats => 'झटपट आकडेवारी';

  @override
  String get totalRides => 'एकूण राईड्स';

  @override
  String get avgSpeed => 'सरासरी वेग';

  @override
  String get totalFuel => 'एकूण इंधन';

  @override
  String get overallDistance => 'एकूण अंतर';

  @override
  String get drivingTime => 'ड्रायव्हिंग वेळ';

  @override
  String get safetyScore => 'सुरक्षा स्कोअर';

  @override
  String get speedAlertInput => 'वेग इशारा इनपुट';

  @override
  String get alertTitle => 'इशारा शीर्षक';

  @override
  String get speedLimitKmH => 'वेग मर्यादा (किमी/तास)';

  @override
  String get timeDurationSec => 'वेळ कालावधी (सेकंद)';

  @override
  String get selectYourVehicle => 'तुमचे वाहन निवडा';

  @override
  String get submit => 'सबमिट करा';

  @override
  String get selectVehiclesOverspeedAlert =>
      'अतिवेग इशारा देण्यासाठी वाहने निवडा';

  @override
  String get selected => 'निवडले';

  @override
  String get sec => 'सेकंद';

  @override
  String get kmHr => 'किमी/तास';

  @override
  String get viewMore => 'अधिक पहा';

  @override
  String get viewLess => 'कमी पहा';

  @override
  String get previousRides => 'मागील राइड्स';

  @override
  String get seeAll => 'सर्व पहा';

  @override
  String get videosYouMightLike => 'तुम्हाला आवडतील असे व्हिडिओ';

  @override
  String get scrollToTop => 'वर स्क्रोल करा';

  @override
  String get noRecentRidesFound => 'कोणत्याही अलीकडील राइड्स सापडल्या नाहीत';

  @override
  String get failedToLoadRides => 'राइड्स लोड करण्यात अयशस्वी';

  @override
  String get hrMin => 'तास:मिनिट';

  @override
  String get vehicleLabel => 'वाहन';

  @override
  String get switchLabel => 'स्विच';

  @override
  String get expiryDate => 'कालबाह्यता तारीख';

  @override
  String get rechargePlans => 'रिचार्ज प्लॅन्स';

  @override
  String get superComboPlan => 'सुपर कॉम्बो प्लान';

  @override
  String get month12Validity => '१२-महिन्यांची वैधता';

  @override
  String get month6Validity => '६-महिन्यांची वैधता';

  @override
  String saveAmount(Object amount) {
    return 'या प्लॅनसह ₹$amount वाचवा';
  }

  @override
  String get superComboPopularity => '९५% वापरकर्ते सुपर कॉम्बो प्लॅन निवडतात';

  @override
  String get appSimRecharge => 'अ‍ॅप आणि सिम रिचार्ज';

  @override
  String get extendedWarranty => 'विस्तारित वॉरंटी';

  @override
  String get plusMembership => 'प्लस मेंबरशिप';

  @override
  String get continueSuperCombo => 'सुपर कॉम्बो प्लॅनसह पुढे जा';

  @override
  String get continue12Month => '१२-महिन्यांच्या प्लॅनसह पुढे जा';

  @override
  String get continue6Month => '६-महिन्यांच्या प्लॅनसह पुढे जा';

  @override
  String get vehicleDocumentsTitle => 'वाहन दस्तऐवज';

  @override
  String get personalDocumentsSubtitle =>
      'तुमचे वाहन दस्तऐवज अपलोड करून सहज उपलब्ध ठेवा';

  @override
  String get vehicleRC => 'वाहन RC';

  @override
  String get insurance => 'विमा';

  @override
  String get puc => 'PUC';

  @override
  String get vehicleRCTitle => 'वाहन RC';

  @override
  String get insuranceTitle => 'विमा तपशील';

  @override
  String get pucTitle => 'PUC प्रमाणपत्र';

  @override
  String get notificationControlsTitle => 'अधिसूचना नियंत्रणे';

  @override
  String get ignitionOnOffTitle => 'इग्निशन ऑन/ऑफ';

  @override
  String get ignitionOnOffDesc =>
      'वाहनाचे इग्निशन चालू किंवा बंद असताना सूचना मिळवा';

  @override
  String get motionWithIgnitionOffTitle => 'इग्निशन बंद असताना हालचाल';

  @override
  String get motionWithIgnitionOffDesc =>
      'इग्निशन बंद असताना वाहन हलल्यावर सूचना मिळवा';

  @override
  String get powerSupplyOffTitle => 'पॉवर सप्लाय बंद';

  @override
  String get powerSupplyOffDesc => 'Trackify ला वीज मिळत नसताना सूचना मिळवा';

  @override
  String get appNotification => 'अ‍ॅप सूचना';

  @override
  String get odometerReading => 'ओडोमीटर वाचन';

  @override
  String get update => 'अपडेट करा';

  @override
  String get gpsReadingNote => 'GPS-आधारित वाचन, किरकोळ फरक असू शकतो.';

  @override
  String get tankCapacity => 'टाकीची क्षमता';

  @override
  String get afterLastRefuel => 'शेवटच्या इंधन भरल्यानंतर';

  @override
  String get fuelRemaining => 'उर्वरित इंधन';

  @override
  String get distanceRemaining => 'उर्वरित अंतर';

  @override
  String get mileageArai => 'मायलेज (ARAI)';

  @override
  String get spendingOnFuel => 'इंधनावरील खर्च';

  @override
  String get today => 'आज';

  @override
  String get thisWeek => 'या आठवड्यात';

  @override
  String get thisMonth => 'या महिन्यात';

  @override
  String get thisYear => 'या वर्षी';

  @override
  String get all => 'सर्व';

  @override
  String get customDates => 'सानुकूल तारखा';

  @override
  String get refuelHistory => 'इंधन भरण्याचा इतिहास';

  @override
  String get addRefuelingDetails => 'इंधन भरण्याचे तपशील जोडा';

  @override
  String get fuelStations => 'इंधन स्टेशन';

  @override
  String get dashboard => 'डॅशबोर्ड';

  @override
  String get litersShort => 'लि';

  @override
  String get fuelEstimateNote =>
      'ही मूल्ये तुमच्या इंधन नोंदींवर आधारित अंदाज आहेत. अधिक अचूकतेसाठी नियमितपणे इंधन नोंदी जोडा.';

  @override
  String get gotIt => 'समजले';

  @override
  String get currentOdometerReading => 'वर्तमान ओडोमीटर वाचन';

  @override
  String get odometerUpdateDesc =>
      'अचूक इंधन आणि अंतर अंदाजासाठी नियमितपणे तुमचा ओडोमीटर अपडेट करा';

  @override
  String get updateTankCapacity => 'टाकीची क्षमता अपडेट करा';

  @override
  String get tankCapacityDesc =>
      'तुमच्या वाहनाच्या टाकीची कमाल इंधन क्षमता प्रविष्ट करा';

  @override
  String get litres => 'लिटर';

  @override
  String get kms => 'किमी';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String get updateMileageArai => 'मायलेज (ARAI) अपडेट करा';

  @override
  String get mileageDesc =>
      'अचूक इंधन आणि अंतर अंदाजासाठी वर्तमान मायलेज (किमी/लि) प्रविष्ट करा.';

  @override
  String get kmL => 'किमी/लि';

  @override
  String get serviceLogAddedSuccess => 'सर्व्हिस लॉग यशस्वीरित्या जोडला गेला';

  @override
  String get currencySymbol => '₹';

  @override
  String get refuelHistoryComingSoon => 'इंधन भरण्याचा इतिहास लवकरच येत आहे';

  @override
  String get fuelStationsComingSoon => 'इंधन स्टेशन लवकरच येत आहेत';

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String get totalFuelAdded => 'एकूण जोडलेले इंधन';

  @override
  String get totalSpendings => 'एकूण खर्च';

  @override
  String get avgMileage => 'सरासरी मायलेज';

  @override
  String get refuels => 'इंधन भरल्याची संख्या';

  @override
  String get refuelingHistory => 'इंधन भरण्याचा इतिहास';

  @override
  String get newestFirst => 'नवीनतम आधी';

  @override
  String get oldestFirst => 'सर्वात जुने आधी';

  @override
  String get mostExpensive => 'सर्वात महाग';

  @override
  String get leastExpensive => 'सर्वात स्वस्त';

  @override
  String get bestMileage => 'सर्वोत्तम मायलेज';

  @override
  String get worstMileage => 'सर्वात खराब मायलेज';

  @override
  String get edit => 'संपादन करा';

  @override
  String get delete => 'हटवा';

  @override
  String get error => 'काहीतरी चुकले';

  @override
  String get noDataAvailable => 'कोणताही डेटा उपलब्ध नाही';

  @override
  String hintEg(String value) {
    return 'उदा., $value';
  }

  @override
  String get addStation => 'स्टेशन जोडा';

  @override
  String get nearby => 'जवळपास';

  @override
  String get favourites => 'आवडते';

  @override
  String get addedByMe => 'माझ्याद्वारे जोडलेले';

  @override
  String get noFavourites => 'अद्याप कोणतेही आवडते नाहीत';

  @override
  String get noStationsAdded => 'अद्याप कोणतीही स्टेशन जोडलेली नाहीत';

  @override
  String get fuelStationNearVehicle => 'वाहनाजवळचे इंधन स्टेशन';

  @override
  String get warranty_title => 'डिव्हाइस वॉरंटी';

  @override
  String get warranty_benefitsTitle => 'तुम्ही गमावू इच्छित नसलेले फायदे';

  @override
  String get warranty_extend =>
      'तुमच्या Trackify Lite ची वॉरंटी 1 वर्षासाठी वाढवा @ ₹1/दिवस';

  @override
  String get warranty_vehicle => 'वाहन';

  @override
  String get warranty_expiry => 'वॉरंटी संपण्याची तारीख';

  @override
  String get warranty_button => 'आता वॉरंटी वाढवा @ ₹365 ';

  @override
  String get warranty_button_old => '₹730';

  @override
  String get benefit1_highlight => 'हमी बदली';

  @override
  String get benefit1_normal => ' बिघाड झाल्यास';

  @override
  String get benefit2_highlight => '₹1200 पर्यंत बचत करा';

  @override
  String get benefit2_normal => ' डिव्हाइस दुरुस्तीवर';

  @override
  String get benefit3_highlight => 'झटपट सपोर्ट';

  @override
  String get benefit3_normal => ' डिव्हाइस संबंधित समस्यांसाठी';

  @override
  String get benefit4_highlight =>
      '₹2000 पर्यंत विनामूल्य विस्तारित सबस्क्रिप्शन';

  @override
  String get benefit4_normal => ' सदोष कालावधीसाठी';

  @override
  String get initiatingEmergencyAlert =>
      'Trackify वापरकर्त्यांना आपत्कालीन सूचना पाठवली जात आहे';

  @override
  String get pleaseUseResponsibly => 'कृपया जबाबदारीने वापरा';

  @override
  String get secondsBeforeSendingAlert => 'सूचना पाठवण्यापूर्वी सेकंद';

  @override
  String get sendNow => 'आता पाठवा';

  @override
  String get geoFenceTitle => 'जिओ-फेन्स';

  @override
  String geoFenceRadius(String radius) {
    return 'त्रिज्या: $radiusमी';
  }

  @override
  String get geoFenceLocating => 'स्थान शोधत आहे...';

  @override
  String get geoFenceNameRequired => 'कृपया जिओ-फेन्स नाव प्रविष्ट करा';

  @override
  String get geoFenceSaveSuccess => 'जिओ-फेन्स यशस्वीरित्या जतन केला!';

  @override
  String get geoFenceSearchHint => 'स्थान शोधा...';

  @override
  String get geoFenceSelectType => 'साठी जिओ-फेन्स प्रकार निवडा ';

  @override
  String get geoFenceTypeHome => 'घर';

  @override
  String get geoFenceTypeOffice => 'कार्यालय';

  @override
  String get geoFenceTypeFamily => 'कुटुंब';

  @override
  String get geoFenceTypeParking => 'पार्किंग';

  @override
  String get geoFenceTypeOthers => 'इतर';

  @override
  String get geoFenceNameFieldHint => 'जिओ-फेन्स नाव प्रविष्ट करा, उदा: घर';

  @override
  String get geoFenceAddSmsContacts => 'SMS अलर्टसाठी संपर्क जोडा';

  @override
  String get geoFenceEmptyStateDesc =>
      'नकाशावर वर्तुळ काढा आणि जेव्हा बाईक वर्तुळात प्रवेश करते किंवा बाहेर पडते तेव्हा अलर्ट मिळवा.';

  @override
  String get addGeoFenceButton => 'जिओ-फेन्स जोडा';

  @override
  String get safeParkingTitle => 'सुरक्षित पार्किंग';

  @override
  String get schedule => 'वेळापत्रक';

  @override
  String get setupSafeParking => 'सुरक्षित पार्किंग सेट करा';

  @override
  String get safeParkingSubtitle =>
      'इंजिन सुरू आणि टोइंग अलर्टसाठी कॉल अलर्ट मिळवा';

  @override
  String get activate => 'सक्रिय करा';

  @override
  String get activated => 'सक्रिय झाले';

  @override
  String get safeParkingDescription =>
      'इंजिन सुरू झाल्यावर किंवा टोइंग आढळल्यावर अलर्ट सक्षम करा';

  @override
  String get geoFenceDeleteConfirmation =>
      'तुम्हाला खात्री आहे की तुम्ही हा जिओ-फेन्स हटवू इच्छिता?';

  @override
  String get geoFenceTurnOffConfirmation =>
      'तुम्हाला खात्री आहे की तुम्ही हा जिओ-फेन्स बंद करू इच्छिता?';

  @override
  String get turnOff => 'बंद करा';

  @override
  String get plusMembershipTitle => 'प्लस सदस्यता';

  @override
  String get membership => 'सदस्यता';

  @override
  String get premiumBenefits => 'प्रीमियम फायदे';

  @override
  String get otherBenefits => 'इतर फायदे';

  @override
  String get trackifyPlusReviews => 'ट्रॅकिफाय प्लस रिव्ह्यू';

  @override
  String get offerings => 'ऑफरिंग्ज';

  @override
  String get plus => 'प्लस';

  @override
  String get regular => 'नियमित';

  @override
  String upgradeNowAtJust(String price) {
    return 'आत्ताच अपग्रेड करा फक्त ₹$price मध्ये';
  }

  @override
  String get viewMoreReviews => 'अधिक रिव्ह्यू पहा';

  @override
  String get speciallyForYou => 'खास तुमच्यासाठी';

  @override
  String get footerMotto =>
      'प्रत्येक बाईक स्मार्ट आणि प्रत्येक रायडर सुरक्षित\nअसेल अशा भविष्याची निर्मिती करत आहोत';

  @override
  String get cropDocument => 'दस्तऐवज क्रॉप करा';

  @override
  String get cropVehicleImage => 'वाहन प्रतिमा क्रॉप करा';

  @override
  String get uploadImage => 'प्रतिमा अपलोड करा';

  @override
  String get camera => 'कॅमेरा';

  @override
  String get gallery => 'गॅलरी';

  @override
  String get pdf => 'PDF';

  @override
  String get fileTooLarge => 'फाइलचा आकार 5MB मर्यादेपेक्षा जास्त आहे';

  @override
  String get pickImageError => 'प्रतिमा निवडताना त्रुटी आली';

  @override
  String get pickPdfError => 'PDF निवडताना त्रुटी आली';

  @override
  String get pdfTooLarge => 'PDF चा आकार 5MB मर्यादेपेक्षा जास्त आहे';

  @override
  String get uploadDocuments => 'दस्तऐवज अपलोड करा';

  @override
  String get frontSide => 'समोरील बाजू';

  @override
  String get backSide => 'मागील बाजू';

  @override
  String get commitmentText =>
      'आम्ही तुमची गोपनीयता जपण्यासाठी आणि तुमचे दस्तऐवज सुरक्षित ठेवण्यासाठी वचनबद्ध आहोत.';

  @override
  String get documentsSafe => 'तुमचे दस्तऐवज आमच्यासोबत सुरक्षित आहेत';

  @override
  String get addDocument => 'दस्तऐवज जोडा';

  @override
  String get frontRequired => 'समोरील दस्तऐवज आवश्यक आहे';

  @override
  String get successMessage => 'दस्तऐवज यशस्वीरित्या जतन केला';

  @override
  String get selectExpiryDate => 'कालबाह्यता तारीख निवडा';

  @override
  String get documentsEncrypted =>
      'तुमचे दस्तऐवज एन्क्रिप्टेड आणि सुरक्षित आहेत';

  @override
  String get fileSizeNote => 'टीप: कमाल फाइल आकार 5MB आहे';

  @override
  String get personalDocumentsTitle => 'वैयक्तिक दस्तऐवज';

  @override
  String get drivingLicense => 'ड्रायव्हिंग लायसन्स';

  @override
  String get drivingLicenseTitle => 'ड्रायव्हिंग लायसन्स';

  @override
  String get otherDocuments => 'इतर दस्तऐवज';

  @override
  String get otherDocumentTitle => 'इतर दस्तऐवज';

  @override
  String get documentName => 'दस्तऐवजाचे नाव*';

  @override
  String get billsTitle => 'बिले';

  @override
  String get billsDescription =>
      'तुमच्या वाहनाशी संबंधित बिले अपलोड आणि व्यवस्थापित करा';

  @override
  String get movedTo => 'हलवले गेले';

  @override
  String get viewNow => 'आता पहा';

  @override
  String get accessoryBills => 'अॅक्सेसरी बिले';

  @override
  String get tutorialVideos => 'ट्युटोरियल व्हिडिओ';

  @override
  String get videos => 'व्हिडिओ';

  @override
  String get location => 'स्थान';

  @override
  String get amazingFeatures => 'उत्तम वैशिष्ट्ये';

  @override
  String get loading => 'लोड होत आहे...';

  @override
  String get noVideos => 'कोणतेही व्हिडिओ उपलब्ध नाहीत';

  @override
  String get apply => 'लागू करा';

  @override
  String get noRecordsFound => 'कोणतेही रेकॉर्ड सापडले नाहीत';

  @override
  String get selectDateRange => 'तारीख श्रेणी निवडा';

  @override
  String get notificationTypes => 'अधिसूचना प्रकार';

  @override
  String get motionSensed => 'हालचाल आढळली';

  @override
  String get ignitionOff => 'इग्निशन बंद';

  @override
  String get ignitionOn => 'इग्निशन सुरू';

  @override
  String get accidentDetected => 'अपघात आढळला';

  @override
  String get stationaryFallDetected => 'स्थिर पडणे आढळले';

  @override
  String get vehicleSwitchedOff => 'वाहन बंद झाले';

  @override
  String get vehicleSwitchedOn => 'वाहन सुरू झाले';

  @override
  String get powerSupplyOn => 'पावर सप्लाय सुरू';

  @override
  String get vibrationSensed => 'कंपन आढळले';

  @override
  String get editVehicle => 'वाहन संपादित करा';

  @override
  String get diesel => 'डिझेल';

  @override
  String get cng => 'सीएनजी';

  @override
  String get updateVehicle => 'वाहन अपडेट करा';

  @override
  String get vehicleMileage => 'वाहनाचे मायलेज';

  @override
  String get notificationControls => 'अधिसूचना नियंत्रणे';

  @override
  String get changeNotificationPreferences =>
      'तुमच्या अधिसूचना प्राधान्ये बदला';

  @override
  String get unmapTrackify => 'तुमचे ट्रॅकिफाय अन-मॅप करा';

  @override
  String get unmapStep1 =>
      'हंत १: डिव्हाइस अन-मॅप करण्यासाठी, +९१८०६१९७१४४३ वर कॉल करा';

  @override
  String get unmapStep2 => 'हंत २: वाहन काढून टाका';

  @override
  String get updateMileage => 'मायलेज अपडेट करा';

  @override
  String get lastUpdated => 'शेवटचे अपडेट: ';

  @override
  String get lockUnlockVehicle => 'वाहन लॉक आणि अनलॉक';

  @override
  String get sleepModeWarning =>
      'डिव्हाइस स्लीप मोडमध्ये असल्यास तुमचे वाहन लॉक / अनलॉक होणार नाही.';

  @override
  String get journeyWithTrackify => 'Trackify सह प्रवास';

  @override
  String get lifetime => 'आजीवन';

  @override
  String hrMinFormat(Object hr, Object min) {
    return '$hr तास $min मिनिटे';
  }

  @override
  String get yourVehicleOnMap => 'नकाशावर तुमचे वाहन';

  @override
  String get selectIcon => 'आयकॉन निवडा';

  @override
  String get bike => 'बाईक';

  @override
  String get scooty => 'स्कूटी';

  @override
  String get myVehicle => 'माझे वाहन';

  @override
  String get selectColor => 'रंग निवडा';

  @override
  String get white => 'पांढरा';

  @override
  String get red => 'लाल';

  @override
  String get aqua => 'एक्वा';

  @override
  String get orange => 'केशरी';

  @override
  String get sky => 'आकाशी';

  @override
  String get saveChanges => 'बदल जतन करा';

  @override
  String get whatIsSleepMode => 'स्लीप मोड म्हणजे काय?';

  @override
  String get sleepModeDesc1 =>
      'जेव्हा Trackify डिव्हाइसला कोणतीही हालचाल किंवा कंपन जाणवत नाही, तेव्हा ते वाहनाची बॅटरी वाचवण्यासाठी स्वयंचलितपणे स्लीप मोडमध्ये जाते.';

  @override
  String get sleepModeDesc2 =>
      'जेव्हा डिव्हाइसला हालचाल जाणवते आणि ते चांगल्या नेटवर्क कव्हरेजमध्ये असते, तेव्हा ते त्वरित सक्रिय होते आणि ट्रॅकिंग सुरू करते.';

  @override
  String get hr => 'तास';

  @override
  String get min => 'मि';

  @override
  String get filters => 'फिल्टर्स';

  @override
  String get tankCapacityHint => 'उदा. १३';

  @override
  String get mileageHint => 'उदा. ५०';

  @override
  String get powerSupplyOff => 'पॉवर सप्लाय बंद';

  @override
  String get lastUpdatedLabel => 'शेवटचे अपडेट: ';

  @override
  String get litresShort => 'लि.';

  @override
  String get discoverTrackifyFeatures => 'ट्रॅकिफाय वैशिष्ट्ये शोधा';

  @override
  String get checkout => 'चेकआउट';

  @override
  String get address => 'पत्ता';

  @override
  String get summary => 'सारांश';

  @override
  String get pleaseEnterDetails => 'कृपया खालील माहिती भरा';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get houseFloorLine => 'घर, मजला, लाईन';

  @override
  String get landmark => 'ओळख चिन्ह';

  @override
  String get pinCode => 'पिन कोड';

  @override
  String get homeAddress => 'घराचा पत्ता';

  @override
  String get officeAddress => 'ऑफिसचा पत्ता';

  @override
  String get product => 'उत्पादने';

  @override
  String get errorPickingImage => 'प्रतिमा निवडण्यात त्रुटी';

  @override
  String get frontDocumentRequired => 'पुढील बाजूची दस्तऐवज प्रतिमा आवश्यक आहे';

  @override
  String get documentUploadedSuccessfully => 'दस्तऐवज यशस्वीरित्या अपलोड झाले';

  @override
  String get addAccessoryBill => 'एक्सेसरी बिल जोडा';

  @override
  String get accessoryName => 'एक्सेसरीचे नाव';

  @override
  String get billingDate => 'बिलिंग तारीख';

  @override
  String get shopName => 'दुकानाचे नाव';

  @override
  String get shopContact => 'दुकान संपर्क';

  @override
  String get uploadBill => 'बिल अपलोड करा';

  @override
  String get yearExtendedWarranty => '1 वर्षाची विस्तारित वॉरंटी';

  @override
  String get paymentSummary => 'पेमेंट सारांश';

  @override
  String get boosterOffer => 'बूस्टर ऑफर @50% सूट';

  @override
  String get toPay => 'देय रक्कम';

  @override
  String amountPayable(String amount) {
    return 'देय रक्कम $amount';
  }

  @override
  String get distance => 'अंतर';

  @override
  String get recentToOldest => 'अलीकडील ते जुने';

  @override
  String get sorting => 'वर्गीकरण';

  @override
  String get backToDefault => 'डीफॉल्टवर परत जा';

  @override
  String get sortBy => 'याद्वारे वर्गीकरण';

  @override
  String get duration => 'कालावधी';

  @override
  String get oldestToRecent => 'जुन्यापासून अलीकडीलपर्यंत';

  @override
  String get date => 'तारीख';

  @override
  String noTripsFound(String query) {
    return '\"$query\" साठी कोणतीही ट्रिप सापडली नाही';
  }

  @override
  String ridesCount(String count) {
    return '$count राइड्स';
  }

  @override
  String get searchTrips => 'ट्रिप शोधा';

  @override
  String get searchRides => 'राइड्स शोधा';

  @override
  String get notAvailable => 'उपलब्ध नाही';

  @override
  String get start => 'सुरुवात';

  @override
  String get end => 'समाप्त';

  @override
  String get yesImSure => 'हो, मला खात्री आहे';

  @override
  String get topSpeedLabel => 'कमाल वेग';

  @override
  String get rideDurationLabel => 'राइडचा कालावधी';

  @override
  String get editRides => 'राइड्स संपादित करा';

  @override
  String get tripDetails => 'ट्रिप तपशील';

  @override
  String get tripQuoteLabel => 'ट्रिप कोट';

  @override
  String get unmerge => 'अनमर्ज करा';

  @override
  String get tripNameLabel => 'ट्रिपचे नाव';

  @override
  String get deleteTripConfirmation =>
      'हे तुमची ट्रिप कायमची हटवेल. तुम्हाला खात्री आहे का?';

  @override
  String get tripStats => 'ट्रिप आकडेवारी';

  @override
  String get avgSpeedLabel => 'सरासरी वेग';

  @override
  String get tripQuoteDefault =>
      'प्रत्येक ट्रिपची एक गोष्ट असते. तुमची गोष्ट इथे आहे.';

  @override
  String get deleteTrip => 'ट्रिप हटवा';

  @override
  String get hrLabel => 'तास';

  @override
  String ridesSelectedSummary(String count, String distance, String duration) {
    return '$count राइड्स निवडल्या | $distance किमी • $duration';
  }

  @override
  String get clearSelection => 'निवड रद्द करा';

  @override
  String get secLabel => 'सेकंद';

  @override
  String get minLabel => 'मिनिट';

  @override
  String get selectionTooltipMessage =>
      'आपण आपल्या ट्रिपमध्ये जोडू इच्छित असलेल्या राइड्स निवडा.';

  @override
  String get selectRides => 'राइड्स निवडा';

  @override
  String get createTrip => 'ट्रिप तयार करा';

  @override
  String get bestAverageSpeed => 'सर्वोत्तम सरासरी वेग';

  @override
  String get topSpeedClocked => 'नोंदवलेला उच्च वेग';

  @override
  String get searchTripsHint => 'नावाने ट्रिप शोधा';

  @override
  String noRidesFound(String query) {
    return '\"$query\" साठी कोणतीही राइड सापडली नाही';
  }

  @override
  String tripLabel(String number) {
    return 'ट्रिप $number';
  }

  @override
  String get extraordinaryTrips => 'विलक्षण ट्रिप';

  @override
  String get maxDistanceCovered => 'कापलेले कमाल अंतर';

  @override
  String get searchRidesHint => 'शहराद्वारे राइड्स शोधा';

  @override
  String get healthInsurance => 'आरोग्य विमा';

  @override
  String get bloodGroup => 'रक्तगट';

  @override
  String get selectBloodGroup => 'रक्तगट निवडा';

  @override
  String get healthInsuranceCardNumber => 'आरोग्य विमा कार्ड क्रमांक';

  @override
  String get policyNumber => 'पॉलिसी क्रमांक';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफाइल यशस्वीरित्या अपडेट झाले';

  @override
  String get editEmailAddress => 'ईमेल पत्ता संपादित करा';

  @override
  String get emailAddress => 'ईमेल पत्ता';

  @override
  String get emailNotVerified => 'ईमेल सत्यापित नाही';

  @override
  String get saveAndVerify => 'जतन करा आणि सत्यापित करा';

  @override
  String get editMobileNumber => 'मोबाईल नंबर संपादित करा';

  @override
  String get tenDigitMobileNumber => 'दहा अंकी मोबाईल नंबर';

  @override
  String get firstName => 'पहिले नाव';

  @override
  String get middleName => 'मधले नाव';

  @override
  String get lastName => 'आडनाव';

  @override
  String get required => 'आवश्यक';

  @override
  String get dateOfBirth => 'जन्मतारीख';

  @override
  String get optional => '(पर्यायी)';

  @override
  String get selectCountry => 'देश निवडा';

  @override
  String get selectState => 'राज्य निवडा';

  @override
  String get selectCity => 'शहर निवडा';

  @override
  String get enterAddress => 'पत्ता प्रविष्ट करा (कमाल 100 अक्षरे)';

  @override
  String get india => 'भारत';

  @override
  String get usa => 'अमेरिका';

  @override
  String get uk => 'युनायटेड किंगडम';

  @override
  String get uae => 'यूएई';

  @override
  String get madhyaPradesh => 'मध्य प्रदेश';

  @override
  String get maharashtra => 'महाराष्ट्र';

  @override
  String get rajasthan => 'राजस्थान';

  @override
  String get gujarat => 'गुजरात';

  @override
  String get karnataka => 'कर्नाटक';

  @override
  String get tamilNadu => 'तामिळनाडू';

  @override
  String get uttarPradesh => 'उत्तर प्रदेश';

  @override
  String get delhi => 'दिल्ली';

  @override
  String get indoreDistrict => 'इंदूर जिल्हा';

  @override
  String get bhopal => 'भोपाळ';

  @override
  String get gwalior => 'ग्वाल्हेर';

  @override
  String get jabalpur => 'जबलपूर';

  @override
  String get ujjain => 'उज्जैन';

  @override
  String get notificationSounds => 'सूचना ध्वनी';

  @override
  String get changeSoundForNotification => 'वेगवेगळ्या सूचनेसाठी ध्वनी बदला';

  @override
  String get vibrationAlert => 'कंपण सूचना';

  @override
  String get motionAlert => 'हालचाल सूचना';

  @override
  String get ignitionAlert => 'इग्निशन सूचना';

  @override
  String get fallAlert => 'पडल्याची सूचना';

  @override
  String get batteryAlert => 'बॅटरी सूचना';

  @override
  String get geofenceAlert => 'जिओफेन्स सूचना';

  @override
  String get speedAlert => 'वेग सूचना';

  @override
  String get otherAlert => 'इतर सूचना';

  @override
  String get customNotification => 'सानुकूल सूचना';

  @override
  String get orderSummary => 'ऑर्डर सारांश';

  @override
  String get selectedPlan => 'निवडलेला प्लान';

  @override
  String get validity => 'वैधता';

  @override
  String greatSaving(Object amount) {
    return 'छान! या प्लानमुळे ₹$amount ची बचत';
  }

  @override
  String get billSummary => 'बिल सारांश';

  @override
  String get planPrice => 'प्लान किंमत';

  @override
  String get discount => 'सवलत';

  @override
  String get total => 'एकूण';

  @override
  String get gstTaxes => 'GST (सरकारी कर)';

  @override
  String payAmount(Object amount) {
    return '₹$amount भरा';
  }

  @override
  String get liveRecord => 'लाईव्ह रेकॉर्ड';

  @override
  String get history => 'इतिहास';

  @override
  String get stats => 'आकडेवारी';

  @override
  String get lastReportedPosition => 'शेवटचे नोंदवलेले स्थान';

  @override
  String get time => 'वेळ';

  @override
  String get appUpdate => 'अॅप अपडेट';
}
