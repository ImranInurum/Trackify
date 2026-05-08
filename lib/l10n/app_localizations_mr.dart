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
  String get mobileNumber => 'मोबाइल नंबर';

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
  String get vehicleImage => 'Vehicle Image';

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
  String get personalDetails => 'वैयक्तिक तपशील';

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
  String get billingAmount => 'बिल रक्कम';

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
  String get notificationControlsTitle => 'Notification Controls';

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
  String get addRefuelingDetails => 'Add refueling details';

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
  String get gotIt => 'समजले';

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
  String get cancel => 'रद्द करा';

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
  String get addDocument => 'Add Document';

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
  String get discoverTrackifyFeatures => 'Discover Trackify Features';

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
}
