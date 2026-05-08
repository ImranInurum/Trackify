// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get selectLanguage => 'अपनी भाषा चुनें';

  @override
  String get letsGetStarted => 'चलिए शुरू करते हैं';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get invalidEmail => 'कृपया एक वैध ईमेल पता दर्ज करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get or => 'या';

  @override
  String get dontHaveAccount => 'खाता नहीं है? ';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String welcome(String email) {
    return 'स्वागत है $email!';
  }

  @override
  String get loginFailed => 'लॉगिन विफल';

  @override
  String get name => 'नाम';

  @override
  String get nameHint => 'जॉन डो';

  @override
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get mobileNumberHint => 'मोबाइल नंबर दर्ज करें';

  @override
  String get mobileNumberRequired => 'मोबाइल नंबर आवश्यक है';

  @override
  String get invalidMobileNumber => 'कृपया एक वैध मोबाइल नंबर दर्ज करें';

  @override
  String get country => 'देश';

  @override
  String get countryHint => 'देश दर्ज करें';

  @override
  String get countryRequired => 'देश आवश्यक है';

  @override
  String get state => 'राज्य';

  @override
  String get stateHint => 'राज्य दर्ज करें';

  @override
  String get stateRequired => 'राज्य आवश्यक है';

  @override
  String get city => 'शहर';

  @override
  String get cityHint => 'शहर दर्ज करें';

  @override
  String get cityRequired => 'शहर आवश्यक है';

  @override
  String get selectProfileImage => 'प्रोफ़ाइल छवि चुनें';

  @override
  String get role => 'भूमिका';

  @override
  String get roleAdmin => 'एडमिन';

  @override
  String get roleCustomer => 'ग्राहक';

  @override
  String get selectRoleHint => 'भूमिका चुनें';

  @override
  String get roleRequired => 'कृपया एक भूमिका चुनें';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get registerSuccess =>
      'उपयोगकर्ता सफलतापूर्वक पंजीकृत हुआ, कृपया लॉगिन करें';

  @override
  String get signUpFailed => 'साइन अप विफल';

  @override
  String get otpSent => 'ओटीपी सफलतापूर्वक भेजा गया';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get resetPasswordDesc =>
      'अपना ईमेल पता दर्ज करें और हम आपको पासवर्ड रीसेट करने के लिए एक लिंक भेजेंगे।';

  @override
  String get sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get otpVerified => 'ओटीपी सफलतापूर्वक सत्यापित';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करें';

  @override
  String get otpHeader => 'ओटीपी सत्यापन';

  @override
  String otpDesc(String email) {
    return '$email पर भेजे गए ओटीपी को दर्ज करें।';
  }

  @override
  String get otp => 'ओटीपी';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'ओटीपी आवश्यक है';

  @override
  String get passwordResetSuccess => 'पासवर्ड सफलतापूर्वक रीसेट हो गया';

  @override
  String get createNewPassword => 'नया पासवर्ड बनाएं';

  @override
  String get passwordDesc =>
      'आपका नया पासवर्ड पिछले पासवर्ड से अलग होना चाहिए।';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get newPasswordHint => 'अपना नया पासवर्ड दर्ज करें';

  @override
  String get passwordMinLength => 'पासवर्ड कम से भी कम 6 अक्षरों का होना चाहिए';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get confirmPasswordHint => 'अपने नए पासवर्ड की पुष्टि करें';

  @override
  String get confirmPasswordRequired => 'पासवर्ड की पुष्टि आवश्यक है';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get selectDevice => 'डिवाइस चुनें';

  @override
  String get noDevicesFound => 'कोई डिवाइस नहीं मिला।';

  @override
  String get proceed => 'आगे बढ़ें';

  @override
  String get unknownDevice => 'अज्ञात डिवाइस';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'डिवाइस प्राप्त करने के लिए प्रारंभ करें।';

  @override
  String get recordRide => 'सवारी रिकॉर्ड करें';

  @override
  String get phoneAsGps => 'अपने फोन को एक जीपीएस ट्रैकिंग डिवाइस बनाएं';

  @override
  String get goToDashboard => 'डैशबोर्ड पर जाएं';

  @override
  String get seeFullMap => 'पूरा नक्शा देखें';

  @override
  String get exploreMore => 'अधिक अन्वेषण करें';

  @override
  String get reachMeSticker => 'रीचमी स्टिकर';

  @override
  String get products => 'उत्पाद';

  @override
  String get fuelLogs => 'ईंधन लॉग';

  @override
  String get locationSharing => 'स्थान साझाकरण';

  @override
  String get documentFolder => 'दस्तावेज़ फ़ोल्डर';

  @override
  String get voiceMonitoring => 'वॉइस मॉनिटरिंग';

  @override
  String get remoteEngineOff => 'रिमोट इंजन बंद';

  @override
  String get networkBooster => 'नेटवर्क बूस्टर';

  @override
  String get emergency => 'आपातकालीन';

  @override
  String get overspeedAlert => 'ओवरस्पीड अलर्ट';

  @override
  String get geoFenceAlert => 'जियो-फेंस अलर्ट';

  @override
  String get more => 'अधिक';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get bikeSmartMsg =>
      '1000+ लोगों ने हमारे डिवाइस से अपनी बाइक को स्मार्ट बनाया';

  @override
  String get features => 'विशेषताएं';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get contactUsDesc => 'कोई सवाल? हम यहाँ मदद के लिए हैं।';

  @override
  String get userReviews => 'उपयोगकर्ता समीक्षा';

  @override
  String get accidentAlert => 'दुर्घटना अलर्ट';

  @override
  String get antiTheftAlert => 'एंटी-थेफ्ट अलर्ट';

  @override
  String get geoFence => 'जियो फेंस';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get myGarage => 'मेरा गैरेज';

  @override
  String get noVehiclesInGarage => 'आपके गैरेज में कोई वाहन नहीं मिला।';

  @override
  String get unknownVehicle => 'अज्ञात वाहन';

  @override
  String get status => 'स्थिति';

  @override
  String get active => 'सक्रिय';

  @override
  String get subscription => 'सदस्यता';

  @override
  String get proPlan => 'प्रो प्लान';

  @override
  String get initializeGarage => 'अपना गैरेज प्राप्त करने के लिए प्रारंभ करें।';

  @override
  String get ourProducts => 'हमारे उत्पाद';

  @override
  String get proTitle => 'Trackify प्रो';

  @override
  String get proSubtitle => 'अधिकतम सुविधाओं के साथ उन्नत ट्रैकिंग';

  @override
  String get goTitle => 'Trackify गो';

  @override
  String get goSubtitle => 'रोजमर्रा के उपयोग के लिए मानक ट्रैकिंग';

  @override
  String get liteTitle => 'Trackify लाइट';

  @override
  String get liteSubtitle => 'बुनियादी लोकेटर डिवाइस';

  @override
  String get realTime1s => 'वास्तविक समय 1s ट्रैकिंग';

  @override
  String get remoteEngineCutOff => 'रिमोट इंजन कट-ऑफ';

  @override
  String get detailedFuelAnalytics => 'विस्तृत ईंधन विश्लेषण';

  @override
  String get realTime5s => 'वास्तविक समय 5s ट्रैकिंग';

  @override
  String get antiTheftAlerts => 'एंटी-थेफ्ट अलर्ट';

  @override
  String get basicJourneyLogs => 'बुनियादी यात्रा लॉग';

  @override
  String get locationUpdates => 'स्थान अपडेट';

  @override
  String get batteryMonitor => 'बैटरी मॉनिटर';

  @override
  String get featuresLabel => 'विशेषताएं:';

  @override
  String addedToCart(String title) {
    return '$title को कार्ट में जोड़ा गया!';
  }

  @override
  String get buyNow => 'अभी खरीदें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String errorMsg(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get addVehicle => 'वाहन/डिवाइस जोड़ें';

  @override
  String get vehicleAdded => 'वाहन सफलतापूर्वक जोड़ा गया!';

  @override
  String get vehicleType => 'वाहन का प्रकार';

  @override
  String get twoWheeler => 'दोपहिया';

  @override
  String get fourWheeler => 'चारपहिया';

  @override
  String get autoRickshaw => 'ऑटो रिक्शा';

  @override
  String get heavyVehicle => 'भारी वाहन';

  @override
  String get fuelType => 'ईंधन का प्रकार';

  @override
  String get petrol => 'पेट्रोल';

  @override
  String get electric => 'इलेक्ट्रिक';

  @override
  String get vehicleImage => 'वाहन की छवि';

  @override
  String get newLabel => 'नया';

  @override
  String get vehicleMake => 'वाहन का ब्रांड';

  @override
  String get vehicleModel => 'वाहन का मॉडल';

  @override
  String get vehicleNumber => 'वाहन नंबर';

  @override
  String get vehicleNumberHint => 'जैसे: MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'कृपया वाहन नंबर दर्ज करें';

  @override
  String get selectMake => 'वाहन का ब्रांड चुनें';

  @override
  String get selectModel => 'वाहन का मॉडल चुनें';

  @override
  String get installDevice => 'Trackify डिवाइस स्थापित करें';

  @override
  String get installDeviceDesc =>
      'सरल चरणों के साथ अपना Trackify स्मार्ट डिवाइस जल्दी सेट करें';

  @override
  String get activateSticker => 'संपर्क स्टिकर सक्रिय करें';

  @override
  String get activateStickerDesc =>
      'अपने संपर्क स्टिकर को जल्दी सक्रिय करने के सरल चरण';

  @override
  String get exploreFreeApp => 'हमारा मुफ़्त ऐप एक्सप्लोर करें';

  @override
  String get exploreFreeAppDesc =>
      'फ़ोन से मैन्युअल रूप से राइड रिकॉर्ड करें और हमारे निःशुल्क ऐप से उसे ट्रैक करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get dataPlan => 'डेटा प्लान';

  @override
  String get warranty => 'वारंटी';

  @override
  String expiresInDays(String days) {
    return '$days दिनों में समाप्त हो रहा है';
  }

  @override
  String get rechargeNow => 'अभी रिचार्ज करें';

  @override
  String get renewNow => 'अभी नवीनीकृत करें';

  @override
  String get secureYourVehicle => 'अपने वाहन को सुरक्षित करें';

  @override
  String get secureYourVehicleDesc =>
      'रीअल-टाइम ट्रैकिंग और मन की शांति के लिए अभी अजस डिवाइस खरीदें।';

  @override
  String get boughtDeviceInstallNow => 'डिवाइस खरीदा है? ';

  @override
  String get installNow => 'अभी इंस्टॉल करें';

  @override
  String get buyTrackifyDevice => 'Trackify डिवाइस खरीदें';

  @override
  String get lite4G => 'लाइट 4जी';

  @override
  String get swipeToLock => 'लॉक करने के लिए स्वाइप करें';

  @override
  String get upgradeToPlus => 'Trackify Plus में अपग्रेड करें';

  @override
  String get getMoreOutOfTrackify => 'Trackify से और अधिक पाएं';

  @override
  String featuresExploredCount(Object count, Object total) {
    return 'आपने $total में से $count सुविधाएं एक्सप्लोर की हैं - जारी रखें!';
  }

  @override
  String get manageVehiclesDesc => 'यहाँ अपने सभी वाहन प्रबंधित करें';

  @override
  String get settingsDesc => 'भाषा, खाता सेटिंग्स और अधिक';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get noNotifications => 'कोई अधिसूचना नहीं मिली';

  @override
  String get notificationsFetchedSuccessfully =>
      'अधिसूचनाएं सफलतापूर्वक प्राप्त की गईं';

  @override
  String get errorFetchingNotifications => 'अधिसूचनाएं प्राप्त करने में त्रुटि';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get helpAndSupportDesc => 'सहायता और अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get searchForSettings => 'सेटिंग्स खोजें';

  @override
  String get backupAndRestore => 'बैकअप और पुनर्स्थापना';

  @override
  String get backupAndRestoreDesc =>
      'अपनी राइड डेटा का बैकअप लें और कभी भी पुनर्स्थापित करें।';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get appSettingsDesc => 'ऐप थीम, राइड हीटमैप और आपातकालीन सुविधा';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get notificationSettingsDesc => 'सूचना प्राथमिकता और सूचना ध्वनि';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get privacyDesc =>
      'पासवर्ड बदलें, वर्तमान सत्र प्रबंधित करें, अपना खाता हटाएं';

  @override
  String get rateUsOnPlayStore => 'Play Store पर रेटिंग दें';

  @override
  String get rateUsOnPlayStoreDesc => 'अपनी बहुमूल्य प्रतिक्रिया साझा करें';

  @override
  String get logoutDesc => 'इस डिवाइस से लॉगआउट करें';

  @override
  String get helpAndSuggestion => 'सहायता और सुझाव';

  @override
  String get reportAnIssue => 'समस्या रिपोर्ट करें';

  @override
  String get suggestion => 'सुझाव';

  @override
  String get whatIsYourIssueRelatedTo => 'आपकी समस्या किससे संबंधित है?';

  @override
  String get shortDescriptionHint =>
      'हमें एक संक्षिप्त विवरण दें (अधिकतम 200 अक्षर)';

  @override
  String get selectCallSlot => 'कॉल समय चुनें';

  @override
  String get myIssues => 'मेरी समस्याएं';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get forceMigrate => 'फोर्स माइग्रेट';

  @override
  String get forceMigrateDesc1 =>
      'ऐप अपडेट के दौरान छूटी हुई दैनिक राइड्स को ठीक करने के लिए इस विकल्प का उपयोग करें।';

  @override
  String get forceMigrateDesc2 =>
      'कृपया ध्यान दें, यह सर्वर से आपकी पुरानी राइड्स वापस नहीं लाता। यह केवल आपके स्थानीय संग्रहण में डेटा को नए डेटा प्रारूप में माइग्रेट करता है।';

  @override
  String get faq => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get termsConditions => 'नियम और शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get changeLog => 'परिवर्तन लॉग';

  @override
  String get todayLabel => '(आज)';

  @override
  String get ridingBehaviour => 'राइडिंग व्यवहार';

  @override
  String get ridingBehaviourVacationDesc =>
      'ऐसा लगता है कि आपके वाहन ने थोड़ी छुट्टी ली है, क्योंकि आपने चुनी हुई समय अवधि के दौरान कोई राइड नहीं ली';

  @override
  String get journey => 'यात्रा';

  @override
  String get distanceTravelled => 'तय की गई दूरी';

  @override
  String get timeDuration => 'समयावधि';

  @override
  String get speed => 'गति';

  @override
  String get averageSpeed => 'औसत गति';

  @override
  String get topSpeed => 'अधिकतम गति';

  @override
  String get fuel => 'ईंधन';

  @override
  String get fuelConsumed => 'खर्च हुआ ईंधन';

  @override
  String get fuelCost => 'ईंधन लागत';

  @override
  String vsPreviousPeriod(String value) {
    return '$value% पिछली अवधि की तुलना में';
  }

  @override
  String get vehicleMakeListEmpty => 'इस चयन के लिए वाहन निर्माता सूची खाली है';

  @override
  String get vehicleModelListEmpty => 'इस चयन के लिए वाहन मॉडल सूची खाली है';

  @override
  String get deviceInstallation => 'डिवाइस इंस्टॉलेशन';

  @override
  String get scanActivationCode => 'एक्टिवेशन कोड स्कैन करें';

  @override
  String get enterActivationCodeManually =>
      'एक्टिवेशन कोड मैन्युअल रूप से दर्ज करें';

  @override
  String get openTrackifyBoxInstruction =>
      'एक्टिवेशन QR कोड के लिए Trackify बॉक्स खोलें।';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get enterUID => 'UID दर्ज करें';

  @override
  String get enterIMEINumber => 'IMEI नंबर दर्ज करें';

  @override
  String get close => 'बंद करें';

  @override
  String get uidRequired => 'UID आवश्यक है';

  @override
  String get imeiRequired => 'IMEI नंबर आवश्यक है';

  @override
  String get deviceAssignedSuccess =>
      'डिवाइस सफलतापूर्वक वाहन को असाइन किया गया!';

  @override
  String get assigningDevice => 'डिवाइस असाइन किया जा रहा है...';

  @override
  String get invalidImeiError => 'कृपया एक मान्य 15-अंकीय IMEI नंबर दर्ज करें';

  @override
  String get sharedRides => 'साझा की गई राइड्स';

  @override
  String get savedRides => 'सुरक्षित की गई राइड्स';

  @override
  String get allRides => 'सभी राइड्स';

  @override
  String get trips => 'ट्रिप्स';

  @override
  String clicked(String value) {
    return '$value पर क्लिक किया गया';
  }

  @override
  String get noDailyRides => 'दिखाने के लिए कोई दैनिक राइड नहीं है';

  @override
  String get getStartedFirstRide => 'अपनी पहली राइड लेकर शुरुआत करें';

  @override
  String get durationLabel => 'अवधि';

  @override
  String get km => 'किमी';

  @override
  String get kmh => 'किमी/घंटा';

  @override
  String get tripEmptyQuote =>
      '“अपनी राइड्स को ट्रिप्स में समूहबद्ध करें, यादें जोड़ें और यात्रा को फिर से जिएं”';

  @override
  String ridesCompletedCount(String completed, String total) {
    return 'पूरी की गई राइड्स: $completed/$total';
  }

  @override
  String get unlockTripsRequirement =>
      'ट्रिप्स अनलॉक करने के लिए आपको कम से कम 3 राइड्स की आवश्यकता है';

  @override
  String get createNewTrip => 'एक नई ट्रिप बनाएं';

  @override
  String get startByCreatingTrip => 'एक नई ट्रिप बनाकर शुरुआत करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get todayText => 'आज';

  @override
  String get distanceLabel => 'दूरी';

  @override
  String get rideDuration => 'राइड की अवधि';

  @override
  String get speedLabel => 'गति';

  @override
  String get minutesShort => 'मि';

  @override
  String get secondsShort => 'से';

  @override
  String get discoverMoreDesc =>
      'और खोजें — शानदार चीज़ें प्रतीक्षा कर रही हैं!';

  @override
  String get serviceLogs => 'सर्विस लॉग';

  @override
  String get safeParking => 'सुरक्षित पार्किंग';

  @override
  String get appUpdates => 'ऐप अपडेट';

  @override
  String get deviceDataPlanLabel => 'डिवाइस डेटा प्लान';

  @override
  String get deviceWarrantyLabel => 'डिवाइस वारंटी';

  @override
  String get videoTutorials => 'वीडियो ट्यूटोरियल';

  @override
  String get exploreNow => 'अभी खोजें';

  @override
  String get plusLabel => 'प्लस';

  @override
  String get mapStyleLabel => 'मैप स्टाइल';

  @override
  String get darkStyle => 'डार्क';

  @override
  String get lightStyle => 'लाइट';

  @override
  String get simpleStyle => 'सिंपल';

  @override
  String get satelliteStyle => 'सैटेलाइट';

  @override
  String get mapOptionsLabel => 'मैप विकल्प';

  @override
  String get trafficLabel => 'ट्रैफिक';

  @override
  String get labelsLabel => 'लेबल';

  @override
  String get sharedWithMe => 'मेरे साथ साझा किया गया';

  @override
  String get todaysStats => 'आज के आंकड़े';

  @override
  String parkedSinceTime(String time) {
    return 'पार्क किया गया तब से: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return '$value किमी और जाना है';
  }

  @override
  String get recordViaPhone => 'फोन से रिकॉर्ड करें';

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
  String get myProfile => 'मेरी प्रोफाइल';

  @override
  String get profileCompleteness => 'प्रोफ़ाइल पूर्णता';

  @override
  String lastUpdatedOn(String date) {
    return 'अंतिम बार $date को अपडेट किया गया';
  }

  @override
  String get addProfilePicture => 'अपनी प्रोफ़ाइल तस्वीर जोड़ें';

  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get userNameLabel => 'नाम';

  @override
  String get emailAddressLabel => 'ईमेल पता';

  @override
  String get mobileNumberLabel => 'मोबाइल नंबर';

  @override
  String get countryLabel => 'देश';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get cityLabel => 'शहर';

  @override
  String get medicalInsuranceInfo => 'चिकित्सा बीमा जानकारी';

  @override
  String get addMedicalInsuranceInfo => 'चिकित्सा बीमा जानकारी जोड़ें';

  @override
  String get vehicleInsuranceInfo => 'वाहन बीमा जानकारी';

  @override
  String get editViewVehicleInsuranceDesc =>
      'वाहन सेटिंग में अपनी वाहन बीमा विवरण संपादित करें और देखें।';

  @override
  String get myGarageVehiclePath => 'My Garage > Vehicle';

  @override
  String get emergencyContacts => 'आपातकालीन संपर्क';

  @override
  String get addEditEmergencyContactDesc =>
      'वाहन सेटिंग में आपातकालीन संपर्क सूची जोड़ें और संपादित करें।';

  @override
  String get smartContactSticker => 'स्मार्ट कॉन्टैक्ट स्टिकर';

  @override
  String get stickerSubtitle =>
      'अपने वाहन को सुरक्षित और स्मार्ट बनाने की दिशा में एक कदम';

  @override
  String get activateContactSticker => 'कॉन्टैक्ट स्टिकर सक्रिय करें';

  @override
  String get buyNewContactSticker => 'नया कॉन्टैक्ट स्टिकर खरीदें';

  @override
  String get beyondParkingProblems => 'पार्किंग की समस्याओं से परे';

  @override
  String get noParkings => 'नो पार्किंग';

  @override
  String get emergencies => 'आपात स्थिति';

  @override
  String get vehicleTowing => 'वाहन टोइंग';

  @override
  String get getInformedStayConnected =>
      'सूचित रहें और अपने वाहन से\nजुड़े रहें';

  @override
  String get securedCalls => 'सुरक्षित कॉल';

  @override
  String get securedCallsDesc =>
      'इंटरनेट-मास्क्ड कॉल - आपके फोन नंबर को निजी रखता है।';

  @override
  String get notificationHistory => 'अधिसूचना इतिहास';

  @override
  String get notificationHistoryDesc =>
      'सभी वर्तमान और पिछली सूचनाओं पर नज़र रखें';

  @override
  String get beInformed => 'सूचित रहें';

  @override
  String get beInformedDesc =>
      'जब कोई आपका क्यूआर कोड स्कैन करे तो तुरंत जानें और जब वे आपको कॉल करें तो तुरंत कार्रवाई करें।';

  @override
  String get controlWhatOthersSee => 'नियंत्रित करें कि दूसरे क्या देखते हैं';

  @override
  String get controlWhatOthersSeeDesc =>
      'जब कोई क्यूआर स्कैन करता है तो दिखाए गए विवरणों को अनुकूलित करें।';

  @override
  String get preventFrustrationDamage => 'निराशा और क्षति को रोकें';

  @override
  String get preventFrustrationDamageDesc =>
      'अनुचित पार्किंग से होने वाले संघर्षों और वाहन की क्षति से बचें।';

  @override
  String get serviceLogsSubtitle =>
      'वाहन सर्विस कभी न चूकें। अपने वाहन को बेहतरीन स्थिति में रखने के लिए रिमाइंडर प्राप्त करें और खर्चों को ट्रैक करें।';

  @override
  String get addServiceLogs => 'सर्विस लॉग्स जोड़ें';

  @override
  String get uploadServicingBill => 'सर्विसिंग बिल अपलोड करें';

  @override
  String get addImage => 'छवि जोड़ें';

  @override
  String get maxFileSizeNote => 'नोट: अधिकतम फ़ाइल आकार 5MB है';

  @override
  String get serviceDate => 'सर्विस की तारीख';

  @override
  String get billingAmount => 'बिलिंग राशि';

  @override
  String get serviceCenterName => 'सर्विस सेंटर का नाम';

  @override
  String get serviceCenterContact => 'सर्विस सेंटर का संपर्क';

  @override
  String get additionalNote => 'अतिरिक्त नोट';

  @override
  String get saveDetails => 'विवरण सहेजें';

  @override
  String get selectVehicle => 'वाहन चुनें';

  @override
  String get liveTab => 'लाइव';

  @override
  String get historyTab => 'इतिहास';

  @override
  String get liveLocationSharingActive => 'लाइव लोकेशन शेयरिंग सक्रिय है';

  @override
  String get noLiveLocationShared => 'कोई लाइव लोकेशन साझा नहीं की गई है';

  @override
  String get realTimeSharingDesc =>
      'आपकी लोकेशन चुनिंदा संपर्कों के साथ रीयल-टाइम में साझा की जा रही है।';

  @override
  String get startSharingPhoneDesc =>
      'दूसरों को आपको ट्रैक करने में मदद करने के लिए अपने फ़ोन की लोकेशन साझा करना शुरू करें';

  @override
  String get noHistoryAvailable => 'कोई इतिहास उपलब्ध नहीं है';

  @override
  String get historyDesc =>
      'पिछले लोकेशन शेयर पूरा होने के बाद यहां दिखाई देंगे।';

  @override
  String get stopSharing => 'शेयरिंग बंद करें';

  @override
  String get shareLocation => 'लोकेशन शेयर करें';

  @override
  String get startSharing => 'शेयर करना शुरू करें';

  @override
  String get phoneTracking => 'फोन ट्रैकिंग';

  @override
  String get liveRecordTab => 'लाइव रिकॉर्ड';

  @override
  String get statsTab => 'आंकड़े';

  @override
  String get timeLabel => 'समय';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get custom => 'कस्टम';

  @override
  String get quickStats => 'त्वरित आंकड़े';

  @override
  String get totalRides => 'कुल राइड्स';

  @override
  String get avgSpeed => 'औसत गति';

  @override
  String get totalFuel => 'कुल ईंधन';

  @override
  String get overallDistance => 'कुल दूरी';

  @override
  String get drivingTime => 'ड्राइविंग समय';

  @override
  String get safetyScore => 'सुरक्षा स्कोर';

  @override
  String get speedAlertInput => 'गति चेतावनी इनपुट';

  @override
  String get alertTitle => 'चेतावनी शीर्षक';

  @override
  String get speedLimitKmH => 'गति सीमा (किमी/घंटा)';

  @override
  String get timeDurationSec => 'समय अवधि (सेकंड)';

  @override
  String get selectYourVehicle => 'अपना वाहन चुनें';

  @override
  String get submit => 'जमा करें';

  @override
  String get selectVehiclesOverspeedAlert =>
      'वह वाहन चुनें जिस पर गति चेतावनी लगानी है';

  @override
  String get selected => 'चयनित';

  @override
  String get sec => 'सेकंड';

  @override
  String get kmHr => 'किमी/घंटा';

  @override
  String get viewMore => 'और देखें';

  @override
  String get viewLess => 'कम देखें';

  @override
  String get previousRides => 'पिछली सवारी';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get videosYouMightLike => 'वीडियो जो आपको पसंद आ सकते हैं';

  @override
  String get scrollToTop => 'ऊपर जाएं';

  @override
  String get noRecentRidesFound => 'कोई हालिया सवारी नहीं मिली';

  @override
  String get failedToLoadRides => 'सवारी लोड करने में विफल';

  @override
  String get hrMin => 'घंटा:मिनट';

  @override
  String get vehicleLabel => 'वाहन';

  @override
  String get switchLabel => 'स्विच';

  @override
  String get expiryDate => 'समाप्ति तिथि';

  @override
  String get rechargePlans => 'रिचार्ज प्लान';

  @override
  String get superComboPlan => 'सुपर कॉम्बो प्लान';

  @override
  String get month12Validity => '12 महीने की वैधता';

  @override
  String get month6Validity => '6 महीने की वैधता';

  @override
  String saveAmount(Object amount) {
    return 'इस प्लान के साथ ₹$amount बचाएं';
  }

  @override
  String get superComboPopularity =>
      '95% उपयोगकर्ता सुपर कॉम्बो प्लान चुनते हैं';

  @override
  String get appSimRecharge => 'ऐप और सिम रिचार्ज';

  @override
  String get extendedWarranty => 'विस्तारित वारंटी';

  @override
  String get plusMembership => 'प्लस सदस्यता';

  @override
  String get continueSuperCombo => 'सुपर कॉम्बो प्लान के साथ जारी रखें';

  @override
  String get continue12Month => '12 महीने के प्लान के साथ जारी रखें';

  @override
  String get continue6Month => '6 महीने के प्लान के साथ जारी रखें';

  @override
  String get vehicleDocumentsTitle => 'वाहन दस्तावेज़';

  @override
  String get personalDocumentsSubtitle =>
      'अपने वाहन के दस्तावेज़ अपलोड करके संभाल कर रखें';

  @override
  String get vehicleRC => 'वाहन आरसी';

  @override
  String get insurance => 'बीमा';

  @override
  String get puc => 'पीयूसी';

  @override
  String get vehicleRCTitle => 'वाहन आरसी';

  @override
  String get insuranceTitle => 'बीमा विवरण';

  @override
  String get pucTitle => 'पीयूसी प्रमाणपत्र';

  @override
  String get notificationControlsTitle => 'अधिसूचना नियंत्रण';

  @override
  String get ignitionOnOffTitle => 'इग्निशन चालू/बंद';

  @override
  String get ignitionOnOffDesc =>
      'वाहन का इग्निशन चालू या बंद होने पर अधिसूचना प्राप्त करें';

  @override
  String get motionWithIgnitionOffTitle => 'इग्निशन बंद होने पर गति';

  @override
  String get motionWithIgnitionOffDesc =>
      'जब इग्निशन बंद हो और वाहन चले तो अधिसूचना प्राप्त करें';

  @override
  String get powerSupplyOffTitle => 'पावर सप्लाई बंद';

  @override
  String get powerSupplyOffDesc =>
      'जब Trackify को पावर नहीं मिल रही हो तो अधिसूचना प्राप्त करें';

  @override
  String get appNotification => 'ऐप अधिसूचना';

  @override
  String get odometerReading => 'ओडोमीटर रीडिंग';

  @override
  String get update => 'अपडेट';

  @override
  String get gpsReadingNote => 'जीपीएस-आधारित रीडिंग, मामूली अंतर हो सकता है।';

  @override
  String get tankCapacity => 'टैंक क्षमता';

  @override
  String get afterLastRefuel => 'अंतिम रिफ्यूल के बाद';

  @override
  String get fuelRemaining => 'शेष ईंधन';

  @override
  String get distanceRemaining => 'शेष दूरी';

  @override
  String get mileageArai => 'माइलेज (ARAI)';

  @override
  String get spendingOnFuel => 'ईंधन पर खर्च';

  @override
  String get today => 'आज';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get thisYear => 'इस वर्ष';

  @override
  String get all => 'सभी';

  @override
  String get customDates => 'कस्टम तिथियां';

  @override
  String get refuelHistory => 'रिफ्यूल इतिहास';

  @override
  String get addRefuelingDetails => 'रिफ्यूलिंग विवरण जोड़ें';

  @override
  String get fuelStations => 'ईंधन स्टेशन';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get litersShort => 'ली.';

  @override
  String get fuelEstimateNote =>
      'ये मान आपकी ईंधन प्रविष्टियों पर आधारित अनुमान हैं। बेहतर सटीकता के लिए नियमित रूप से ईंधन लॉग जोड़ें।';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get currentOdometerReading => 'वर्तमान ओडोमीटर रीडिंग';

  @override
  String get odometerUpdateDesc =>
      'सटीक ईंधन और दूरी के अनुमान के लिए नियमित रूप से अपना ओडोमीटर अपडेट करें';

  @override
  String get updateTankCapacity => 'टैंक क्षमता अपडेट करें';

  @override
  String get tankCapacityDesc =>
      'अपने वाहन टैंक की अधिकतम ईंधन क्षमता दर्ज करें';

  @override
  String get litres => 'लीटर';

  @override
  String get kms => 'किमी';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get updateMileageArai => 'माइलेज अपडेट करें (ARAI)';

  @override
  String get mileageDesc =>
      'शेष ईंधन और दूरी को सटीक रूप से ट्रैक करने के लिए वर्तमान माइलेज (Km/L) दर्ज करें।';

  @override
  String get kmL => 'किमी/ली.';

  @override
  String get serviceLogAddedSuccess => 'सेवा लॉग सफलतापूर्वक जोड़ा गया';

  @override
  String get currencySymbol => '₹';

  @override
  String get refuelHistoryComingSoon => 'रिफ्यूल इतिहास जल्द ही आ रहा है';

  @override
  String get fuelStationsComingSoon => 'ईंधन स्टेशन जल्द ही आ रहे हैं';

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String get totalFuelAdded => 'कुल जोड़ा गया ईंधन';

  @override
  String get totalSpendings => 'कुल खर्च';

  @override
  String get avgMileage => 'औसत माइलेज';

  @override
  String get refuels => 'रिफ्यूल';

  @override
  String get refuelingHistory => 'रिफ्यूलिंग इतिहास';

  @override
  String get newestFirst => 'नवीनतम पहले';

  @override
  String get oldestFirst => 'सबसे पुराने पहले';

  @override
  String get mostExpensive => 'सबसे महंगे';

  @override
  String get leastExpensive => 'सबसे सस्ते';

  @override
  String get bestMileage => 'सर्वश्रेष्ठ माइलेज';

  @override
  String get worstMileage => 'सबसे खराब माइलेज';

  @override
  String get edit => 'संपादित करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get error => 'Something went wrong';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String hintEg(String value) {
    return 'जैसे, $value';
  }

  @override
  String get addStation => 'स्टेशन जोड़ें';

  @override
  String get nearby => 'पास के';

  @override
  String get favourites => 'पसंदीदा';

  @override
  String get addedByMe => 'मेरे द्वारा जोड़े गए';

  @override
  String get noFavourites => 'अभी तक कोई पसंदीदा नहीं';

  @override
  String get noStationsAdded => 'अभी तक कोई स्टेशन नहीं जोड़ा गया';

  @override
  String get fuelStationNearVehicle => 'वाहन के पास ईंधन स्टेशन';

  @override
  String get warranty_title => 'डिवाइस वारंटी';

  @override
  String get warranty_benefitsTitle => 'वारंटी के लाभ';

  @override
  String get warranty_extend =>
      'अपनी वारंटी बढ़ाएं और अपने डिवाइस को सुरक्षित रखें';

  @override
  String get warranty_vehicle => 'वाहन';

  @override
  String get warranty_expiry => 'वारंटी समाप्ति';

  @override
  String get warranty_button => 'वारंटी बढ़ाएं — ';

  @override
  String get warranty_button_old => '₹4,999';

  @override
  String get benefit1_highlight => 'प्रीमियम कवरेज ';

  @override
  String get benefit1_normal =>
      '— निर्माण दोषों के खिलाफ पूर्ण हार्डवेयर सुरक्षा।';

  @override
  String get benefit2_highlight => 'मुफ्त मरम्मत ';

  @override
  String get benefit2_normal => '— सभी सेवाएं और पुर्जे बिना किसी शुल्क के।';

  @override
  String get benefit3_highlight => '24/7 सहायता ';

  @override
  String get benefit3_normal => '— जब भी आवश्यकता हो, प्राथमिकता ग्राहक सेवा।';

  @override
  String get benefit4_highlight => 'कोई छुपा शुल्क नहीं ';

  @override
  String get benefit4_normal => '— एक फ्लैट शुल्क, पूर्ण मन की शांति।';

  @override
  String get initiatingEmergencyAlert =>
      'Trackify उपयोगकर्ताओं को आपातकालीन अलर्ट भेजा जा रहा है';

  @override
  String get pleaseUseResponsibly => 'कृपया जिम्मेदारी से उपयोग करें';

  @override
  String get secondsBeforeSendingAlert => 'अलर्ट भेजने से पहले सेकंड';

  @override
  String get sendNow => 'अभी भेजें';

  @override
  String get geoFenceTitle => 'जियो-फेंस';

  @override
  String geoFenceRadius(String radius) {
    return 'त्रिज्या: $radiusमी';
  }

  @override
  String get geoFenceLocating => 'स्थान खोजा जा रहा है...';

  @override
  String get geoFenceNameRequired => 'कृपया जियो-फेंस नाम दर्ज करें';

  @override
  String get geoFenceSaveSuccess => 'जियो-फेंस सफलतापूर्वक सहेजा गया!';

  @override
  String get geoFenceSearchHint => 'स्थान खोजें...';

  @override
  String get geoFenceSelectType => 'इसके लिए जियो-फेंस प्रकार चुनें ';

  @override
  String get geoFenceTypeHome => 'घर';

  @override
  String get geoFenceTypeOffice => 'कार्यालय';

  @override
  String get geoFenceTypeFamily => 'परिवार';

  @override
  String get geoFenceTypeParking => 'पार्किंग';

  @override
  String get geoFenceTypeOthers => 'अन्य';

  @override
  String get geoFenceNameFieldHint => 'जियो-फेंस नाम दर्ज करें, जैसे: घर';

  @override
  String get geoFenceAddSmsContacts => 'SMS अलर्ट के लिए संपर्क जोड़ें';

  @override
  String get geoFenceEmptyStateDesc =>
      'मैप पर एक घेरा बनाएं और जब भी कोई बाइक घेरे में प्रवेश करे या बाहर निकले तो अलर्ट पाएं।';

  @override
  String get addGeoFenceButton => 'जियो-फेंस जोड़ें';

  @override
  String get safeParkingTitle => 'सुरक्षित पार्किंग';

  @override
  String get schedule => 'शेड्यूल';

  @override
  String get setupSafeParking => 'सुरक्षित पार्किंग सेट करें';

  @override
  String get safeParkingSubtitle =>
      'इंजन ON और टोइंग अलर्ट के लिए कॉल अलर्ट प्राप्त करें';

  @override
  String get activate => 'सक्रिय करें';

  @override
  String get activated => 'सक्रिय';

  @override
  String get safeParkingDescription =>
      'इंजन चालू होने या टोइंग का पता चलने पर अलर्ट सक्षम करें';

  @override
  String get geoFenceDeleteConfirmation =>
      'क्या आप वाकई इस जियो-फेंस को हटाना चाहते हैं?';

  @override
  String get geoFenceTurnOffConfirmation =>
      'क्या आप वाकई इस जियो-फेंस को बंद करना चाहते हैं?';

  @override
  String get turnOff => 'बंद करें';

  @override
  String get plusMembershipTitle => 'प्लस सदस्यता';

  @override
  String get membership => 'सदस्यता';

  @override
  String get premiumBenefits => 'प्रीमियम लाभ';

  @override
  String get otherBenefits => 'अन्य लाभ';

  @override
  String get trackifyPlusReviews => 'TRACKIFY प्लस समीक्षाएं';

  @override
  String get offerings => 'सुविधाएँ';

  @override
  String get plus => 'प्लस';

  @override
  String get regular => 'नियमित';

  @override
  String upgradeNowAtJust(String price) {
    return 'अभी अपग्रेड करें मात्र ₹$price में';
  }

  @override
  String get viewMoreReviews => 'अधिक समीक्षाएं देखें';

  @override
  String get speciallyForYou => 'विशेष रूप से आपके लिए';

  @override
  String get footerMotto =>
      'एक ऐसे भविष्य का निर्माण जहाँ हर बाइक स्मार्ट हो\nऔर हर राइडर सुरक्षित हो';

  @override
  String get cropDocument => 'दस्तावेज़ क्रॉप करें';

  @override
  String get cropVehicleImage => 'वाहन की छवि क्रॉप करें';

  @override
  String get uploadImage => 'छवि अपलोड करें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get pdf => 'पीडीएफ';

  @override
  String get fileTooLarge => 'फ़ाइल का आकार 5MB से अधिक है';

  @override
  String get pickImageError => 'छवि चुनने में त्रुटि';

  @override
  String get pickPdfError => 'पीडीएफ चुनने में त्रुटि';

  @override
  String get pdfTooLarge => 'पीडीएफ का आकार 5MB से अधिक है';

  @override
  String get uploadDocuments => 'दस्तावेज़ अपलोड करें';

  @override
  String get frontSide => 'सामने का हिस्सा';

  @override
  String get backSide => 'पीछे का हिस्सा';

  @override
  String get commitmentText => 'आपके\nदस्तावेज़\nहमारी\nप्रतिबद्धता';

  @override
  String get documentsSafe => 'आपके दस्तावेज़ एन्क्रिप्टेड और सुरक्षित हैं';

  @override
  String get addDocument => 'दस्तावेज़ जोड़ें';

  @override
  String get frontRequired => 'सामने का दस्तावेज़ आवश्यक है';

  @override
  String get successMessage => 'दस्तावेज़ सफलतापूर्वक सहेजा गया';

  @override
  String get selectExpiryDate => 'समाप्ति तिथि';

  @override
  String get documentsEncrypted =>
      'आपके दस्तावेज़ एन्क्रिप्टेड और सुरक्षित हैं';

  @override
  String get fileSizeNote => 'नोट: अधिकतम फ़ाइल का आकार 5MB है';

  @override
  String get personalDocumentsTitle => 'व्यक्तिगत दस्तावेज़';

  @override
  String get drivingLicense => 'ड्राइविंग लाइसेंस';

  @override
  String get drivingLicenseTitle => 'ड्राइविंग लाइसेंस';

  @override
  String get otherDocuments => 'अन्य दस्तावेज़';

  @override
  String get otherDocumentTitle => 'अन्य दस्तावेज़';

  @override
  String get documentName => 'दस्तावेज़ का नाम*';

  @override
  String get billsTitle => 'बिल';

  @override
  String get billsDescription =>
      'अपने वाहन से संबंधित बिल अपलोड और प्रबंधित करें';

  @override
  String get movedTo => 'यहाँ स्थानांतरित';

  @override
  String get viewNow => 'अभी देखें';

  @override
  String get accessoryBills => 'एक्सेसरी बिल';

  @override
  String get tutorialVideos => 'ट्यूटोरियल वीडियो';

  @override
  String get videos => 'वीडियो';

  @override
  String get location => 'लोकेशन';

  @override
  String get amazingFeatures => 'शानदार फीचर्स';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get noVideos => 'कोई वीडियो नहीं मिला';

  @override
  String get apply => 'लागू करें';

  @override
  String get noRecordsFound => 'कोई रिकॉर्ड नहीं मिला';

  @override
  String get selectDateRange => 'तारीख सीमा चुनें';

  @override
  String get notificationTypes => 'अधिसूचना प्रकार';

  @override
  String get motionSensed => 'मोशन सेंस किया गया';

  @override
  String get ignitionOff => 'इग्निशन बंद';

  @override
  String get ignitionOn => 'इग्निशन चालू';

  @override
  String get accidentDetected => 'दुर्घटना का पता चला';

  @override
  String get stationaryFallDetected => 'स्थिर गिरावट का पता चला';

  @override
  String get vehicleSwitchedOff => 'वाहन बंद कर दिया गया';

  @override
  String get vehicleSwitchedOn => 'वाहन चालू कर दिया गया';

  @override
  String get powerSupplyOn => 'पावर सप्लाई चालू';

  @override
  String get vibrationSensed => 'कंपन महसूस किया गया';

  @override
  String get editVehicle => 'वाहन संपादित करें';

  @override
  String get diesel => 'डीजल';

  @override
  String get cng => 'सीएनजी';

  @override
  String get updateVehicle => 'वाहन अपडेट करें';

  @override
  String get vehicleMileage => 'वाहन माइलेज';

  @override
  String get notificationControls => 'अधिसूचना नियंत्रण';

  @override
  String get changeNotificationPreferences =>
      'अपनी अधिसूचना प्राथमिकताएं बदलें';

  @override
  String get unmapTrackify => 'अपने Trackify को अनमैप करें';

  @override
  String get unmapStep1 =>
      'चरण 1: डिवाइस को अन-मैप करने के लिए, +918061971443 पर कॉल करें';

  @override
  String get unmapStep2 => 'चरण 2: वाहन निकालें';

  @override
  String get updateMileage => 'माइलेज अपडेट करें';

  @override
  String get lastUpdated => 'अंतिम बार अपडेट किया गया: ';

  @override
  String get lockUnlockVehicle => 'वाहन लॉक और अनलॉक करें';

  @override
  String get sleepModeWarning =>
      'यदि डिवाइस स्लीप मोड में है तो आपका वाहन लॉक/अनलॉक नहीं होगा। ';

  @override
  String get journeyWithTrackify => 'Trackify के साथ यात्रा';

  @override
  String get lifetime => 'लाइफटाइम';

  @override
  String hrMinFormat(Object hr, Object min) {
    return '$hr घंटा $min मिनट';
  }

  @override
  String get yourVehicleOnMap => 'नक्शे पर आपका वाहन';

  @override
  String get selectIcon => 'आइकन चुनें';

  @override
  String get bike => 'बाइक';

  @override
  String get scooty => 'स्कूटी';

  @override
  String get myVehicle => 'मेरा वाहन';

  @override
  String get selectColor => 'रंग चुनें';

  @override
  String get white => 'सफेद';

  @override
  String get red => 'लाल';

  @override
  String get aqua => 'एक्वा';

  @override
  String get orange => 'नारंगी';

  @override
  String get sky => 'आकाश';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get whatIsSleepMode => 'स्लीप मोड क्या है?';

  @override
  String get sleepModeDesc1 =>
      'जब Trackify डिवाइस किसी कंपन या गति का पता नहीं लगाता है, तो यह वाहन की बैटरी बचाने के लिए स्वचालित रूप से स्लीप मोड में चला जाता है।';

  @override
  String get sleepModeDesc2 =>
      'डिवाइस तुरंत जाग जाता है और ट्रैकिंग शुरू कर देता है जब वह किसी गति को महसूस करता है और अच्छे नेटवर्क कवरेज में होता है।';

  @override
  String get hr => 'घंटा';

  @override
  String get min => 'मिनट';

  @override
  String get filters => 'फ़िल्टर';

  @override
  String get tankCapacityHint => 'e.g., 13';

  @override
  String get mileageHint => 'e.g., 50';

  @override
  String get powerSupplyOff => 'Power supply off';

  @override
  String get lastUpdatedLabel => 'Last updated: ';

  @override
  String get litresShort => 'L';

  @override
  String get discoverTrackifyFeatures => 'Discover Trackify Features';
}
