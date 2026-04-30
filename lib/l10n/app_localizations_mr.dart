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
  String get letsGetStarted => 'चला सुरुवात करूया';

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
  String get signIn => 'साइन इन';

  @override
  String get or => 'किंवा';

  @override
  String get dontHaveAccount => 'तुमच्याकडे खाते नाही? ';

  @override
  String get signUp => 'साइन अप';

  @override
  String welcome(String email) {
    return 'स्वागत आहे $email!';
  }

  @override
  String get loginFailed => 'लॉगिन अयशस्वी';

  @override
  String get name => 'नाव';

  @override
  String get nameHint => 'John Doe';

  @override
  String get nameRequired => 'नाव आवश्यक आहे';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get mobileNumberHint => 'मोबाइल नंबर टाका';

  @override
  String get mobileNumberRequired => 'मोबाइल नंबर आवश्यक आहे';

  @override
  String get invalidMobileNumber => 'कृपया वैध मोबाइल नंबर टाका';

  @override
  String get country => 'देश';

  @override
  String get countryHint => 'देश टाका';

  @override
  String get countryRequired => 'देश आवश्यक आहे';

  @override
  String get state => 'राज्य';

  @override
  String get stateHint => 'राज्य टाका';

  @override
  String get stateRequired => 'राज्य आवश्यक आहे';

  @override
  String get city => 'शहर';

  @override
  String get cityHint => 'शहर टाका';

  @override
  String get cityRequired => 'शहर आवश्यक आहे';

  @override
  String get selectProfileImage => 'प्रोफाइल प्रतिमा निवडा';

  @override
  String get role => 'भूमिका';

  @override
  String get roleAdmin => 'अॅडमिन';

  @override
  String get roleCustomer => 'ग्राहक';

  @override
  String get selectRoleHint => 'भूमिका निवडा';

  @override
  String get roleRequired => 'कृपया भूमिका निवडा';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get registerSuccess =>
      'वापरकर्ता यशस्वीरित्या नोंदणीकृत झाला, कृपया लॉगिन करा';

  @override
  String get signUpFailed => 'साइन अप अयशस्वी';

  @override
  String get alreadyHaveAccount => 'तुमच्याकडे आधीच खाते आहे?';

  @override
  String get otpSent => 'OTP यशस्वीरित्या पाठवला';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करा';

  @override
  String get resetPasswordDesc =>
      'तुमचा ईमेल टाका, आम्ही तुम्हाला पासवर्ड रीसेट करण्यासाठी लिंक पाठवू.';

  @override
  String get sendResetLink => 'रीसेट लिंक पाठवा';

  @override
  String get otpVerified => 'OTP यशस्वीरित्या पडताळला';

  @override
  String get verifyOtp => 'OTP पडताळा';

  @override
  String get otpHeader => 'OTP पडताळणी';

  @override
  String otpDesc(String email) {
    return '$email वर पाठवलेला OTP टाका.';
  }

  @override
  String get otp => 'OTP';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'OTP आवश्यक आहे';

  @override
  String get passwordResetSuccess => 'पासवर्ड यशस्वीरित्या रीसेट झाला';

  @override
  String get createNewPassword => 'नवीन पासवर्ड तयार करा';

  @override
  String get passwordDesc =>
      'तुमचा नवीन पासवर्ड आधी वापरलेल्या पासवर्डपेक्षा वेगळा असावा.';

  @override
  String get newPassword => 'नवीन पासवर्ड';

  @override
  String get newPasswordHint => 'नवीन पासवर्ड टाका';

  @override
  String get passwordMinLength => 'पासवर्ड किमान 6 अक्षरांचा असावा';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टी करा';

  @override
  String get confirmPasswordHint => 'तुमचा नवीन पासवर्ड पुष्टी करा';

  @override
  String get confirmPasswordRequired => 'पासवर्ड पुष्टी आवश्यक आहे';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get selectDevice => 'डिव्हाइस निवडा';

  @override
  String get noDevicesFound => 'कोणतेही डिव्हाइस आढळले नाही.';

  @override
  String get proceed => 'पुढे जा';

  @override
  String get unknownDevice => 'अज्ञात डिव्हाइस';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'डिव्हाइस मिळवण्यासाठी प्रारंभ करा.';

  @override
  String get recordRide => 'राइड रेकॉर्ड करा';

  @override
  String get phoneAsGps => 'तुमचा फोन GPS ट्रॅकिंग डिव्हाइस बनवा';

  @override
  String get goToDashboard => 'डॅशबोर्डला जा';

  @override
  String get seeFullMap => 'पूर्ण नकाशा पहा';

  @override
  String get exploreMore => 'अधिक एक्सप्लोर करा';

  @override
  String get reachMeSticker => 'ReachMe स्टिकर';

  @override
  String get products => 'उत्पादने';

  @override
  String get fuelLogs => 'इंधन नोंदी';

  @override
  String get locationSharing => 'लोकेशन शेअरिंग';

  @override
  String get documentFolder => 'डॉक्युमेंट फोल्डर';

  @override
  String get voiceMonitoring => 'व्हॉइस मॉनिटरिंग';

  @override
  String get remoteEngineOff => 'रिमोट इंजिन ऑफ';

  @override
  String get networkBooster => 'नेटवर्क बूस्टर';

  @override
  String get emergency => 'आपत्कालीन';

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
      '1000+ लोकांनी आमच्या डिव्हाइसने त्यांची बाईक स्मार्ट बनवली आहे';

  @override
  String get features => 'वैशिष्ट्ये';

  @override
  String get contactUs => 'आमच्याशी संपर्क साधा';

  @override
  String get contactUsDesc => 'प्रश्न आहेत? आम्ही मदतीसाठी आहोत.';

  @override
  String get userReviews => 'वापरकर्त्यांचे अभिप्राय';

  @override
  String get accidentAlert => 'अपघात अलर्ट';

  @override
  String get antiTheftAlert => 'चोरीविरोधी अलर्ट';

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
  String get subscription => 'सदस्यता';

  @override
  String get proPlan => 'प्रो प्लॅन';

  @override
  String get initializeGarage => 'तुमचे गॅरेज मिळवण्यासाठी प्रारंभ करा.';

  @override
  String get ourProducts => 'आमची उत्पादने';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'जास्तीत जास्त वैशिष्ट्यांसह प्रगत ट्रॅकिंग';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'दररोजच्या वापरासाठी स्टँडर्ड ट्रॅकिंग';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'मूलभूत लोकेटर डिव्हाइस';

  @override
  String get realTime1s => 'रिअल-टाइम 1 सेकंद ट्रॅकिंग';

  @override
  String get remoteEngineCutOff => 'रिमोट इंजिन कट-ऑफ';

  @override
  String get detailedFuelAnalytics => 'सविस्तर इंधन विश्लेषण';

  @override
  String get realTime5s => 'रिअल-टाइम 5 सेकंद ट्रॅकिंग';

  @override
  String get antiTheftAlerts => 'चोरीविरोधी अलर्ट';

  @override
  String get basicJourneyLogs => 'मूलभूत प्रवास नोंदी';

  @override
  String get locationUpdates => 'लोकेशन अपडेट्स';

  @override
  String get batteryMonitor => 'बॅटरी मॉनिटर';

  @override
  String get featuresLabel => 'वैशिष्ट्ये:';

  @override
  String addedToCart(String title) {
    return '$title कार्टमध्ये जोडले!';
  }

  @override
  String get buyNow => 'आता खरेदी करा';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String errorMsg(String message) {
    return 'त्रुटी: $message';
  }

  @override
  String get addVehicle => 'वाहन/डिव्हाइस जोडा';

  @override
  String get vehicleAdded => 'वाहन यशस्वीरित्या जोडले!';

  @override
  String get vehicleType => 'वाहनाचा प्रकार';

  @override
  String get twoWheeler => 'दुचाकी';

  @override
  String get fourWheeler => 'चारचाकी';

  @override
  String get autoRickshaw => 'ऑटो रिक्षा';

  @override
  String get heavyVehicle => 'जड वाहन';

  @override
  String get fuelType => 'इंधन प्रकार';

  @override
  String get petrol => 'पेट्रोल';

  @override
  String get electric => 'इलेक्ट्रिक';

  @override
  String get vehicleMake => 'वाहन कंपनी';

  @override
  String get vehicleModel => 'वाहन मॉडेल';

  @override
  String get vehicleNumber => 'वाहन क्रमांक';

  @override
  String get vehicleNumberHint => 'उदा. MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'कृपया वाहन क्रमांक प्रविष्ट करा';

  @override
  String get selectMake => 'वाहन कंपनी निवडा';

  @override
  String get selectModel => 'वाहन मॉडेल निवडा';

  @override
  String get installDevice => 'Trackify डिव्हाइस इंस्टॉल करा';

  @override
  String get installDeviceDesc =>
      'सोप्या स्टेप्समध्ये तुमचे Ajjas स्मार्ट डिव्हाइस सेट करा';

  @override
  String get activateSticker => 'कॉन्टॅक्ट स्टिकर सक्रिय करा';

  @override
  String get activateStickerDesc =>
      'तुमचा कॉन्टॅक्ट स्टिकर पटकन सक्रिय करण्यासाठी सोप्या स्टेप्स';

  @override
  String get exploreFreeApp => 'आमचे मोफत अॅप एक्सप्लोर करा';

  @override
  String get exploreFreeAppDesc =>
      'फोन वापरून राईड रेकॉर्ड करा आणि आमच्या अॅपमध्ये ट्रॅक ठेवा';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get dataPlan => 'डेटा प्लॅन';

  @override
  String get warranty => 'वॉरंटी';

  @override
  String expiresInDays(String days) {
    return '$days दिवसांत संपेल';
  }

  @override
  String get rechargeNow => 'आता रिचार्ज करा';

  @override
  String get renewNow => 'आता नूतनीकरण करा';

  @override
  String get secureYourVehicle => 'तुमचे वाहन सुरक्षित करा';

  @override
  String get secureYourVehicleDesc =>
      'रिअल-टाइम ट्रॅकिंगसाठी Ajjas डिव्हाइस खरेदी करा';

  @override
  String get boughtDeviceInstallNow => 'डिव्हाइस घेतले आहे? ';

  @override
  String get installNow => 'आता इंस्टॉल करा';

  @override
  String get buyAjjasDevice => 'Ajjas डिव्हाइस खरेदी करा';

  @override
  String get lite4G => 'Lite 4G';

  @override
  String get swipeToLock => 'लॉक करण्यासाठी स्वाइप करा';

  @override
  String get upgradeToPlus => 'Ajjas Plus वर अपग्रेड करा';

  @override
  String get getMoreOutOfAjjas => 'Ajjas मधून अधिक मिळवा';

  @override
  String featuresExploredCount(String count, String total) {
    return 'तुम्ही $count पैकी $total फीचर्स एक्सप्लोर केले';
  }

  @override
  String get manageVehiclesDesc => 'तुमची सर्व वाहने येथे व्यवस्थापित करा';

  @override
  String get settingsDesc => 'भाषा, खाते सेटिंग्स आणि अधिक';

  @override
  String get notifications => 'सूचना';

  @override
  String get noNotifications => 'कोणत्याही सूचना नाहीत';

  @override
  String get notificationsFetchedSuccessfully => 'सूचना यशस्वीरित्या मिळाल्या';

  @override
  String get errorFetchingNotifications => 'सूचना मिळवताना त्रुटी';

  @override
  String get helpAndSupport => 'मदत आणि समर्थन';

  @override
  String get helpAndSupportDesc => 'सहाय्य आणि FAQ मिळवा';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get searchForSettings => 'सेटिंग्स शोधा';

  @override
  String get backupAndRestore => 'बॅकअप आणि पुनर्संचयित';

  @override
  String get backupAndRestoreDesc =>
      'तुमचा डेटा बॅकअप घ्या आणि कधीही पुनर्संचयित करा';

  @override
  String get appSettings => 'अॅप सेटिंग्स';

  @override
  String get appSettingsDesc => 'थीम, राईड हीटमॅप आणि इमर्जन्सी फीचर';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get notificationSettingsDesc => 'सूचना प्राधान्य आणि आवाज';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get privacyDesc => 'पासवर्ड बदला, सेशन व्यवस्थापित करा, खाते हटवा';

  @override
  String get rateUsOnPlayStore => 'Play Store वर रेट करा';

  @override
  String get rateUsOnPlayStoreDesc => 'तुमचा अभिप्राय द्या';

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
      'कृपया थोडक्यात वर्णन द्या (जास्तीत जास्त 200 अक्षरे)';

  @override
  String get selectCallSlot => 'कॉल स्लॉट निवडा';

  @override
  String get myIssues => 'माझ्या समस्या';

  @override
  String get whatsApp => 'व्हॉट्सअॅप';

  @override
  String get forceMigrate => 'फोर्स माइग्रेट';

  @override
  String get forceMigrateDesc1 =>
      'अॅप अपडेट दरम्यान मिस झालेल्या बॅकअप राइड्स दुरुस्त करण्यासाठी हा पर्याय वापरा.';

  @override
  String get forceMigrateDesc2 =>
      'कृपया लक्षात घ्या, हे सर्व्हरवरील जुने राइड्स परत आणत नाही. हे फक्त तुमच्या लोकल स्टोरेजमधील डेटा नवीन फॉरमॅटमध्ये माइग्रेट करते.';

  @override
  String get faq => 'नेहमी विचारले जाणारे प्रश्न';

  @override
  String get termsConditions => 'अटी आणि शर्ती';

  @override
  String get privacyPolicy => 'गोपनीयता धोरण';

  @override
  String get changeLog => 'बदल नोंद';

  @override
  String get todayLabel => '(आज)';

  @override
  String get ridingBehaviour => 'रायडिंग वर्तन';

  @override
  String get ridingBehaviourVacationDesc =>
      'असं दिसतंय की तुम्ही निवडलेल्या कालावधीत कोणतीही राईड घेतली नाही';

  @override
  String get journey => 'प्रवास';

  @override
  String get distanceTravelled => 'प्रवास केलेले अंतर';

  @override
  String get timeDuration => 'वेळ कालावधी';

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
  String get fuelCost => 'इंधन खर्च';

  @override
  String vsPreviousPeriod(String value) {
    return 'मागील कालावधीच्या तुलनेत $value%';
  }

  @override
  String get vehicleMakeListEmpty =>
      'या निवडीसाठी वाहन कंपनीची यादी रिकामी आहे';

  @override
  String get vehicleModelListEmpty =>
      'या निवडीसाठी वाहन मॉडेलची यादी रिकामी आहे';

  @override
  String get deviceInstallation => 'डिव्हाइस इंस्टॉलेशन';

  @override
  String get scanActivationCode => 'अॅक्टिवेशन कोड स्कॅन करा';

  @override
  String get enterActivationCodeManually =>
      'अॅक्टिवेशन कोड मॅन्युअली प्रविष्ट करा';

  @override
  String get openAjjasBoxInstruction =>
      'अॅक्टिवेशन QR कोडसाठी Ajjas बॉक्स उघडा.';

  @override
  String get continueText => 'पुढे चालू ठेवा';

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
      'डिव्हाइस यशस्वीरित्या वाहनाशी जोडले गेले!';

  @override
  String get assigningDevice => 'डिव्हाइस जोडले जात आहे...';

  @override
  String get invalidImeiError => 'कृपया वैध 15-अंकी IMEI नंबर प्रविष्ट करा';

  @override
  String get sharedRides => 'शेअर केलेल्या राईड्स';

  @override
  String get savedRides => 'सेव्ह केलेल्या राईड्स';

  @override
  String get allRides => 'सर्व राईड्स';

  @override
  String get trips => 'ट्रिप्स';

  @override
  String clicked(String value) {
    return '$value क्लिक केले';
  }

  @override
  String get noDailyRides => 'दाखवण्यासाठी कोणतीही दैनिक राईड नाही';

  @override
  String get getStartedFirstRide => 'पहिली राईड घेऊन सुरुवात करा';

  @override
  String get durationLabel => 'कालावधी';

  @override
  String get km => 'किमी';

  @override
  String get kmh => 'किमी/तास';

  @override
  String get tripEmptyQuote =>
      '“तुमच्या राईड्स ट्रिप्समध्ये गटबद्ध करा, आठवणी जोडा आणि प्रवास पुन्हा जगा”';

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
  String get skip => 'स्किप करा';

  @override
  String get todayText => 'आज';

  @override
  String get distanceLabel => 'अंतर';

  @override
  String get rideDuration => 'राईड कालावधी';

  @override
  String get speedLabel => 'वेग';

  @override
  String get minutesShort => 'मि';

  @override
  String get secondsShort => 'से';

  @override
  String get getMoreOutOfTrackify => 'Trackify मधून अधिक मिळवा';

  @override
  String get discoverMoreDesc =>
      'अधिक शोधा — अप्रतिम गोष्टी तुमची वाट पाहत आहेत!';

  @override
  String get serviceLogs => 'सर्व्हिस लॉग्स';

  @override
  String get safeParking => 'सुरक्षित पार्किंग';

  @override
  String get appUpdates => 'अॅप अपडेट्स';

  @override
  String get deviceDataPlanLabel => 'डिव्हाइस डेटा प्लॅन';

  @override
  String get deviceWarrantyLabel => 'डिव्हाइस वॉरंटी';

  @override
  String get videoTutorials => 'व्हिडिओ ट्यूटोरियल्स';

  @override
  String get exploreNow => 'आता एक्सप्लोर करा';

  @override
  String get plusLabel => 'प्लस';

  @override
  String get mapStyleLabel => 'नकाशा शैली';

  @override
  String get darkStyle => 'डार्क';

  @override
  String get lightStyle => 'लाइट';

  @override
  String get simpleStyle => 'सिंपल';

  @override
  String get satelliteStyle => 'सॅटेलाइट';

  @override
  String get mapOptionsLabel => 'नकाशा पर्याय';

  @override
  String get trafficLabel => 'ट्रॅफिक';

  @override
  String get labelsLabel => 'लेबेल्स';

  @override
  String get sharedWithMe => 'माझ्याशी शेअर केलेले';

  @override
  String get todaysStats => 'आजची आकडेवारी';

  @override
  String parkedSinceTime(String time) {
    return 'पासून पार्क केलेले: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return 'आणखी $value किमी बाकी';
  }

  @override
  String get buyTrackifyDevice => 'Trackify डिव्हाइस खरेदी करा';

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
  String get fuelEmpty => 'E';

  @override
  String get fuelFull => 'F';

  @override
  String get vehicleNamePlaceholder => 'SP 125';

  @override
  String get vehicleNumberPlaceholder => 'MP09QV8269';

  @override
  String get myProfile => 'माझे प्रोफाइल';

  @override
  String get profileCompleteness => 'प्रोफाइल पूर्णता';

  @override
  String lastUpdatedOn(String date) {
    return '$date रोजी शेवटचे अपडेट';
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
  String get mobileNumberLabel => 'मोबाइल नंबर';

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
      'वाहन सेटिंग्समध्ये विमा तपशील संपादित व पाहा.';

  @override
  String get myGarageVehiclePath => 'माझे गॅरेज > वाहन';

  @override
  String get emergencyContacts => 'आपत्कालीन संपर्क';

  @override
  String get addEditEmergencyContactDesc =>
      'वाहन सेटिंग्समध्ये आपत्कालीन संपर्क जोडा किंवा संपादित करा.';

  @override
  String get smartContactSticker => 'स्मार्ट कॉन्टॅक्ट स्टिकर';

  @override
  String get stickerSubtitle =>
      'तुमच्या वाहनाला सुरक्षित आणि स्मार्ट बनवण्यासाठी एक पाऊल पुढे';

  @override
  String get activateContactSticker => 'कॉन्टॅक्ट स्टिकर सक्रिय करा';

  @override
  String get buyNewContactSticker => 'नवीन कॉन्टॅक्ट स्टिकर खरेदी करा';

  @override
  String get beyondParkingProblems => 'पार्किंग समस्यांपलीकडे';

  @override
  String get noParkings => 'पार्किंग नाही';

  @override
  String get emergencies => 'आपत्कालीन परिस्थिती';

  @override
  String get vehicleTowing => 'वाहन टोइंग';

  @override
  String get getInformedStayConnected =>
      'माहिती मिळवा आणि तुमच्या वाहनाशी\nजोडलेले राहा';

  @override
  String get securedCalls => 'सुरक्षित कॉल्स';

  @override
  String get securedCallsDesc =>
      'इंटरनेट-मास्क केलेले कॉल्स - तुमचा नंबर खाजगी ठेवतात.';

  @override
  String get notificationHistory => 'सूचना इतिहास';

  @override
  String get notificationHistoryDesc =>
      'सध्याच्या आणि मागील सर्व सूचना ट्रॅक करा';

  @override
  String get beInformed => 'माहितीपूर्ण राहा';

  @override
  String get beInformedDesc =>
      'कोणी QR स्कॅन केल्यावर लगेच जाणून घ्या आणि कॉल आल्यावर तत्काळ कृती करा.';

  @override
  String get controlWhatOthersSee => 'इतरांना काय दिसेल ते नियंत्रित करा';

  @override
  String get controlWhatOthersSeeDesc =>
      'QR स्कॅन केल्यावर दिसणारे तपशील सानुकूलित करा.';

  @override
  String get preventFrustrationDamage => 'तणाव आणि नुकसान टाळा';

  @override
  String get preventFrustrationDamageDesc =>
      'चुकीच्या पार्किंगमुळे होणारे वाद आणि नुकसान टाळा.';

  @override
  String get serviceLogsSubtitle =>
      'वाहन सर्व्हिस कधीही चुकवू नका. रिमाइंडर मिळवा आणि खर्च ट्रॅक करा.';

  @override
  String get addServiceLogs => 'सर्व्हिस लॉग जोडा';

  @override
  String get uploadServicingBill => 'सर्व्हिस बिल अपलोड करा';

  @override
  String get addImage => 'प्रतिमा जोडा';

  @override
  String get maxFileSizeNote => 'टीप: कमाल फाइल आकार 5MB आहे';

  @override
  String get serviceDate => 'सर्व्हिस तारीख';

  @override
  String get billingAmount => 'बिल रक्कम';

  @override
  String get serviceCenterName => 'सर्व्हिस सेंटर नाव';

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
  String get liveLocationSharingActive => 'लाईव्ह लोकेशन शेअरिंग सक्रिय';

  @override
  String get noLiveLocationShared => 'लाईव्ह लोकेशन शेअर केलेले नाही';

  @override
  String get realTimeSharingDesc =>
      'तुमचे लोकेशन निवडलेल्या संपर्कांसोबत रिअल-टाइममध्ये शेअर होत आहे.';

  @override
  String get startSharingPhoneDesc =>
      'इतरांना ट्रॅक करण्यासाठी तुमच्या फोनचे लोकेशन शेअर करा';

  @override
  String get noHistoryAvailable => 'कोणताही इतिहास उपलब्ध नाही';

  @override
  String get historyDesc => 'भूतकाळातील शेअर्स येथे दिसतील.';

  @override
  String get stopSharing => 'शेअरिंग थांबवा';

  @override
  String get shareLocation => 'लोकेशन शेअर करा';

  @override
  String get startSharing => 'शेअरिंग सुरू करा';

  @override
  String get phoneTracking => 'फोन ट्रॅकिंग';

  @override
  String get liveRecordTab => 'लाईव्ह रेकॉर्ड';

  @override
  String get statsTab => 'स्टॅट्स';

  @override
  String get timeLabel => 'वेळ';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get custom => 'कस्टम';

  @override
  String get quickStats => 'जलद आकडेवारी';

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
  String get speedAlertInput => 'वेग अलर्ट इनपुट';

  @override
  String get alertTitle => 'अलर्ट शीर्षक';

  @override
  String get speedLimitKmH => 'वेग मर्यादा (km/h)';

  @override
  String get timeDurationSec => 'कालावधी (सेकंद)';

  @override
  String get selectYourVehicle => 'तुमचे वाहन निवडा';

  @override
  String get submit => 'सबमिट';

  @override
  String get selectVehiclesOverspeedAlert => 'ओव्हरस्पीड अलर्टसाठी वाहन निवडा';

  @override
  String get selected => 'निवडलेले';

  @override
  String get sec => 'सेक';

  @override
  String get viewMore => 'अधिक पहा';

  @override
  String get viewLess => 'कमी पहा';

  @override
  String get previousRides => 'मागील राईड्स';

  @override
  String get seeAll => 'सर्व पहा';

  @override
  String get videosYouMightLike => 'तुम्हाला आवडू शकणारे व्हिडिओ';

  @override
  String get scrollToTop => 'वर स्क्रोल करा';

  @override
  String get noRecentRidesFound => 'अलीकडील राईड्स सापडल्या नाहीत';

  @override
  String get failedToLoadRides => 'राईड्स लोड करण्यात अयशस्वी';

  @override
  String get hrMin => 'तास:मिनिट';

  @override
  String get kmHr => 'किमी/तास';

  @override
  String get warranty_title => 'डिव्हाइस वॉरंटी';

  @override
  String get warranty_extend =>
      'तुमच्या Trackify Lite ची वॉरंटी 1 वर्षाने वाढवा @ ₹1/दिवस';

  @override
  String get warranty_vehicle => 'वाहन';

  @override
  String get warranty_expiry => 'वॉरंटी समाप्ती तारीख';

  @override
  String warranty_daysLeft(String days) {
    return '$days दिवस शिल्लक';
  }

  @override
  String get warranty_benefitsTitle => 'चुकवू नये असे फायदे';

  @override
  String get benefit1_highlight => 'हमीदार बदल ';

  @override
  String get benefit1_normal => 'बिघाड झाल्यास';

  @override
  String get benefit2_highlight => '₹1200 पर्यंत बचत ';

  @override
  String get benefit2_normal => 'डिव्हाइस दुरुस्तीवर';

  @override
  String get benefit3_highlight => 'तत्काळ सहाय्य ';

  @override
  String get benefit3_normal => 'डिव्हाइस संबंधित समस्यांसाठी';

  @override
  String get benefit4_highlight => '₹2000 पर्यंत मोफत वाढीव सदस्यता ';

  @override
  String get benefit4_normal => 'बिघाड कालावधीसाठी';

  @override
  String get warranty_button => 'आता वॉरंटी वाढवा @ ₹365 ';

  @override
  String get warranty_button_old => '₹730';
}
