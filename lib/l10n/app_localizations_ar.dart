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
  String get mobileNumber => 'رقم الجوال';

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
  String get state => 'الولاية';

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
  String get voiceMonitoring => 'مراقبة الصوت';

  @override
  String get remoteEngineOff => 'إيقاف المحرك عن بعد';

  @override
  String get networkBooster => 'معزز الشبكة';

  @override
  String get emergency => 'طوارئ';

  @override
  String get overspeedAlert => 'تنبيه تجاوز السرعة';

  @override
  String get geoFenceAlert => 'تنبيه السياج الجغرافية';

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
      'قم بإعداد جهاز Trackify الذكي الخاص بك بسرعة بخطوات بسيطة';

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
      'اشترِ جهاز Trackify الآن لتتبع مباشر وراحة بال.';

  @override
  String get boughtDeviceInstallNow => 'هل اشتريت الجهاز؟ ';

  @override
  String get installNow => 'ثبته الآن';

  @override
  String get buyTrackifyDevice => 'اشترِ جهاز Trackify';

  @override
  String get lite4G => 'لايت 4G';

  @override
  String get swipeToLock => 'اسحب للقفل';

  @override
  String get upgradeToPlus => 'ترقية إلى Trackify Plus';

  @override
  String get getMoreOutOfTrackify => 'احصل على المزيد من Trackify';

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
  String get topSpeed => 'أعلى سرعة';

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
  String get deviceInstallation => 'تثبيت الجهاز';

  @override
  String get scanActivationCode => 'مسح كود التفعيل';

  @override
  String get enterActivationCodeManually => 'إدخال كود التفعيل يدوياً';

  @override
  String get openTrackifyBoxInstruction =>
      'افتح صندوق Trackify للحصول على كود QR للتفعيل.';

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
  String get overallDistance => 'المسافة الإجمالية';

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
  String get superComboPlan => 'خطة السوبر كومبو';

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
  String get vehicleDocumentsTitle => 'وثائق المركبة';

  @override
  String get personalDocumentsSubtitle =>
      'احتفظ بمستندات مركبتك في متناول اليد عن طريق تحميلها';

  @override
  String get vehicleRC => 'رخصة المركبة';

  @override
  String get insurance => 'التأمين';

  @override
  String get puc => 'شهادة التلوث';

  @override
  String get vehicleRCTitle => 'تفاصيل رخصة المركبة';

  @override
  String get insuranceTitle => 'تفاصيل التأمين';

  @override
  String get pucTitle => 'شهادة PUC';

  @override
  String get notificationControlsTitle => 'عناصر التحكم في الإشعارات';

  @override
  String get ignitionOnOffTitle => 'تشغيل/إيقاف الإشعال';

  @override
  String get ignitionOnOffDesc =>
      'احصل على إشعار عندما يكون إشعال المركبة في وضع التشغيل أو الإيقاف';

  @override
  String get motionWithIgnitionOffTitle => 'الحركة مع إيقاف الإشعال';

  @override
  String get motionWithIgnitionOffDesc =>
      'احصل على إشعار عندما تتحرك المركبة وهي في وضع إيقاف الإشعال';

  @override
  String get powerSupplyOffTitle => 'إيقاف مزود الطاقة';

  @override
  String get powerSupplyOffDesc =>
      'احصل على إشعار عندما لا يتلقى Trackify الطاقة';

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
  String get addRefuelingDetails => 'إضافة تفاصيل التزود بالوقود';

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
  String get error => 'حدث خطأ ما';

  @override
  String get noDataAvailable => 'لا تتوفر بيانات';

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
  String get cropDocument => 'اقتصاص المستند';

  @override
  String get cropVehicleImage => 'اقتصاص صورة المركبة';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get pdf => 'PDF';

  @override
  String get fileTooLarge => 'حجم الملف يتجاوز حد 5 ميجابايت';

  @override
  String get pickImageError => 'خطأ في اختيار الصورة';

  @override
  String get pickPdfError => 'خطأ في اختيار ملف PDF';

  @override
  String get pdfTooLarge => 'حجم ملف PDF يتجاوز حد 5 ميجابايت';

  @override
  String get uploadDocuments => 'رفع المستندات';

  @override
  String get frontSide => 'الجانب الأمامي';

  @override
  String get backSide => 'الجانب الخلفي';

  @override
  String get commitmentText =>
      'نحن ملتزمون بحماية خصوصيتك وضمان أمان مستنداتك معنا.';

  @override
  String get documentsSafe => 'مستنداتك آمنة معنا';

  @override
  String get addDocument => 'إضافة مستند';

  @override
  String get frontRequired => 'الوثيقة الأمامية مطلوبة';

  @override
  String get successMessage => 'تم حفظ المستند بنجاح';

  @override
  String get selectExpiryDate => 'اختر تاريخ الانتهاء';

  @override
  String get documentsEncrypted => 'مستنداتك مشفرة وآمنة';

  @override
  String get fileSizeNote => 'ملاحظة: الحد الأقصى لحجم الملف هو 5 ميجابايت';

  @override
  String get personalDocumentsTitle => 'المستندات الشخصية';

  @override
  String get drivingLicense => 'رخصة القيادة';

  @override
  String get drivingLicenseTitle => 'رخصة القيادة';

  @override
  String get otherDocuments => 'مستندات أخرى';

  @override
  String get otherDocumentTitle => 'مستندات أخرى';

  @override
  String get documentName => 'اسم المستند*';

  @override
  String get billsTitle => 'الفواتير';

  @override
  String get billsDescription => 'قم برفع وإدارة فواتير مركبتك';

  @override
  String get movedTo => 'تم النقل إلى';

  @override
  String get viewNow => 'عرض الآن';

  @override
  String get accessoryBills => 'فواتير الملحقات';

  @override
  String get tutorialVideos => 'فيديوهات تعليمية';

  @override
  String get videos => 'فيديوهات';

  @override
  String get location => 'الموقع';

  @override
  String get amazingFeatures => 'ميزات رائعة';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get noVideos => 'لا توجد فيديوهات متاحة';

  @override
  String get apply => 'تطبيق';

  @override
  String get noRecordsFound => 'لم يتم العور على سجلات';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get notificationTypes => 'أنواع الإشعارات';

  @override
  String get motionSensed => 'تم اكتشاف حركة';

  @override
  String get ignitionOff => 'إيقاف الإشعال';

  @override
  String get ignitionOn => 'بدء الإشعال';

  @override
  String get accidentDetected => 'تم اكتشاف حادث';

  @override
  String get stationaryFallDetected => 'تم اكتشاف سقوط أثناء التوقف';

  @override
  String get vehicleSwitchedOff => 'تم إيقاف تشغيل المركبة';

  @override
  String get vehicleSwitchedOn => 'تم تشغيل المركبة';

  @override
  String get powerSupplyOn => 'بدء مزود الطاقة';

  @override
  String get vibrationSensed => 'تم اكتشاف اهتزاز';

  @override
  String get editVehicle => 'تعديل المركبة';

  @override
  String get diesel => 'ديزل';

  @override
  String get cng => 'الغاز الطبيعي المضغوط';

  @override
  String get updateVehicle => 'تحديث المركبة';

  @override
  String get vehicleMileage => 'استهلاك المركبة';

  @override
  String get notificationControls => 'عناصر التحكم في الإشعارات';

  @override
  String get changeNotificationPreferences => 'تغيير تفضيلات الإشعارات';

  @override
  String get unmapTrackify => 'إلغاء ربط Trackify الخاص بك';

  @override
  String get unmapStep1 =>
      'الخطوة 1: لإلغاء ربط الجهاز، اتصل على +918061971443';

  @override
  String get unmapStep2 => 'الخطوة 2: إزالة المركبة';

  @override
  String get updateMileage => 'تحديث الاستهلاك';

  @override
  String get lastUpdated => 'آخر تحديث: ';

  @override
  String get lockUnlockVehicle => 'قفل وفتح السيارة';

  @override
  String get sleepModeWarning =>
      'لن يتم قفل / فتح قفل سيارتك إذا كان الجهاز في وضع السكون.';

  @override
  String get journeyWithTrackify => 'رحلة مع Trackify';

  @override
  String get lifetime => 'مدى الحياة';

  @override
  String hrMinFormat(Object hr, Object min) {
    return '$hr ساعة $min دقيقة';
  }

  @override
  String get yourVehicleOnMap => 'سيارتك على الخريطة';

  @override
  String get selectIcon => 'اختر الأيقونة';

  @override
  String get bike => 'دراجة';

  @override
  String get scooty => 'سكوتر';

  @override
  String get myVehicle => 'سيارتي';

  @override
  String get selectColor => 'اختر اللون';

  @override
  String get white => 'أبيض';

  @override
  String get red => 'أحمر';

  @override
  String get aqua => 'أكوا';

  @override
  String get orange => 'برتقالي';

  @override
  String get sky => 'سماوي';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get whatIsSleepMode => 'ما هو وضع السكون؟';

  @override
  String get sleepModeDesc1 =>
      'عندما لا يكتشف جهاز Trackify أي اهتزاز أو حركة ، فإنه يدخل تلقائيا في وضع السكون لتوفير بطارية السيارة.';

  @override
  String get sleepModeDesc2 =>
      'يستيقظ الجهاز على الفور ويبدأ في التتبع عندما يشعر بأي حركة ويكون في تغطية شبكة جيدة.';

  @override
  String get hr => 'ساعة';

  @override
  String get min => 'دقيقة';

  @override
  String get filters => 'تصفية';

  @override
  String get tankCapacityHint => 'مثال: 13';

  @override
  String get mileageHint => 'مثال: 50';

  @override
  String get powerSupplyOff => 'إيقاف مزود الطاقة';

  @override
  String get lastUpdatedLabel => 'آخر تحديث: ';

  @override
  String get litresShort => 'لتر';

  @override
  String get discoverTrackifyFeatures => 'اكتشف ميزات Trackify';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get address => 'العنوان';

  @override
  String get summary => 'الملخص';

  @override
  String get pleaseEnterDetails => 'يرجى إدخال التفاصيل أدناه';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get houseFloorLine => 'المنزل، الطابق، الخط';

  @override
  String get landmark => 'علامة مميزة';

  @override
  String get pinCode => 'الرمز البريدي';

  @override
  String get homeAddress => 'عنوان المنزل';

  @override
  String get officeAddress => 'عنوان المكتب';

  @override
  String get product => 'المنتجات';

  @override
  String get errorPickingImage => 'خطأ في اختيار الصورة';

  @override
  String get frontDocumentRequired => 'صورة المستند الأمامية مطلوبة';

  @override
  String get documentUploadedSuccessfully => 'تم رفع المستند بنجاح';

  @override
  String get addAccessoryBill => 'إضافة فاتورة ملحقات';

  @override
  String get accessoryName => 'اسم الملحق';

  @override
  String get billingDate => 'تاريخ الفاتورة';

  @override
  String get shopName => 'اسم المحل';

  @override
  String get shopContact => 'اتصال المحل';

  @override
  String get uploadBill => 'تحميل الفاتورة';

  @override
  String get yearExtendedWarranty => 'ضمان ممتد لمدة عام واحد';

  @override
  String get paymentSummary => 'ملخص الدفع';

  @override
  String get boosterOffer => 'عرض معزز بخصم 50%';

  @override
  String get toPay => 'المبلغ المطلوب';

  @override
  String amountPayable(String amount) {
    return 'المبلغ المستحق $amount';
  }

  @override
  String get distance => 'المسافة';

  @override
  String get recentToOldest => 'من الأحدث إلى الأقدم';

  @override
  String get sorting => 'فرز';

  @override
  String get backToDefault => 'العودة إلى الافتراضي';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get duration => 'المدة';

  @override
  String get oldestToRecent => 'من الأقدم إلى الأحدث';

  @override
  String get date => 'التاريخ';

  @override
  String noTripsFound(String query) {
    return 'لم يتم العثور على رحلات لـ \"$query\"';
  }

  @override
  String ridesCount(String count) {
    return '$count رحلات';
  }

  @override
  String get searchTrips => 'البحث عن الرحلات';

  @override
  String get searchRides => 'بحث في الرحلات';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get start => 'البداية';

  @override
  String get end => 'النهاية';

  @override
  String get yesImSure => 'نعم أنا متأكد';

  @override
  String get topSpeedLabel => 'السرعة القصوى';

  @override
  String get rideDurationLabel => 'مدة الرحلة';

  @override
  String get editRides => 'تعديل الرحلات';

  @override
  String get tripDetails => 'تفاصيل الرحلة';

  @override
  String get tripQuoteLabel => 'مقولة الرحلة';

  @override
  String get unmerge => 'فك الدمج';

  @override
  String get tripNameLabel => 'اسم الرحلة';

  @override
  String get deleteTripConfirmation =>
      'سيؤدي هذا إلى حذف رحلتك نهائيًا. هل أنت متأكد أنك تريد الاستمرار؟';

  @override
  String get tripStats => 'إحصائيات الرحلة';

  @override
  String get avgSpeedLabel => 'متوسط السرعة';

  @override
  String get tripQuoteDefault => 'كل رحلة لها قصة. قصتك تبدأ هنا.';

  @override
  String get deleteTrip => 'حذف الرحلة';

  @override
  String get hrLabel => 'ساعة';

  @override
  String ridesSelectedSummary(String count, String distance, String duration) {
    return 'تم اختيار $count رحلات | $distance كم • $duration';
  }

  @override
  String get clearSelection => 'مسح التحديد';

  @override
  String get secLabel => 'ثانية';

  @override
  String get minLabel => 'دقيقة';

  @override
  String get selectionTooltipMessage =>
      'اختر الرحلات التي تريد إضافتها إلى رحلتك.';

  @override
  String get selectRides => 'اختر الرحلات';

  @override
  String get createTrip => 'إنشاء رحلة';

  @override
  String get bestAverageSpeed => 'أفضل متوسط سرعة';

  @override
  String get topSpeedClocked => 'أعلى سرعة مسجلة';

  @override
  String get searchTripsHint => 'ابحث عن الرحلات بالاسم';

  @override
  String noRidesFound(String query) {
    return 'لم يتم العثور على رحلات لـ \"$query\"';
  }

  @override
  String tripLabel(String number) {
    return 'رحلة $number';
  }

  @override
  String get extraordinaryTrips => 'رحلات استثنائية';

  @override
  String get maxDistanceCovered => 'أقصى مسافة مقطوعة';

  @override
  String get searchRidesHint => 'ابحث عن الرحلات بالمدينة';

  @override
  String get healthInsurance => 'التأمين الصحي';

  @override
  String get bloodGroup => 'فصيلة الدم';

  @override
  String get selectBloodGroup => 'اختر فصيلة الدم';

  @override
  String get healthInsuranceCardNumber => 'رقم بطاقة التأمين الصحي';

  @override
  String get policyNumber => 'رقم الوثيقة';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get editEmailAddress => 'تعديل عنوان البريد الإلكتروني';

  @override
  String get emailAddress => 'عنوان البريد الإلكتروني';

  @override
  String get emailNotVerified => 'البريد الإلكتروني غير موثق';

  @override
  String get saveAndVerify => 'حفظ والتحقق';

  @override
  String get editMobileNumber => 'تعديل رقم الجوال';

  @override
  String get tenDigitMobileNumber => 'رقم جوال مكون من 10 أرقام';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get middleName => 'الاسم الأوسط';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get required => 'مطلوب';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get optional => '(اختياري)';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get selectState => 'اختر الولاية';

  @override
  String get selectCity => 'اختر المدينة';

  @override
  String get enterAddress => 'أدخل العنوان (100 حرف كحد أقصى)';

  @override
  String get india => 'الهند';

  @override
  String get usa => 'الولايات المتحدة';

  @override
  String get uk => 'المملكة المتحدة';

  @override
  String get uae => 'الإمارات';

  @override
  String get madhyaPradesh => 'ماديا براديش';

  @override
  String get maharashtra => 'ماهاراشترا';

  @override
  String get rajasthan => 'راجستان';

  @override
  String get gujarat => 'غوجارات';

  @override
  String get karnataka => 'كارناتاكا';

  @override
  String get tamilNadu => 'تاميل نادو';

  @override
  String get uttarPradesh => 'أوتار براديش';

  @override
  String get delhi => 'دلهي';

  @override
  String get indoreDistrict => 'منطقة إندور';

  @override
  String get bhopal => 'بوبال';

  @override
  String get gwalior => 'جواليور';

  @override
  String get jabalpur => 'جابالبور';

  @override
  String get ujjain => 'أوجاين';

  @override
  String get notificationSounds => 'أصوات الإشعارات';

  @override
  String get changeSoundForNotification => 'تغيير الصوت للإشعار المختلف';

  @override
  String get vibrationAlert => 'تنبيهات الاهتزاز';

  @override
  String get motionAlert => 'تنبيه الحركة';

  @override
  String get ignitionAlert => 'تنبيهات الإشعال';

  @override
  String get fallAlert => 'تنبيهات السقوط';

  @override
  String get batteryAlert => 'تنبيهات البطارية';

  @override
  String get geofenceAlert => 'تنبيهات السياج الجغرافي';

  @override
  String get speedAlert => 'تنبيهات السرعة';

  @override
  String get otherAlert => 'تنبيهات أخرى';

  @override
  String get customNotification => 'إشعارات مخصصة';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get selectedPlan => 'الخطة المحددة';

  @override
  String get validity => 'الصلاحية';

  @override
  String greatSaving(Object amount) {
    return 'رائع! وفرت ₹$amount مع هذه الخطة';
  }

  @override
  String get billSummary => 'ملخص الفاتورة';

  @override
  String get planPrice => 'سعر الخطة';

  @override
  String get discount => 'الخصم';

  @override
  String get total => 'الإجمالي';

  @override
  String get gstTaxes => 'ضريبة GST (الضرائب الحكومية)';

  @override
  String payAmount(Object amount) {
    return 'ادفع ₹$amount';
  }

  @override
  String get liveRecord => 'تسجيل مباشر';

  @override
  String get history => 'السجل';

  @override
  String get stats => 'الإحصائيات';

  @override
  String get lastReportedPosition => 'آخر موقع تم الإبلاغ عنه';

  @override
  String get time => 'الوقت';

  @override
  String get appUpdate => 'تحديث التطبيق';

  @override
  String get fuelStation => 'محطة الوقود';

  @override
  String get change => 'تغيير';

  @override
  String get currentOdometer => 'عداد المسافة الحالي (كم)';

  @override
  String get lastRecorded => 'آخر تسجيل: 32789 كم';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get pricePerLitre => 'السعر لكل لتر';

  @override
  String get tankStatus => 'حالة الخزان';

  @override
  String get fullTank => 'خزان ممتلئ';

  @override
  String get partialTank => 'خزان جزئي';

  @override
  String get fuelBeforeRefuel => 'الوقود قبل التعبئة';

  @override
  String get liters => 'لتر';

  @override
  String get fuelBeforeRefuelDesc =>
      'أدخل الكمية التقديرية للوقود الموجودة في الخزان قبل إعادة التعبئة.';

  @override
  String get savedSuccessfully => 'تم الحفظ بنجاح';

  @override
  String get fuelStationName => 'سي إم بترو بوينت، بي بي سي إل بتر...';

  @override
  String get yourPhoneLocation => 'موقع هاتفك';

  @override
  String get sharingActive => 'المشاركة نشطة';

  @override
  String get noActiveSharing => 'لا توجد مشاركة نشطة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightTheme => 'السمة الفاتحة';

  @override
  String get switchBetweenLightAndDarkThemes =>
      'التبديل بين السمات الفاتحة والداكنة';
}
