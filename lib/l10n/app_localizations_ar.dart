// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get selectLanguage => 'اختر لغتك';

  @override
  String get letsGetStarted => 'دعنا نبدأ';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صالح';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String welcome(String email) {
    return 'أهلاً بك $email!';
  }

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get name => 'الاسم';

  @override
  String get nameHint => 'جون دو';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get mobileNumber => 'رقم الهاتف المحمول';

  @override
  String get mobileNumberHint => 'أدخل رقم الهاتف المحمول';

  @override
  String get mobileNumberRequired => 'رقم الهاتف المحمول مطلوب';

  @override
  String get invalidMobileNumber => 'يرجى إدخال رقم هاتف محمول صالح';

  @override
  String get country => 'البلد';

  @override
  String get countryHint => 'أدخل البلد';

  @override
  String get countryRequired => 'البلد مطلوب';

  @override
  String get state => 'الولاية/المحافظة';

  @override
  String get stateHint => 'أدخل الولاية';

  @override
  String get stateRequired => 'الولاية مطلوبة';

  @override
  String get city => 'المدينة';

  @override
  String get cityHint => 'أدخل المدينة';

  @override
  String get cityRequired => 'المدينة مطلوبة';

  @override
  String get selectProfileImage => 'اختر صورة الملف الشخصي';

  @override
  String get role => 'الدور';

  @override
  String get roleAdmin => 'مشرف';

  @override
  String get roleCustomer => 'عميل';

  @override
  String get selectRoleHint => 'اختر الدور';

  @override
  String get roleRequired => 'يرجى اختيار دور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSuccess => 'تم تسجيل المستخدم بنجاح، يرجى تسجيل الدخول';

  @override
  String get signUpFailed => 'فشل إنشاء الحساب';

  @override
  String get otpSent => 'تم إرسال رمز التحقق بنجاح';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordDesc =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get otpVerified => 'تم التحقق من الرمز بنجاح';

  @override
  String get verifyOtp => 'التحقق من الرمز';

  @override
  String get otpHeader => 'التحقق من رمز OTP';

  @override
  String otpDesc(String email) {
    return 'أدخل رمز OTP المرسل إلى $email.';
  }

  @override
  String get otp => 'رمز OTP';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'رمز OTP مطلوب';

  @override
  String get passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get passwordDesc =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمات المرور السابقة.';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أكد كلمة المرور الجديدة';

  @override
  String get confirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get selectDevice => 'اختر الجهاز';

  @override
  String get noDevicesFound => 'لم يتم العثور على أجهزة.';

  @override
  String get proceed => 'متابعة';

  @override
  String get unknownDevice => 'جهاز غير معروف';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'ابدأ لجلب الأجهزة.';

  @override
  String get recordRide => 'تسجيل الرحلة';

  @override
  String get phoneAsGps => 'اجعل هاتفك جهاز تتبع GPS';

  @override
  String get goToDashboard => 'الذهاب إلى لوحة القيادة';

  @override
  String get seeFullMap => 'رؤية الخريطة الكاملة';

  @override
  String get exploreMore => 'استكشف المزيد';

  @override
  String get reachMeSticker => 'ملصق ReachMe';

  @override
  String get products => 'المنتجات';

  @override
  String get fuelLogs => 'سجلات الوقود';

  @override
  String get locationSharing => 'مشاركة الموقع';

  @override
  String get documentFolder => 'مجلد المستندات';

  @override
  String get voiceMonitoring => 'ಧ್ವನಿ ಮೇಲ್ವಿಚಾರಣೆ';

  @override
  String get remoteEngineOff => 'إيقاف المحرك عن بعد';

  @override
  String get networkBooster => 'معزز الشبكة';

  @override
  String get emergency => 'طوارئ';

  @override
  String get overspeedAlert => 'تنبيه تجاوز السرعة';

  @override
  String get geoFenceAlert => 'تنبيه السياج الجغرافي';

  @override
  String get more => 'المزيد';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get bikeSmartMsg =>
      'أكثر من 1000 شخص جعلوا دراجاتهم ذكية باستخدام أجهزتنا';

  @override
  String get features => 'الميزات';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get contactUsDesc => 'لديك أسئلة؟ نحن هنا للمساعدة.';

  @override
  String get userReviews => 'تقييمات المستخدمين';

  @override
  String get accidentAlert => 'تنبيه الحوادث';

  @override
  String get antiTheftAlert => 'تنبيه ضد السرقة';

  @override
  String get geoFence => 'السياج الجغرافي';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get myGarage => 'مرآبي';

  @override
  String get noVehiclesInGarage => 'لم يتم العثور على مركبات في مرآبك.';

  @override
  String get unknownVehicle => 'مركبة غير معروفة';

  @override
  String get status => 'الحالة';

  @override
  String get active => 'نشط';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get proPlan => 'خطة برو';

  @override
  String get initializeGarage => 'ابدأ لجلب مرآبك.';

  @override
  String get ourProducts => 'منتجاتنا';

  @override
  String get proTitle => 'Trackify برو';

  @override
  String get proSubtitle => 'تتبع متقدم مع ميزات قصوى';

  @override
  String get goTitle => 'Trackify جو';

  @override
  String get goSubtitle => 'تتبع قياسي للاستخدام اليومي';

  @override
  String get liteTitle => 'Trackify لايت';

  @override
  String get liteSubtitle => 'جهاز تحديد المواقع الأساسي';

  @override
  String get realTime1s => 'تتبع في الوقت الفعلي كل ثانية';

  @override
  String get remoteEngineCutOff => 'قطع المحرك عن بعد';

  @override
  String get detailedFuelAnalytics => 'تحليلات وقود مفصلة';

  @override
  String get realTime5s => 'تتبع في الوقت الفعلي كل 5 ثوانٍ';

  @override
  String get antiTheftAlerts => 'تنبيهات ضد السرقة';

  @override
  String get basicJourneyLogs => 'سجلات الرحلات الأساسية';

  @override
  String get locationUpdates => 'تحديثات الموقع';

  @override
  String get batteryMonitor => 'مراقب البطارية';

  @override
  String get featuresLabel => 'الميزات:';

  @override
  String addedToCart(String title) {
    return 'تمت إضافة $title إلى السلة!';
  }

  @override
  String get buyNow => 'اشترِ الآن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String errorMsg(String message) {
    return 'خطأ: $message';
  }

  @override
  String get addVehicle => 'إضافة مركبة/جهاز';

  @override
  String get vehicleAdded => 'تم إضافة المركبة بنجاح!';

  @override
  String get vehicleType => 'نوع المركبة';

  @override
  String get twoWheeler => 'دراجة نارية';

  @override
  String get fourWheeler => 'سيارة';

  @override
  String get autoRickshaw => 'عربة توك توك';

  @override
  String get heavyVehicle => 'مركبة ثقيلة';

  @override
  String get fuelType => 'نوع الوقود';

  @override
  String get petrol => 'بنزين';

  @override
  String get electric => 'كهرباء';

  @override
  String get vehicleImage => 'صورة المركبة';

  @override
  String get newLabel => 'جديد';

  @override
  String get vehicleMake => 'ماركة المركبة';

  @override
  String get vehicleModel => 'موديل المركبة';

  @override
  String get vehicleNumber => 'رقم المركبة';

  @override
  String get vehicleNumberHint => 'مثال: MP46MX0743';

  @override
  String get pleaseEnterVehicleNumber => 'يرجى إدخال رقم المركبة';

  @override
  String get selectMake => 'اختر الماركة';

  @override
  String get selectModel => 'اختر الموديل';

  @override
  String get installDevice => 'تثبيت جهاز Trackify';

  @override
  String get installDeviceDesc =>
      'قم بإعداد جهاز Ajjas الذكي الخاص بك بسرعة بخطوات بسيطة';

  @override
  String get activateSticker => 'تفعيل ملصق الاتصال';

  @override
  String get activateStickerDesc =>
      'خطوات بسيطة لتفعيل ملصق الاتصال الخاص بك بسرعة';

  @override
  String get exploreFreeApp => 'استكشف تطبيقنا المجاني';

  @override
  String get exploreFreeAppDesc =>
      'سجل الرحلات يدوياً من الهاتف وتتبعها من تطبيقنا المجاني';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get dataPlan => 'خطة البيانات';

  @override
  String get warranty => 'الضمان';

  @override
  String expiresInDays(String days) {
    return 'ينتهي خلال $days يوماً';
  }

  @override
  String get rechargeNow => 'اشحن الآن';

  @override
  String get renewNow => 'جدد الآن';

  @override
  String get secureYourVehicle => 'أمن مركبتك';

  @override
  String get secureYourVehicleDesc =>
      'اشترِ جهاز Ajjas الآن لتتبع مباشر وراحة بال.';

  @override
  String get boughtDeviceInstallNow => 'هل اشتريت الجهاز؟ ';

  @override
  String get installNow => 'ثبته الآن';

  @override
  String get buyAjjasDevice => 'اشترِ جهاز Ajjas';

  @override
  String get lite4G => 'لايت 4G';

  @override
  String get swipeToLock => 'اسحب للقفل';

  @override
  String get upgradeToPlus => 'ترقية إلى Ajjas Plus';

  @override
  String get getMoreOutOfAjjas => 'احصل على المزيد من Ajjas';

  @override
  String featuresExploredCount(Object count, Object total) {
    return 'لقد استكشفت $count من أصل $total ميزة - استمر!';
  }

  @override
  String get manageVehiclesDesc => 'إدارة جميع مركباتك هنا';

  @override
  String get settingsDesc => 'اللغة، إعدادات الحساب، والمزيد';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get notificationsFetchedSuccessfully => 'تم جلب الإشعارات بنجاح';

  @override
  String get errorFetchingNotifications => 'خطأ في جلب الإشعارات';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get helpAndSupportDesc => 'المساعدة والأسئلة الشائعة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get searchForSettings => 'البحث في الإعدادات';

  @override
  String get backupAndRestore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupAndRestoreDesc =>
      'انسخ بيانات رحلاتك احتياطياً واستعدها في أي وقت.';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get appSettingsDesc =>
      'ثيم التطبيق، خريطة الرحلات الحرارية، وميزة الطوارئ';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notificationSettingsDesc => 'أولوية الإشعارات وصوت الإشعار';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacyDesc =>
      'تغيير كلمة المرور، إدارة الجلسات الحالية، حذف حسابك';

  @override
  String get rateUsOnPlayStore => 'قيمنا على متجر Play';

  @override
  String get rateUsOnPlayStoreDesc => 'شاركنا رأيك القيم';

  @override
  String get logoutDesc => 'تسجيل الخروج من هذا الجهاز';

  @override
  String get helpAndSuggestion => 'المساعدة والاقتراحات';

  @override
  String get reportAnIssue => 'الإبلاغ عن مشكلة';

  @override
  String get suggestion => 'اقتراح';

  @override
  String get whatIsYourIssueRelatedTo => 'بماذا تتعلق مشكلتك؟';

  @override
  String get shortDescriptionHint => 'أعطنا وصفاً قصيراً (بحد أقصى 200 حرف)';

  @override
  String get selectCallSlot => 'اختر وقتاً للاتصال';

  @override
  String get myIssues => 'مشكلاتي';

  @override
  String get whatsApp => 'واتساب';

  @override
  String get forceMigrate => 'هجرة قسرية';

  @override
  String get forceMigrateDesc1 =>
      'استخدم هذا الخيار لإصلاح الرحلات اليومية المفقودة أثناء تحديثات التطبيق.';

  @override
  String get forceMigrateDesc2 =>
      'يرجى ملاحظة أن هذا لا يعيد رحلاتك القديمة من الخادم. إنه يهاجر البيانات في تخزينك المحلي فقط إلى تنسيق البيانات الجديد.';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get changeLog => 'سجل التغييرات';

  @override
  String get todayLabel => '(اليوم)';

  @override
  String get ridingBehaviour => 'سلوك القيادة';

  @override
  String get ridingBehaviourVacationDesc =>
      'يبدو أن مركبتك أخذت إجازة قصيرة، حيث لم تقم بأي رحلات خلال الفترة الزمنية المحددة';

  @override
  String get journey => 'رحلة';

  @override
  String get distanceTravelled => 'المسافة المقطوعة';

  @override
  String get timeDuration => 'المدة الزمنية';

  @override
  String get speed => 'السرعة';

  @override
  String get averageSpeed => 'متوسط السرعة';

  @override
  String get topSpeed => 'السرعة القصوى';

  @override
  String get fuel => 'وقود';

  @override
  String get fuelConsumed => 'الوقود المستهلك';

  @override
  String get fuelCost => 'تكلفة الوقود';

  @override
  String vsPreviousPeriod(String value) {
    return '$value% مقارنة بالفترة السابقة';
  }

  @override
  String get vehicleMakeListEmpty => 'قائمة مصنعي المركبات فارغة لهذا الاختيار';

  @override
  String get vehicleModelListEmpty =>
      'قائمة موديلات المركبات فارغة لهذا الاختيار';

  @override
  String get deviceInstallation => 'ಸಾಧನ ಸ್ಥಾಪನೆ';

  @override
  String get scanActivationCode => 'مسح كود التفعيل';

  @override
  String get enterActivationCodeManually => 'إدخال كود التفعيل يدوياً';

  @override
  String get openAjjasBoxInstruction =>
      'افتح صندوق Ajjas للحصول على كود QR للتفعيل.';

  @override
  String get continueText => 'متابعة';

  @override
  String get enterUID => 'أدخل UID';

  @override
  String get enterIMEINumber => 'أدخل رقم IMEI';

  @override
  String get close => 'إغلاق';

  @override
  String get uidRequired => 'UID مطلوب';

  @override
  String get imeiRequired => 'رقم IMEI مطلوب';

  @override
  String get deviceAssignedSuccess => 'تم تعيين الجهاز للمركبة بنجاح!';

  @override
  String get assigningDevice => 'يتم تعيين الجهاز...';

  @override
  String get invalidImeiError => 'يرجى إدخال رقم IMEI صالح مكون من 15 رقماً';

  @override
  String get sharedRides => 'الرحلات المشتركة';

  @override
  String get savedRides => 'الرحلات المحفوظة';

  @override
  String get allRides => 'كل الرحلات';

  @override
  String get trips => 'الرحلات';

  @override
  String clicked(String value) {
    return 'تم النقر على $value';
  }

  @override
  String get noDailyRides => 'لا توجد رحلات يومية لعرضها';

  @override
  String get getStartedFirstRide => 'ابدأ بأخذ رحلتك الأولى';

  @override
  String get durationLabel => 'المدة';

  @override
  String get km => 'كم';

  @override
  String get kmh => 'كم/س';

  @override
  String get tripEmptyQuote =>
      '“اجمع رحلاتك في أسفار، أضف ذكريات وأعد عيش الرحلة”';

  @override
  String ridesCompletedCount(String completed, String total) {
    return 'الرحلات المكتملة: $completed/$total';
  }

  @override
  String get unlockTripsRequirement =>
      'تحتاج إلى 3 رحلات على الأقل لفتح ميزة الأسفار';

  @override
  String get createNewTrip => 'إنشاء سفر جديد';

  @override
  String get startByCreatingTrip => 'ابدأ بإنشاء سفر جديد';

  @override
  String get skip => 'تخطي';

  @override
  String get todayText => 'اليوم';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get rideDuration => 'مدة الرحلة';

  @override
  String get speedLabel => 'السرعة';

  @override
  String get minutesShort => 'د';

  @override
  String get secondsShort => 'ث';

  @override
  String get getMoreOutOfTrackify => 'احصل على المزيد من Trackify';

  @override
  String get discoverMoreDesc => 'اكتشف المزيد — أشياء رائعة بانتظارك!';

  @override
  String get serviceLogs => 'سجلات الخدمة';

  @override
  String get safeParking => 'ركن آمن';

  @override
  String get appUpdates => 'تحديثات التطبيق';

  @override
  String get deviceDataPlanLabel => 'خطة بيانات الجهاز';

  @override
  String get deviceWarrantyLabel => 'ضمان الجهاز';

  @override
  String get videoTutorials => 'فيديوهات تعليمية';

  @override
  String get exploreNow => 'استكشف الآن';

  @override
  String get plusLabel => 'بلس';

  @override
  String get mapStyleLabel => 'نمط الخريطة';

  @override
  String get darkStyle => 'داكن';

  @override
  String get lightStyle => 'فاتح';

  @override
  String get simpleStyle => 'بسيط';

  @override
  String get satelliteStyle => 'قمر صناعي';

  @override
  String get mapOptionsLabel => 'خيارات الخريطة';

  @override
  String get trafficLabel => 'حركة المرور';

  @override
  String get labelsLabel => 'العلامات';

  @override
  String get sharedWithMe => 'تمت مشاركتها معي';

  @override
  String get todaysStats => 'إحصائيات اليوم';

  @override
  String parkedSinceTime(String time) {
    return 'مركون منذ: $time';
  }

  @override
  String kmsMoreToGo(String value) {
    return 'بقي $value كم';
  }

  @override
  String get buyTrackifyDevice => 'اشترِ جهاز Trackify';

  @override
  String get recordViaPhone => 'سجل عبر الهاتف';

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
  String get myProfile => 'ملفي الشخصي';

  @override
  String get profileCompleteness => 'اكتمال الملف الشخصي';

  @override
  String lastUpdatedOn(String date) {
    return 'آخر تحديث في $date';
  }

  @override
  String get addProfilePicture => 'أضف صورة ملفك الشخصي';

  @override
  String get personalDetails => 'التفاصيل الشخصية';

  @override
  String get userNameLabel => 'الاسم';

  @override
  String get emailAddressLabel => 'عنوان البريد الإلكتروني';

  @override
  String get mobileNumberLabel => 'رقم الهاتف المحمول';

  @override
  String get countryLabel => 'البلد';

  @override
  String get stateLabel => 'الولاية';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get medicalInsuranceInfo => 'معلومات التأمين الطبي';

  @override
  String get addMedicalInsuranceInfo => 'أضف معلومات التأمين الطبي';

  @override
  String get vehicleInsuranceInfo => 'معلومات تأمين المركبة';

  @override
  String get editViewVehicleInsuranceDesc =>
      'قم بتحرير وعرض تفاصيل تأمين مركبتك في إعدادات المركبة.';

  @override
  String get myGarageVehiclePath => 'مرآبي > المركبة';

  @override
  String get emergencyContacts => 'جهات اتصال الطوارئ';

  @override
  String get addEditEmergencyContactDesc =>
      'أضف وحرر قائمة جهات اتصال الطوارئ في إعدادات المركبة.';

  @override
  String get smartContactSticker => 'ملصق الاتصال الذكي';

  @override
  String get stickerSubtitle => 'خطوة نحو جعل مركبتك آمنة وذكية';

  @override
  String get activateContactSticker => 'تفعيل ملصق الاتصال';

  @override
  String get buyNewContactSticker => 'شراء ملصق اتصال جديد';

  @override
  String get beyondParkingProblems => 'ما وراء مشاكل الركن';

  @override
  String get noParkings => 'ممنوع الركن';

  @override
  String get emergencies => 'الطوارئ';

  @override
  String get vehicleTowing => 'سحب المركبة';

  @override
  String get getInformedStayConnected => 'ابقَ مطلعاً ومتصلاً بمركبتك';

  @override
  String get securedCalls => 'مكالمات آمنة';

  @override
  String get securedCallsDesc =>
      'مكالمات مخفية عبر الإنترنت - تحافظ على خصوصية رقم هاتفك.';

  @override
  String get notificationHistory => 'سجل الإشعارات';

  @override
  String get notificationHistoryDesc => 'تتبع جميع الإشعارات الحالية والسابقة';

  @override
  String get beInformed => 'كن مطلعاً';

  @override
  String get beInformedDesc =>
      'اعرف فوراً متى يقوم شخص ما بمسح كود QR الخاص بك واتخذ إجراءً فورياً عندما يتصل بك.';

  @override
  String get controlWhatOthersSee => 'تحكم فيما يراه الآخرون';

  @override
  String get controlWhatOthersSeeDesc =>
      'خصص التفاصيل المعروضة عندما يقوم شخص ما بمسح QR.';

  @override
  String get preventFrustrationDamage => 'منع الإحباط والضرر';

  @override
  String get preventFrustrationDamageDesc =>
      'تجنب النزاعات وأضرار المركبة الناتجة عن الركن غير المناسب.';

  @override
  String get serviceLogsSubtitle =>
      'لا تفوت خدمة المركبة أبداً. احصل على تذكيرات وتتبع المصاريف للحفاظ على مركبتك في أفضل حالة.';

  @override
  String get addServiceLogs => 'أضف سجلات الخدمة';

  @override
  String get uploadServicingBill => 'رفع فاتورة الخدمة';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get maxFileSizeNote => 'ملاحظة: الحد الأقصى لحجم الملف هو 5 ميجابايت';

  @override
  String get serviceDate => 'تاريخ الخدمة';

  @override
  String get billingAmount => 'مبلغ الفاتورة';

  @override
  String get serviceCenterName => 'اسم مركز الخدمة';

  @override
  String get serviceCenterContact => 'جهة اتصال مركز الخدمة';

  @override
  String get additionalNote => 'ملاحظة إضافية';

  @override
  String get saveDetails => 'حفظ التفاصيل';

  @override
  String get selectVehicle => 'اختر مركبة';

  @override
  String get liveTab => 'مباشر';

  @override
  String get historyTab => 'السجل';

  @override
  String get liveLocationSharingActive => 'مشاركة الموقع المباشر نشطة';

  @override
  String get noLiveLocationShared => 'لا توجد مشاركة موقع مباشر حالياً';

  @override
  String get realTimeSharingDesc =>
      'يتم مشاركة موقعك في الوقت الفعلي مع جهات اتصال مختارة.';

  @override
  String get startSharingPhoneDesc =>
      'ابدأ مشاركة موقع هاتفك لمساعدة الآخرين في تتبعك';

  @override
  String get noHistoryAvailable => 'لا يوجد سجل متاح';

  @override
  String get historyDesc =>
      'ستظهر سجلات مشاركة الموقع السابقة هنا بمجرد اكتمالها.';

  @override
  String get stopSharing => 'إيقاف المشاركة';

  @override
  String get shareLocation => 'مشاركة الموقع';

  @override
  String get startSharing => 'بدء المشاركة';

  @override
  String get phoneTracking => 'تتبع الهاتف';

  @override
  String get liveRecordTab => 'تسجيل مباشر';

  @override
  String get statsTab => 'إحصائيات';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get monthly => 'شهري';

  @override
  String get custom => 'مخصص';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get totalRides => 'إجمالي الرحلات';

  @override
  String get avgSpeed => 'متوسط السرعة';

  @override
  String get totalFuel => 'إجمالي الوقود';

  @override
  String get overallDistance => 'المسافة الكلية';

  @override
  String get drivingTime => 'وقت القيادة';

  @override
  String get safetyScore => 'درجة الأمان';

  @override
  String get speedAlertInput => 'مدخلات تنبيه السرعة';

  @override
  String get alertTitle => 'عنوان التنبيه';

  @override
  String get speedLimitKmH => 'حد السرعة (كم/س)';

  @override
  String get timeDurationSec => 'المدة الزمنية (ثوانٍ)';

  @override
  String get selectYourVehicle => 'اختر مركبتك';

  @override
  String get submit => 'إرسال';

  @override
  String get selectVehiclesOverspeedAlert =>
      'اختر المركبات التي تريد تطبيق تنبيه تجاوز السرعة عليها';

  @override
  String get selected => 'مختار';

  @override
  String get sec => 'ثانية';

  @override
  String get kmHr => 'كم/س';

  @override
  String get viewMore => 'عرض المزيد';

  @override
  String get viewLess => 'عرض أقل';

  @override
  String get previousRides => 'الرحلات السابقة';

  @override
  String get seeAll => 'رؤية الكل';

  @override
  String get videosYouMightLike => 'فيديوهات قد تعجبك';

  @override
  String get scrollToTop => 'العودة للأعلى';

  @override
  String get noRecentRidesFound => 'لم يتم العثور على رحلات حديثة';

  @override
  String get failedToLoadRides => 'فشل تحميل الرحلات';

  @override
  String get hrMin => 'ساعة:دقيقة';

  @override
  String get vehicleLabel => 'مركبة';

  @override
  String get switchLabel => 'تبديل';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get rechargePlans => 'خطط الشحن';

  @override
  String get superComboPlan => 'خطة سوبر كومبو';

  @override
  String get month12Validity => 'صلاحية 12 شهراً';

  @override
  String get month6Validity => 'صلاحية 6 أشهر';

  @override
  String saveAmount(Object amount) {
    return 'وفر $amount مع هذه الخطة';
  }

  @override
  String get superComboPopularity =>
      '95% من المستخدمين يختارون خطة السوبر كومبو';

  @override
  String get appSimRecharge => 'شحن التطبيق والشريحة';

  @override
  String get extendedWarranty => 'ضمان ممتد';

  @override
  String get plusMembership => 'عضوية بلس';

  @override
  String get continueSuperCombo => 'المتابعة مع خطة السوبر كومبو';

  @override
  String get continue12Month => 'المتابعة مع خطة 12 شهراً';

  @override
  String get continue6Month => 'المتابعة مع خطة 6 أشهر';

  @override
  String get vehicleDocumentsTitle => 'مستندات المركبة';

  @override
  String get personalDocumentsSubtitle =>
      'احتفظ بمستندات مركبتك في متناول اليد عن طريق رفعها';

  @override
  String get vehicleRC => 'مركبة RC';

  @override
  String get insurance => 'تفاصيل التأمين';

  @override
  String get puc => 'شهادة PUC';

  @override
  String get vehicleRCTitle => 'مركبة RC';

  @override
  String get insuranceTitle => 'تفاصيل التأمين';

  @override
  String get pucTitle => 'شهادة PUC';

  @override
  String get notificationControlsTitle => 'التحكم في الإشعارات';

  @override
  String get ignitionOnOffTitle => 'تشغيل/إيقاف الإشعال';

  @override
  String get ignitionOnOffDesc =>
      'احصل على إشعار عند تشغيل أو إيقاف إشعال المركبة';

  @override
  String get motionWithIgnitionOffTitle => 'حركة مع إيقاف الإشعال';

  @override
  String get motionWithIgnitionOffDesc =>
      'احصل على إشعار عندما تتحرك المركبة أثناء إيقاف الإشعال';

  @override
  String get powerSupplyOffTitle => 'إيقاف مزود الطاقة';

  @override
  String get powerSupplyOffDesc => 'احصل على إشعار عندما لا يتلقى Ajjas طاقة';

  @override
  String get appNotification => 'إشعار التطبيق';

  @override
  String get odometerReading => 'قراءة العداد';

  @override
  String get update => 'تحديث';

  @override
  String get gpsReadingNote => 'قراءة مبنية على GPS، قد توجد اختلافات طفيفة.';

  @override
  String get tankCapacity => 'سعة الخزان';

  @override
  String get afterLastRefuel => 'بعد آخر تزويد بالوقود';

  @override
  String get fuelRemaining => 'الوقود المتبقي';

  @override
  String get distanceRemaining => 'المسافة المتبقية';

  @override
  String get mileageArai => 'الاستهلاك (ARAI)';

  @override
  String get spendingOnFuel => 'الإنفاق على الوقود';

  @override
  String get today => 'اليوم';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisYear => 'هذه السنة';

  @override
  String get all => 'الكل';

  @override
  String get customDates => 'تواريخ مخصصة';

  @override
  String get refuelHistory => 'سجل تزويد الوقود';

  @override
  String get addRefuelingDetails => 'أضف تفاصيل تزويد الوقود';

  @override
  String get fuelStations => 'محطات الوقود';

  @override
  String get dashboard => 'لوحة القيادة';

  @override
  String get litersShort => 'لتر';

  @override
  String get fuelEstimateNote =>
      'هذه القيم تقديرية بناءً على مدخلات الوقود الخاصة بك. أضف سجلات الوقود بانتظام لتحسين الدقة.';

  @override
  String get gotIt => 'فهمت';

  @override
  String get currentOdometerReading => 'قراءة العداد الحالية';

  @override
  String get odometerUpdateDesc =>
      'حدث العداد بانتظام للحصول على تقديرات دقيقة للوقود والمسافة';

  @override
  String get updateTankCapacity => 'تحديث سعة الخزان';

  @override
  String get tankCapacityDesc => 'أدخل أقصى سعة وقود لخزان مركبتك';

  @override
  String get litres => 'لترات';

  @override
  String get kms => 'كم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get updateMileageArai => 'تحديث الاستهلاك (ARAI)';

  @override
  String get mileageDesc => 'أدخل استهلاك وقود مركبتك وفقاً لمعايير ARAI';

  @override
  String get kmL => 'كم/لتر';

  @override
  String get serviceLogAddedSuccess => 'تم إضافة سجل الخدمة بنجاح';

  @override
  String get currencySymbol => '₹';

  @override
  String get refuelHistoryComingSoon => 'سجل تزويد الوقود قريباً';

  @override
  String get fuelStationsComingSoon => 'محطات الوقود قريباً';

  @override
  String percentageValue(String value) {
    return '$value%';
  }

  @override
  String get totalFuelAdded => 'إجمالي الوقود المضاف';

  @override
  String get totalSpendings => 'إجمالي المصاريف';

  @override
  String get avgMileage => 'متوسط الاستهلاك';

  @override
  String get refuels => 'عمليات تزويد';

  @override
  String get refuelingHistory => 'سجل تزويد الوقود';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get mostExpensive => 'الأغلى';

  @override
  String get leastExpensive => 'الأرخص';

  @override
  String get bestMileage => 'أفضل استهلاك';

  @override
  String get worstMileage => 'أسوأ استهلاك';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get error => 'Something went wrong';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String hintEg(String value) {
    return 'مثال: $value';
  }

  @override
  String get addStation => 'إضافة محطة';

  @override
  String get nearby => 'بالقرب';

  @override
  String get favourites => 'المفضلة';

  @override
  String get addedByMe => 'أضيفت بواسطتي';

  @override
  String get noFavourites => 'لا توجد مفضلات بعد';

  @override
  String get noStationsAdded => 'لا توجد محطات مضافة بعد';

  @override
  String get fuelStationNearVehicle => 'محطة وقود بالقرب من المركبة';

  @override
  String get warranty_title => 'ضمان الجهاز';

  @override
  String get warranty_benefitsTitle => 'فوائد الضمان';

  @override
  String get warranty_extend => 'مدد ضمانك وحافظ على سلامة جهازك';

  @override
  String get warranty_vehicle => 'المركبة';

  @override
  String get warranty_expiry => 'انتهاء الضمان';

  @override
  String get warranty_button => 'تمديد الضمان — ';

  @override
  String get warranty_button_old => '₹4,999';

  @override
  String get benefit1_highlight => 'تغطية ممتازة ';

  @override
  String get benefit1_normal => '— حماية كاملة للأجهزة ضد عيوب التصنيع.';

  @override
  String get benefit2_highlight => 'إصلاح مجاني ';

  @override
  String get benefit2_normal => '— جميع الخدمات وقطع الغيار دون أي تكلفة.';

  @override
  String get benefit3_highlight => 'دعم 24/7 ';

  @override
  String get benefit3_normal => '— خدمة عملاء ذات أولوية متى احتجت إليها.';

  @override
  String get benefit4_highlight => 'لا توجد رسوم خفية ';

  @override
  String get benefit4_normal => '— رسوم ثابتة واحدة، راحة بال كاملة.';

  @override
  String get initiatingEmergencyAlert =>
      'يتم إرسال تنبيه طوارئ لمستخدمي Trackify';

  @override
  String get pleaseUseResponsibly => 'يرجى الاستخدام بمسؤولية';

  @override
  String get secondsBeforeSendingAlert => 'ثوانٍ قبل إرسال التنبيه';

  @override
  String get sendNow => 'إرسال الآن';

  @override
  String get geoFenceTitle => 'السياج الجغرافي';

  @override
  String geoFenceRadius(String radius) {
    return 'نطاق: $radiusم';
  }

  @override
  String get geoFenceLocating => 'جاري تحديد الموقع...';

  @override
  String get geoFenceNameRequired => 'اسم السياج الجغرافي مطلوب';

  @override
  String get geoFenceSaveSuccess => 'تم حفظ السياج الجغرافي بنجاح!';

  @override
  String get geoFenceSearchHint => 'البحث عن موقع...';

  @override
  String get geoFenceSelectType => 'اختر نوع السياج الجغرافي لـ ';

  @override
  String get geoFenceTypeHome => 'المنزل';

  @override
  String get geoFenceTypeOffice => 'المكتب';

  @override
  String get geoFenceTypeFamily => 'العائلة';

  @override
  String get geoFenceTypeParking => 'الموقف';

  @override
  String get geoFenceTypeOthers => 'أخرى';

  @override
  String get geoFenceNameFieldHint => 'أدخل اسم السياج الجغرافي، مثال: المنزل';

  @override
  String get geoFenceAddSmsContacts => 'أضف جهات اتصال لتنبيهات SMS';

  @override
  String get geoFenceEmptyStateDesc =>
      'ارسم دائرة على الخريطة واحصل على تنبيهات كلما دخلت أو خرجت الدراجة من النطاق.';

  @override
  String get addGeoFenceButton => 'إضافة سياج جغرافي';

  @override
  String get safeParkingTitle => 'ركن آمن';

  @override
  String get schedule => 'جدولة';

  @override
  String get setupSafeParking => 'إعداد الركن الآمن';

  @override
  String get safeParkingSubtitle =>
      'احصل على تنبيهات اتصال لتشغيل المحرك وتنبيهات السحب';

  @override
  String get activate => 'تفعيل';

  @override
  String get activated => 'تم التفعيل';

  @override
  String get safeParkingDescription =>
      'تمكين التنبيهات عند اكتشاف تشغيل المحرك أو السحب';

  @override
  String get geoFenceDeleteConfirmation =>
      'هل أنت متأكد أنك تريد حذف هذا السياج الجغرافي؟';

  @override
  String get geoFenceTurnOffConfirmation =>
      'هل أنت متأكد أنك تريد إيقاف هذا السياج الجغرافي؟';

  @override
  String get turnOff => 'إيقاف';

  @override
  String get plusMembershipTitle => 'عضوية بلس';

  @override
  String get membership => 'العضوية';

  @override
  String get premiumBenefits => 'المزايا الممتازة';

  @override
  String get otherBenefits => 'مزايا أخرى';

  @override
  String get trackifyPlusReviews => 'تقييمات TRACKIFY PLUS';

  @override
  String get offerings => 'العروض';

  @override
  String get plus => 'بلس';

  @override
  String get regular => 'عادي';

  @override
  String upgradeNowAtJust(String price) {
    return 'رقي الآن بسعر $price فقط';
  }

  @override
  String get viewMoreReviews => 'عرض المزيد من التقييمات';

  @override
  String get speciallyForYou => 'خصيصاً لك';

  @override
  String get footerMotto =>
      'بناء مستقبل حيث تكون كل دراجة ذكية\nوكل راكب آمناً';

  @override
  String get cropDocument => 'قص المستند';

  @override
  String get cropVehicleImage => 'قص صورة المركبة';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get pdf => 'PDF';

  @override
  String get fileTooLarge => 'حجم الملف يتجاوز 5 ميجابايت';

  @override
  String get pickImageError => 'خطأ في اختيار الصورة';

  @override
  String get pickPdfError => 'خطأ في اختيار PDF';

  @override
  String get pdfTooLarge => 'حجم PDF يتجاوز 5 ميجابايت';

  @override
  String get uploadDocuments => 'رفع المستندات';

  @override
  String get frontSide => 'الجانب الأمامي*';

  @override
  String get backSide => 'الجانب الخلفي';

  @override
  String get commitmentText => 'مستنداتك\nالتزامنا';

  @override
  String get documentsSafe => 'مستنداتك مشفرة وآمنة';

  @override
  String get addDocument => 'إضافة مستند';

  @override
  String get frontRequired => 'مستند الجانب الأمامي مطلوب';

  @override
  String get successMessage => 'تم إضافة المستند بنجاح';

  @override
  String get selectExpiryDate => 'تاريخ الانتهاء';

  @override
  String get documentsEncrypted => 'مستنداتك مشفرة وآمنة';

  @override
  String get fileSizeNote => 'ملاحظة: الحد الأقصى لحجم الملف هو 5 ميجابايت';

  @override
  String get personalDocumentsTitle => 'المستندات الشخصية';

  @override
  String get drivingLicense => 'Driving License';

  @override
  String get drivingLicenseTitle => 'رخصة القيادة';

  @override
  String get otherDocuments => 'Other Documents';

  @override
  String get otherDocumentTitle => 'مستندات أخرى';

  @override
  String get documentName => 'اسم المستند*';

  @override
  String get billsTitle => 'الفواتير';

  @override
  String get billsDescription =>
      'أضف واضبط تذكيرات لأيام خدمة مركبتك، وارفع الفواتير والمزيد';

  @override
  String get movedTo => 'انتقل إلى';

  @override
  String get viewNow => 'عرض الآن';

  @override
  String get accessoryBills => 'فواتير الملحقات';

  @override
  String get tutorialVideos => 'ಟ್ಯುಟೋರಿಯಲ್ ವೀಡಿಯೊಗಳು';

  @override
  String get videos => 'ವೀಡಿಯೊಗಳು';

  @override
  String get location => 'ಸ್ಥಳ';

  @override
  String get amazingFeatures => 'ಅದ್ಭುತ ವೈಶಿಷ್ಟ್ಯಗಳು';

  @override
  String get loading => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...';

  @override
  String get noVideos => 'ಯಾವುದೇ ವೀಡಿಯೊಗಳು ಲಭ್ಯವಿಲ್ಲ';
}
