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
  String get voiceMonitoring => 'वॉयस मॉनिटरिंग';

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
      'सरल चरणों के साथ अपना Ajjas स्मार्ट डिवाइस जल्दी सेट करें';

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
  String get buyAjjasDevice => 'अजस डिवाइस खरीदें';

  @override
  String get lite4G => 'लाइट 4जी';

  @override
  String get swipeToLock => 'लॉक करने के लिए स्वाइप करें';

  @override
  String get upgradeToPlus => 'Ajjas Plus में अपग्रेड करें';

  @override
  String get getMoreOutOfAjjas => 'Ajjas से और अधिक पाएं';

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
  String get deviceInstallation => 'डिवाइस इंस्टालेशन';

  @override
  String get scanActivationCode => 'एक्टिवेशन कोड स्कैन करें';

  @override
  String get enterActivationCodeManually =>
      'एक्टिवेशन कोड मैन्युअल रूप से दर्ज करें';

  @override
  String get openAjjasBoxInstruction =>
      'एक्टिवेशन QR कोड के लिए Ajjas बॉक्स खोलें।';

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
  String get getMoreOutOfTrackify => 'Trackify से और अधिक पाएं';

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
  String get buyTrackifyDevice => 'Trackify डिवाइस खरीदें';

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
}
