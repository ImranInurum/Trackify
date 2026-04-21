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
