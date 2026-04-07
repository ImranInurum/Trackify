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
  String get invalidEmail => 'Please enter a valid email address';

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
  String get role => 'الدور';

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
}
