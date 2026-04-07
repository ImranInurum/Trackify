import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('ta'),
  ];

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectLanguage;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get letsGetStarted;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@test.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'******'**
  String get passwordHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email required'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get passwordRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome {email}!'**
  String welcome(String email);

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @roleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get roleRequired;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'User Registered Successfully Please Login'**
  String get registerSuccess;

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get signUpFailed;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSent;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @otpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpVerified;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpHeader.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpHeader;

  /// No description provided for @otpDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to {email}.'**
  String otpDesc(String email);

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get otpHint;

  /// No description provided for @otpRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get otpRequired;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @passwordDesc.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previous used passwords.'**
  String get passwordDesc;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get newPasswordHint;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @selectDevice.
  ///
  /// In en, this message translates to:
  /// **'Select Device'**
  String get selectDevice;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found.'**
  String get noDevicesFound;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown Device'**
  String get unknownDevice;

  /// No description provided for @imeiLabel.
  ///
  /// In en, this message translates to:
  /// **'IMEI: {imei}'**
  String imeiLabel(String imei);

  /// No description provided for @initializeFetch.
  ///
  /// In en, this message translates to:
  /// **'Initialize to fetch devices.'**
  String get initializeFetch;

  /// No description provided for @recordRide.
  ///
  /// In en, this message translates to:
  /// **'Record Ride'**
  String get recordRide;

  /// No description provided for @phoneAsGps.
  ///
  /// In en, this message translates to:
  /// **'Make your phone a GPS Tracking device'**
  String get phoneAsGps;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @seeFullMap.
  ///
  /// In en, this message translates to:
  /// **'See full map'**
  String get seeFullMap;

  /// No description provided for @exploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get exploreMore;

  /// No description provided for @reachMeSticker.
  ///
  /// In en, this message translates to:
  /// **'ReachMe Sticker'**
  String get reachMeSticker;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @fuelLogs.
  ///
  /// In en, this message translates to:
  /// **'Fuel Logs'**
  String get fuelLogs;

  /// No description provided for @locationSharing.
  ///
  /// In en, this message translates to:
  /// **'Location Sharing'**
  String get locationSharing;

  /// No description provided for @documentFolder.
  ///
  /// In en, this message translates to:
  /// **'Document Folder'**
  String get documentFolder;

  /// No description provided for @voiceMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Voice Monitoring'**
  String get voiceMonitoring;

  /// No description provided for @remoteEngineOff.
  ///
  /// In en, this message translates to:
  /// **'Remote Engine OFF'**
  String get remoteEngineOff;

  /// No description provided for @networkBooster.
  ///
  /// In en, this message translates to:
  /// **'Network Booster'**
  String get networkBooster;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @overspeedAlert.
  ///
  /// In en, this message translates to:
  /// **'Overspeed Alert'**
  String get overspeedAlert;

  /// No description provided for @geoFenceAlert.
  ///
  /// In en, this message translates to:
  /// **'Geo-fence Alert'**
  String get geoFenceAlert;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @bikeSmartMsg.
  ///
  /// In en, this message translates to:
  /// **'1000+ people made their bike smart with our device'**
  String get bikeSmartMsg;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contactUsDesc.
  ///
  /// In en, this message translates to:
  /// **'Got questions? We are here to help.'**
  String get contactUsDesc;

  /// No description provided for @userReviews.
  ///
  /// In en, this message translates to:
  /// **'User Reviews'**
  String get userReviews;

  /// No description provided for @accidentAlert.
  ///
  /// In en, this message translates to:
  /// **'Accident Alert'**
  String get accidentAlert;

  /// No description provided for @antiTheftAlert.
  ///
  /// In en, this message translates to:
  /// **'Anti-Theft Alert'**
  String get antiTheftAlert;

  /// No description provided for @geoFence.
  ///
  /// In en, this message translates to:
  /// **'Geo Fence'**
  String get geoFence;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @myGarage.
  ///
  /// In en, this message translates to:
  /// **'My Garage'**
  String get myGarage;

  /// No description provided for @noVehiclesInGarage.
  ///
  /// In en, this message translates to:
  /// **'No vehicles found in your garage.'**
  String get noVehiclesInGarage;

  /// No description provided for @unknownVehicle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Vehicle'**
  String get unknownVehicle;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get proPlan;

  /// No description provided for @initializeGarage.
  ///
  /// In en, this message translates to:
  /// **'Initialize to fetch your garage.'**
  String get initializeGarage;

  /// No description provided for @ourProducts.
  ///
  /// In en, this message translates to:
  /// **'Our Products'**
  String get ourProducts;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Trackify Pro'**
  String get proTitle;

  /// No description provided for @proSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced tracking with max features'**
  String get proSubtitle;

  /// No description provided for @goTitle.
  ///
  /// In en, this message translates to:
  /// **'Trackify Go'**
  String get goTitle;

  /// No description provided for @goSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Standard tracking for everyday use'**
  String get goSubtitle;

  /// No description provided for @liteTitle.
  ///
  /// In en, this message translates to:
  /// **'Trackify Lite'**
  String get liteTitle;

  /// No description provided for @liteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic locator device'**
  String get liteSubtitle;

  /// No description provided for @realTime1s.
  ///
  /// In en, this message translates to:
  /// **'Real-time 1s tracking'**
  String get realTime1s;

  /// No description provided for @remoteEngineCutOff.
  ///
  /// In en, this message translates to:
  /// **'Remote engine cut-off'**
  String get remoteEngineCutOff;

  /// No description provided for @detailedFuelAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Fuel Analytics'**
  String get detailedFuelAnalytics;

  /// No description provided for @realTime5s.
  ///
  /// In en, this message translates to:
  /// **'Real-time 5s tracking'**
  String get realTime5s;

  /// No description provided for @antiTheftAlerts.
  ///
  /// In en, this message translates to:
  /// **'Anti-theft alerts'**
  String get antiTheftAlerts;

  /// No description provided for @basicJourneyLogs.
  ///
  /// In en, this message translates to:
  /// **'Basic journey logs'**
  String get basicJourneyLogs;

  /// No description provided for @locationUpdates.
  ///
  /// In en, this message translates to:
  /// **'Location updates'**
  String get locationUpdates;

  /// No description provided for @batteryMonitor.
  ///
  /// In en, this message translates to:
  /// **'Battery monitor'**
  String get batteryMonitor;

  /// No description provided for @featuresLabel.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get featuresLabel;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added {title} to cart!'**
  String addedToCart(String title);

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorMsg.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorMsg(String message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'hi',
    'kn',
    'mr',
    'ta',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
