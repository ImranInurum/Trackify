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
  String get invalidEmail => 'Please enter a valid email address';

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
  String get mobileNumber => 'Mobile Number';

  @override
  String get mobileNumberHint => 'Enter mobile number';

  @override
  String get mobileNumberRequired => 'Mobile number is required';

  @override
  String get country => 'Country';

  @override
  String get countryHint => 'Enter country';

  @override
  String get countryRequired => 'Country is required';

  @override
  String get state => 'State';

  @override
  String get stateHint => 'Enter state';

  @override
  String get stateRequired => 'State is required';

  @override
  String get city => 'City';

  @override
  String get cityHint => 'Enter city';

  @override
  String get cityRequired => 'City is required';

  @override
  String get selectProfileImage => 'Select Profile Image';

  @override
  String get role => 'भूमिका';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get selectRoleHint => 'Select Role';

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
    return '$title को कार्ट में जोड़ा गया!';
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
  String get addVehicle => 'Add Vehicle/Device';

  @override
  String get vehicleAdded => 'Vehicle added successfully!';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get twoWheeler => 'Two Wheeler';

  @override
  String get fourWheeler => 'Four Wheeler';

  @override
  String get autoRickshaw => 'Auto Rickshaw';

  @override
  String get heavyVehicle => 'Heavy Vehicle';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get petrol => 'Petrol';

  @override
  String get electric => 'Electric';

  @override
  String get vehicleMake => 'Vehicle Make';

  @override
  String get vehicleModel => 'Vehicle Model';

  @override
  String get vehicleNumber => 'Vehicle number';

  @override
  String get vehicleNumberHint => 'e.g. MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'Please enter vehicle number';

  @override
  String get selectMake => 'Select Vehicle Make';

  @override
  String get selectModel => 'Select Vehicle Model';

  @override
  String get installDevice => 'Install Trackify Device';

  @override
  String get installDeviceDesc =>
      'Quickly set up your Ajjas smart device with simple steps';

  @override
  String get activateSticker => 'Activate Contact Sticker';

  @override
  String get activateStickerDesc =>
      'Simple steps to quickly activate your contact sticker';

  @override
  String get exploreFreeApp => 'Explore Our Free App';

  @override
  String get exploreFreeAppDesc =>
      'Record rides using phone manually & keep track of it using our free app curated for you';

  @override
  String get logout => 'Logout';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

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
  String get upgradeToPlus => 'Upgrade to Ajjas Plus';

  @override
  String get getMoreOutOfAjjas => 'Get more out of Ajjas';

  @override
  String featuresExploredCount(Object count, Object total) {
    return 'You\'ve explored $count of $total features - keep going!';
  }

  @override
  String get manageVehiclesDesc => 'Manage all your Vehicles here';

  @override
  String get settingsDesc => 'Language, Account Settings & more';

  @override
  String get notifications => 'Notifications';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpAndSupportDesc => 'Get assistance and FAQs';

  @override
  String get settings => 'Settings';

  @override
  String get searchForSettings => 'Search for settings';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get backupAndRestoreDesc =>
      'Back up your rides data and restore them anytime.';

  @override
  String get appSettings => 'App Settings';

  @override
  String get appSettingsDesc => 'App Theme, Ride Heatmap and Emergency Feature';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationSettingsDesc =>
      'Notification preference & Notification sound';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyDesc =>
      'Change password, manage current session, delete your account';

  @override
  String get rateUsOnPlayStore => 'Rate us on Play Store';

  @override
  String get rateUsOnPlayStoreDesc => 'Share your valuable feedback';

  @override
  String get logoutDesc => 'Logout from this device';

  @override
  String get helpAndSuggestion => 'Help & Suggestion';

  @override
  String get reportAnIssue => 'Report an issue';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get whatIsYourIssueRelatedTo => 'What is your issue related to ?';

  @override
  String get shortDescriptionHint =>
      'Give us a short description (max 200 characters)';

  @override
  String get selectCallSlot => 'Select Call Slot';

  @override
  String get myIssues => 'My Issues';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get forceMigrate => 'Force Migrate';

  @override
  String get forceMigrateDesc1 =>
      'Use this option to fix backed up daily rides missed during app update.';

  @override
  String get forceMigrateDesc2 =>
      'Please note, this does not bring back your old rides from the server. It only migrates data in your local storage to the new data format for you to view it.';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get termsConditions => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get changeLog => 'Change log';

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
}
