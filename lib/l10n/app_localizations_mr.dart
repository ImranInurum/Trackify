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
  String get proSubtitle => 'जास्तीत जास्त वैशिष्ट्यांसह प्रगत ट्रॅकिंग';

  @override
  String get goTitle => 'ट्रॅकिफाय गो';

  @override
  String get goSubtitle => 'दैनंदिन वापरासाठी मानक ट्रॅकिंग';

  @override
  String get liteTitle => 'ट्रॅकिफाय लाइट';

  @override
  String get liteSubtitle => 'मूलभूत लोकेटर डिव्हाइस';

  @override
  String get realTime1s => 'रिअल-टाइम १ सेकंद ट्रॅकिंग';

  @override
  String get remoteEngineCutOff => 'रिमोट इंजिन कट-ऑफ';

  @override
  String get detailedFuelAnalytics => 'तपशीलवार इंधन विश्लेषण';

  @override
  String get realTime5s => 'रिअल-टाइम ५ सेकंद ट्रॅकिंग';

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
    return '$title कार्टमध्ये यशस्वीरित्या जोडले!';
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
      'रीअल-टाइम ट्रॅकिंग आणि मनःशांतीसाठी आता अजस डिव्हाइस खरेदी करा.';

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
  String get ridingBehaviour => 'रायडिंग वर्तणूक';

  @override
  String get ridingBehaviourVacationDesc =>
      'असे वाटते की तुमच्या वाहनाने थोडी सुट्टी घेतली आहे, कारण तुम्ही निवडलेल्या कालावधीत कोणतीही राइड घेतली नाही';

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
    return '$value% मागील कालावधीच्या तुलनेत';
  }
}
