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
  String get letsGetStarted => 'لنبدأ الآن';

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
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صحيح';

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
  String get nameHint => 'John Doe';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get mobileNumberHint => 'أدخل رقم الجوال';

  @override
  String get mobileNumberRequired => 'رقم الجوال مطلوب';

  @override
  String get invalidMobileNumber => 'يرجى إدخال رقم جوال صحيح';

  @override
  String get country => 'الدولة';

  @override
  String get countryHint => 'أدخل الدولة';

  @override
  String get countryRequired => 'الدولة مطلوبة';

  @override
  String get state => 'المنطقة';

  @override
  String get stateHint => 'أدخل المنطقة';

  @override
  String get stateRequired => 'المنطقة مطلوبة';

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
  String get roleAdmin => 'مدير';

  @override
  String get roleCustomer => 'عميل';

  @override
  String get selectRoleHint => 'اختر دوراً';

  @override
  String get roleRequired => 'يرجى اختيار دور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSuccess => 'تم تسجيل المستخدم بنجاح ، يرجى تسجيل الدخول';

  @override
  String get signUpFailed => 'فشل إنشاء الحساب';

  @override
  String get otpSent => 'تم إرسال الرمز بنجاح';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordDesc =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get sendResetLink => 'إرسال رابط الإعادة';

  @override
  String get otpVerified => 'تم التحقق من الرمز بنجاح';

  @override
  String get verifyOtp => 'التحقق من الرمز';

  @override
  String get otpHeader => 'التحقق من الرمز';

  @override
  String otpDesc(String email) {
    return 'أدخل الرمز المرسل إلى $email.';
  }

  @override
  String get otp => 'الرمز';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'الرمز مطلوب';

  @override
  String get passwordResetSuccess => 'تمت إعادة تعيين كلمة المرور بنجاح';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get passwordDesc =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمات المرور السابقة.';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get newPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور الجديدة';

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
  String get goToDashboard => 'الذهاب إلى لوحة التحكم';

  @override
  String get seeFullMap => 'مشاهدة الخريطة الكاملة';

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
  String get remoteEngineOff => 'إطفاء المحرك عن بعد';

  @override
  String get networkBooster => 'معزز الشبكة';

  @override
  String get emergency => 'الطوارئ';

  @override
  String get overspeedAlert => 'تنبيه السرعة الزائدة';

  @override
  String get geoFenceAlert => 'تنبيه السياج الجغرافي';

  @override
  String get more => 'المزيد';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get bikeSmartMsg => 'أكثر من 1000 شخص جعلوا دراجاتهم ذكية بجهازنا';

  @override
  String get features => 'الميزات';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get contactUsDesc => 'هل لديك أسئلة؟ نحن هنا للمساعدة.';

  @override
  String get userReviews => 'آراء المستخدمين';

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
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'تتبع متقدم بميزات قصوى';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'تتبع قياسي للاستخدام اليومي';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'جهاز تحديد مواقع أساسي';

  @override
  String get realTime1s => 'تتبع فوري (ثانية واحدة)';

  @override
  String get remoteEngineCutOff => 'قطع المحرك عن بعد';

  @override
  String get detailedFuelAnalytics => 'تحليلات وقود مفصلة';

  @override
  String get realTime5s => 'تتبع فوري (5 ثوانٍ)';

  @override
  String get antiTheftAlerts => 'تنبيهات ضد السرقة';

  @override
  String get basicJourneyLogs => 'سجلات رحلات أساسية';

  @override
  String get locationUpdates => 'تحديثات الموقع';

  @override
  String get batteryMonitor => 'مراقب البطارية';

  @override
  String get featuresLabel => 'الميزات:';

  @override
  String addedToCart(String title) {
    return 'تمت إضافة $title إلى العربة!';
  }

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String errorMsg(String message) {
    return 'خطأ: $message';
  }

  @override
  String get addVehicle => 'إضافة مركبة/جهاز';

  @override
  String get vehicleAdded => 'تمت إضافة المركبة بنجاح!';

  @override
  String get vehicleType => 'نوع المركبة';

  @override
  String get twoWheeler => 'ثنائي العجلات';

  @override
  String get fourWheeler => 'رباعي العجلات';

  @override
  String get autoRickshaw => 'ريكشا';

  @override
  String get heavyVehicle => 'مركبة ثقيلة';

  @override
  String get fuelType => 'نوع الوقود';

  @override
  String get petrol => 'بنزين';

  @override
  String get electric => 'كهربائي';

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
  String get selectMake => 'اختر ماركة المركبة';

  @override
  String get selectModel => 'اختر موديل المركبة';

  @override
  String get installDevice => 'تثبيت جهاز Trackify';

  @override
  String get installDeviceDesc =>
      'قم بإعداد جهاز Ajjas الذكي الخاص بك بسرعة بخطوات بسيطة';

  @override
  String get activateSticker => 'تفعيل ملصق الاتصال';

  @override
  String get activateStickerDesc => 'خطوات بسيطة لتفعيل ملصق الاتصال بسرعة';

  @override
  String get exploreFreeApp => 'استكشف تطبيقنا المجاني';

  @override
  String get exploreFreeAppDesc =>
      'سجّل رحلاتك يدوياً باستخدام الهاتف وتتبعها باستخدام تطبيقنا المجاني';

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
    return 'تنتهي خلال $days يوم';
  }

  @override
  String get rechargeNow => 'اشحن الآن';

  @override
  String get renewNow => 'جدد الآن';

  @override
  String get secureYourVehicle => 'أمن مركبتك';

  @override
  String get secureYourVehicleDesc =>
      'اشترِ جهاز أجياس الآن للتتبع الفوري وراحة البال التامة.';

  @override
  String get boughtDeviceInstallNow => 'هل اشتريت جهازاً؟ ';

  @override
  String get installNow => 'ثبته الآن';

  @override
  String get buyAjjasDevice => 'اشترِ جهاز أجياس';

  @override
  String get lite4G => 'لايت 4G';

  @override
  String get swipeToLock => 'اسحب للقفل';

  @override
  String get upgradeToPlus => 'ترقية إلى Ajjas Plus';

  @override
  String get getMoreOutOfAjjas => 'استفد أكثر من Ajjas';

  @override
  String featuresExploredCount(Object count, Object total) {
    return 'لقد استكشفت $count من $total ميزات - واصل!';
  }

  @override
  String get manageVehiclesDesc => 'إدارة جميع مركباتك هنا';

  @override
  String get settingsDesc => 'اللغة وإعدادات الحساب والمزيد';

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
  String get helpAndSupportDesc => 'احصل على المساعدة والأسئلة الشائعة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get searchForSettings => 'البحث في الإعدادات';

  @override
  String get backupAndRestore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupAndRestoreDesc =>
      'احتفظ بنسخة احتياطية من بيانات رحلاتك واستعدها في أي وقت.';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get appSettingsDesc => 'مظهر التطبيق وخريطة الحرارة وميزة الطوارئ';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notificationSettingsDesc => 'تفضيلات الإشعارات وصوت الإشعار';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacyDesc =>
      'تغيير كلمة المرور وإدارة الجلسة الحالية وحذف حسابك';

  @override
  String get rateUsOnPlayStore => 'قيّمنا على Play Store';

  @override
  String get rateUsOnPlayStoreDesc => 'شارك ملاحظاتك القيمة';

  @override
  String get logoutDesc => 'تسجيل الخروج من هذا الجهاز';

  @override
  String get helpAndSuggestion => 'المساعدة والاقتراح';

  @override
  String get reportAnIssue => 'الإبلاغ عن مشكلة';

  @override
  String get suggestion => 'اقتراح';

  @override
  String get whatIsYourIssueRelatedTo => 'بماذا تتعلق مشكلتك؟';

  @override
  String get shortDescriptionHint => 'أعطنا وصفاً مختصراً (200 حرف كحد أقصى)';

  @override
  String get selectCallSlot => 'اختر وقت الاتصال';

  @override
  String get myIssues => 'مشاكلي';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String get forceMigrate => 'ترحيل قسري';

  @override
  String get forceMigrateDesc1 =>
      'استخدم هذا الخيار لإصلاح رحلات يومية محفوظة فاتت أثناء تحديث التطبيق.';

  @override
  String get forceMigrateDesc2 =>
      'يرجى ملاحظة أن هذا لا يستعيد رحلاتك القديمة من الخادم. يقوم فقط بنقل البيانات في التخزين المحلي إلى التنسيق الجديد.';

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
      'يبدو أن مركبتك استمتعت بإجازة قصيرة، حيث أنك لم تقم بأي رحلة خلال الفترة الزمنية المحددة';

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
  String get vehicleMakeListEmpty =>
      'قائمة ماركات المركبات فارغة لهذا الاختيار';

  @override
  String get vehicleModelListEmpty =>
      'قائمة موديلات المركبات فارغة لهذا الاختيار';

  @override
  String get deviceInstallation => 'تثبيت الجهاز';

  @override
  String get scanActivationCode => 'مسح رمز التفعيل';

  @override
  String get enterActivationCodeManually => 'إدخال رمز التفعيل يدوياً';

  @override
  String get openAjjasBoxInstruction =>
      'افتح صندوق Ajjas للحصول على رمز QR للتفعيل.';

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
  String get deviceAssignedSuccess => 'تم تخصيص الجهاز للمركبة بنجاح!';

  @override
  String get assigningDevice => 'جاري تخصيص الجهاز...';

  @override
  String get invalidImeiError => 'يرجى إدخال رقم IMEI صالِح مكون من 15 رقماً';

  @override
  String get sharedRides => 'الرحلات المشتركة';

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
  String get getMoreOutOfTrackify => 'احصل على المزيد مع Trackify';

  @override
  String get discoverMoreDesc => 'اكتشف المزيد — أشياء رائعة في انتظارك!';

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
  String get videoTutorials => 'دروس الفيديو';

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
    return 'بقي $value كم للوصول';
  }

  @override
  String get buyTrackifyDevice => 'شراء جهاز Trackify';

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
  String get fuelEmpty => 'ف';

  @override
  String get fuelFull => 'م';

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
  String get addProfilePicture => 'أضف صورتك الشخصية';

  @override
  String get personalDetails => 'التفاصيل الشخصية';

  @override
  String get userNameLabel => 'الاسم';

  @override
  String get emailAddressLabel => 'البريد الإلكتروني';

  @override
  String get mobileNumberLabel => 'رقم الهاتف المحمول';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get stateLabel => 'الولاية/المقاطعة';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get medicalInsuranceInfo => 'معلومات التأمين الطبي';

  @override
  String get addMedicalInsuranceInfo => 'إضافة معلومات التأمين الطبي';

  @override
  String get vehicleInsuranceInfo => 'معلومات تأمين المركبة';

  @override
  String get editViewVehicleInsuranceDesc =>
      'تعديل وعرض تفاصيل تأمين مركبتك في إعدادات المركبة.';

  @override
  String get myGarageVehiclePath => 'كراجي > مركبة';

  @override
  String get emergencyContacts => 'جهات اتصال الطوارئ';

  @override
  String get addEditEmergencyContactDesc =>
      'إضافة وتعديل قائمة جهات اتصال الطوارئ في إعدادات المركبة.';

  @override
  String get smartContactSticker => 'ملصق جهة اتصال ذكي';

  @override
  String get stickerSubtitle => 'خطوة للأمام لجعل مركبتك آمنة وذكية';

  @override
  String get activateContactSticker => 'تفعيل ملصق الاتصال';

  @override
  String get buyNewContactSticker => 'شراء ملصق اتصال جديد';

  @override
  String get beyondParkingProblems => 'ما وراء مشاكل وقوف السيارات';

  @override
  String get noParkings => 'ممنوع الوقوف';

  @override
  String get emergencies => 'حالات الطوارئ';

  @override
  String get vehicleTowing => 'سحب المركبات';

  @override
  String get getInformedStayConnected => 'ابق على اطلاع\nوعلى اتصال بمركبتك';

  @override
  String get securedCalls => 'مكالمات آمنة';

  @override
  String get securedCallsDesc =>
      'مكالمات مقنعة عبر الإنترنت - تحافظ على خصوصية رقم هاتفك.';

  @override
  String get notificationHistory => 'سجل التنبيهات';

  @override
  String get notificationHistoryDesc => 'تتبع جميع التنبيهات الحالية والسابقة';

  @override
  String get beInformed => 'كن على علم';

  @override
  String get beInformedDesc =>
      'اعرف فوراً عندما يقوم شخص ما بمسح رمز QR الخاص بك واتخذ إجراءات فورية عندما يتصلون بك.';

  @override
  String get controlWhatOthersSee => 'التحكم فيما يراه الآخرون';

  @override
  String get controlWhatOthersSeeDesc =>
      'تخصيص التفاصيل المعروضة عندما يقوم شخص ما بمسح رمز QR.';

  @override
  String get preventFrustrationDamage => 'منع الإحباط والضرر';

  @override
  String get preventFrustrationDamageDesc =>
      'تجنب النزاعات وتلف المركبات الناتج عن وقوف السيارات غير الصحيح.';

  @override
  String get serviceLogsSubtitle =>
      'لا تفوت خدمة المركبة أبدًا. احصل على تذكيرات وتتبع النفقات للحفاظ على سيارتك في أفضل حالة.';

  @override
  String get addServiceLogs => 'إضافة سجلات الخدمة';

  @override
  String get uploadServicingBill => 'تحميل فاتورة الخدمة';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get maxFileSizeNote => 'ملاحظة: الحد الأقصى لحجم الملف هو 5 ميغابايت';

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
  String get selectVehicle => 'حدد المركبة';

  @override
  String get liveTab => 'مباشر';

  @override
  String get historyTab => 'السجل';

  @override
  String get liveLocationSharingActive => 'مشاركة الموقع المباشر نشطة';

  @override
  String get noLiveLocationShared => 'لم يتم مشاركة موقع مباشر';

  @override
  String get realTimeSharingDesc =>
      'تتم مشاركة موقعك في الوقت الفعلي مع جهات اتصال مختارة.';

  @override
  String get startSharingPhoneDesc =>
      'ابدأ بمشاركة موقع هاتفك لمساعدة الآخرين على تتبعك';

  @override
  String get noHistoryAvailable => 'لا يوجد سجل متاح';

  @override
  String get historyDesc => 'ستظهر مشاركات الموقع السابقة هنا بمجرد اكتمالها.';

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
  String get safetyScore => 'درجة السلامة';

  @override
  String get speedAlertInput => 'Speed alert input';

  @override
  String get alertTitle => 'Alert title';

  @override
  String get speedLimitKmH => 'Speed limit (km/h)';

  @override
  String get timeDurationSec => 'Time Duration (sec)';

  @override
  String get selectYourVehicle => 'Select your vehicle';

  @override
  String get submit => 'Submit';

  @override
  String get selectVehiclesOverspeedAlert =>
      'Select vehicles on which to add overspeed alert';

  @override
  String get selected => 'Selected';

  @override
  String get sec => 'sec';

  @override
  String get kmHr => 'km/hr';

  @override
  String get viewMore => 'عرض المزيد';

  @override
  String get viewLess => 'عرض أقل';

  @override
  String get previousRides => 'الرحلات السابقة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get videosYouMightLike => 'فيديوهات قد تعجبك';

  @override
  String get scrollToTop => 'العودة إلى الأعلى';

  @override
  String get noRecentRidesFound => 'لم يتم العثور على رحلات حديثة';

  @override
  String get failedToLoadRides => 'فشل في تحميل الرحلات';

  @override
  String get hrMin => 'ساعة:دقيقة';

  @override
  String get vehicleLabel => 'المركبة';

  @override
  String get switchLabel => 'تبديل';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get rechargePlans => 'خطط إعادة الشحن';

  @override
  String get superComboPlan => 'الخطة الشاملة المميزة';

  @override
  String get month12Validity => 'صلاحية 12 شهرًا';

  @override
  String get month6Validity => 'صلاحية 6 أشهر';

  @override
  String saveAmount(Object amount) {
    return 'وفر ₹$amount مع هذه الخطة';
  }

  @override
  String get superComboPopularity => '95٪ من المستخدمين يختارون الخطة الشاملة';

  @override
  String get appSimRecharge => 'إعادة شحن التطبيق وSIM';

  @override
  String get extendedWarranty => 'ضمان ممتد';

  @override
  String get plusMembership => 'عضوية بلس';

  @override
  String get continueSuperCombo => 'المتابعة مع الخطة الشاملة';

  @override
  String get continue12Month => 'المتابعة مع خطة 12 شهرًا';

  @override
  String get continue6Month => 'المتابعة مع خطة 6 أشهر';

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
  String get gotIt => 'Got it';

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
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get updateMileageArai => 'Update Mileage (ARAI)';

  @override
  String get mileageDesc =>
      'Enter the mileage of your vehicle as per ARAI standards';

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
  String get warranty_title => 'Device Warranty';

  @override
  String get warranty_benefitsTitle => 'Warranty Benefits';

  @override
  String get warranty_extend =>
      'Extend Your Warranty & Keep Your Device Protected';

  @override
  String get warranty_vehicle => 'Vehicle';

  @override
  String get warranty_expiry => 'Warranty Expiry';

  @override
  String get warranty_button => 'Extend Warranty — ';

  @override
  String get warranty_button_old => '₹4,999';

  @override
  String get benefit1_highlight => 'Premium Coverage ';

  @override
  String get benefit1_normal =>
      '— Full hardware protection against manufacturing defects.';

  @override
  String get benefit2_highlight => 'Free Repairs ';

  @override
  String get benefit2_normal => '— All service & parts covered at zero cost.';

  @override
  String get benefit3_highlight => '24/7 Support ';

  @override
  String get benefit3_normal =>
      '— Priority customer support whenever you need it.';

  @override
  String get benefit4_highlight => 'No Hidden Charges ';

  @override
  String get benefit4_normal => '— One flat fee, complete peace of mind.';
}
