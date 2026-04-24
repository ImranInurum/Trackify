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

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get mobileNumberHint;

  /// No description provided for @mobileNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get mobileNumberRequired;

  /// No description provided for @invalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get invalidMobileNumber;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @countryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter country'**
  String get countryHint;

  /// No description provided for @countryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get countryRequired;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @stateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter state'**
  String get stateHint;

  /// No description provided for @stateRequired.
  ///
  /// In en, this message translates to:
  /// **'State is required'**
  String get stateRequired;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get cityHint;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityRequired;

  /// No description provided for @selectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Image'**
  String get selectProfileImage;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// No description provided for @selectRoleHint.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRoleHint;

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

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle/Device'**
  String get addVehicle;

  /// No description provided for @vehicleAdded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully!'**
  String get vehicleAdded;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @twoWheeler.
  ///
  /// In en, this message translates to:
  /// **'Two Wheeler'**
  String get twoWheeler;

  /// No description provided for @fourWheeler.
  ///
  /// In en, this message translates to:
  /// **'Four Wheeler'**
  String get fourWheeler;

  /// No description provided for @autoRickshaw.
  ///
  /// In en, this message translates to:
  /// **'Auto Rickshaw'**
  String get autoRickshaw;

  /// No description provided for @heavyVehicle.
  ///
  /// In en, this message translates to:
  /// **'Heavy Vehicle'**
  String get heavyVehicle;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @petrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get petrol;

  /// No description provided for @electric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electric;

  /// No description provided for @vehicleMake.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Make'**
  String get vehicleMake;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @vehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number'**
  String get vehicleNumber;

  /// No description provided for @vehicleNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. MP46MX0743'**
  String get vehicleNumberHint;

  /// No description provided for @pleaseEnterVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle number'**
  String get pleaseEnterVehicleNumber;

  /// No description provided for @selectMake.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Make'**
  String get selectMake;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Model'**
  String get selectModel;

  /// No description provided for @installDevice.
  ///
  /// In en, this message translates to:
  /// **'Install Trackify Device'**
  String get installDevice;

  /// No description provided for @installDeviceDesc.
  ///
  /// In en, this message translates to:
  /// **'Quickly set up your Ajjas smart device with simple steps'**
  String get installDeviceDesc;

  /// No description provided for @activateSticker.
  ///
  /// In en, this message translates to:
  /// **'Activate Contact Sticker'**
  String get activateSticker;

  /// No description provided for @activateStickerDesc.
  ///
  /// In en, this message translates to:
  /// **'Simple steps to quickly activate your contact sticker'**
  String get activateStickerDesc;

  /// No description provided for @exploreFreeApp.
  ///
  /// In en, this message translates to:
  /// **'Explore Our Free App'**
  String get exploreFreeApp;

  /// No description provided for @exploreFreeAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Record rides using phone manually & keep track of it using our free app curated for you'**
  String get exploreFreeAppDesc;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dataPlan.
  ///
  /// In en, this message translates to:
  /// **'Data Plan'**
  String get dataPlan;

  /// No description provided for @warranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warranty;

  /// No description provided for @expiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days} days'**
  String expiresInDays(String days);

  /// No description provided for @rechargeNow.
  ///
  /// In en, this message translates to:
  /// **'Recharge Now'**
  String get rechargeNow;

  /// No description provided for @renewNow.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get renewNow;

  /// No description provided for @secureYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Vehicle'**
  String get secureYourVehicle;

  /// No description provided for @secureYourVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'Buy Ajjas device now for real-time tracking and complete peace of mind.'**
  String get secureYourVehicleDesc;

  /// No description provided for @boughtDeviceInstallNow.
  ///
  /// In en, this message translates to:
  /// **'Bought a device? '**
  String get boughtDeviceInstallNow;

  /// No description provided for @installNow.
  ///
  /// In en, this message translates to:
  /// **'Install now'**
  String get installNow;

  /// No description provided for @buyAjjasDevice.
  ///
  /// In en, this message translates to:
  /// **'Buy Ajjas Device'**
  String get buyAjjasDevice;

  /// No description provided for @lite4G.
  ///
  /// In en, this message translates to:
  /// **'Lite 4G'**
  String get lite4G;

  /// No description provided for @swipeToLock.
  ///
  /// In en, this message translates to:
  /// **'SWIPE TO LOCK'**
  String get swipeToLock;

  /// No description provided for @upgradeToPlus.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Ajjas Plus'**
  String get upgradeToPlus;

  /// No description provided for @getMoreOutOfAjjas.
  ///
  /// In en, this message translates to:
  /// **'Get more out of Ajjas'**
  String get getMoreOutOfAjjas;

  /// No description provided for @featuresExploredCount.
  ///
  /// In en, this message translates to:
  /// **'You\'ve explored {count} of {total} features - keep going!'**
  String featuresExploredCount(Object count, Object total);

  /// No description provided for @manageVehiclesDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage all your Vehicles here'**
  String get manageVehiclesDesc;

  /// No description provided for @settingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Language, Account Settings & more'**
  String get settingsDesc;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications found'**
  String get noNotifications;

  /// No description provided for @notificationsFetchedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Notifications fetched successfully'**
  String get notificationsFetchedSuccessfully;

  /// No description provided for @errorFetchingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error fetching notifications'**
  String get errorFetchingNotifications;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpAndSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Get assistance and FAQs'**
  String get helpAndSupportDesc;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchForSettings.
  ///
  /// In en, this message translates to:
  /// **'Search for settings'**
  String get searchForSettings;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// No description provided for @backupAndRestoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Back up your rides data and restore them anytime.'**
  String get backupAndRestoreDesc;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @appSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'App Theme, Ride Heatmap and Emergency Feature'**
  String get appSettingsDesc;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notificationSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Notification preference & Notification sound'**
  String get notificationSettingsDesc;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Change password, manage current session, delete your account'**
  String get privacyDesc;

  /// No description provided for @rateUsOnPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Rate us on Play Store'**
  String get rateUsOnPlayStore;

  /// No description provided for @rateUsOnPlayStoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your valuable feedback'**
  String get rateUsOnPlayStoreDesc;

  /// No description provided for @logoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Logout from this device'**
  String get logoutDesc;

  /// No description provided for @helpAndSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Help & Suggestion'**
  String get helpAndSuggestion;

  /// No description provided for @reportAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get reportAnIssue;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @whatIsYourIssueRelatedTo.
  ///
  /// In en, this message translates to:
  /// **'What is your issue related to ?'**
  String get whatIsYourIssueRelatedTo;

  /// No description provided for @shortDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Give us a short description (max 200 characters)'**
  String get shortDescriptionHint;

  /// No description provided for @selectCallSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Call Slot'**
  String get selectCallSlot;

  /// No description provided for @myIssues.
  ///
  /// In en, this message translates to:
  /// **'My Issues'**
  String get myIssues;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @forceMigrate.
  ///
  /// In en, this message translates to:
  /// **'Force Migrate'**
  String get forceMigrate;

  /// No description provided for @forceMigrateDesc1.
  ///
  /// In en, this message translates to:
  /// **'Use this option to fix backed up daily rides missed during app update.'**
  String get forceMigrateDesc1;

  /// No description provided for @forceMigrateDesc2.
  ///
  /// In en, this message translates to:
  /// **'Please note, this does not bring back your old rides from the server. It only migrates data in your local storage to the new data format for you to view it.'**
  String get forceMigrateDesc2;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @changeLog.
  ///
  /// In en, this message translates to:
  /// **'Change log'**
  String get changeLog;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'(Today)'**
  String get todayLabel;

  /// No description provided for @ridingBehaviour.
  ///
  /// In en, this message translates to:
  /// **'Riding Behaviour'**
  String get ridingBehaviour;

  /// No description provided for @ridingBehaviourVacationDesc.
  ///
  /// In en, this message translates to:
  /// **'Looks like your vehicle enjoyed a little vacation, as you didn\'t take any ride during the selected time period'**
  String get ridingBehaviourVacationDesc;

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get journey;

  /// No description provided for @distanceTravelled.
  ///
  /// In en, this message translates to:
  /// **'Distance Travelled'**
  String get distanceTravelled;

  /// No description provided for @timeDuration.
  ///
  /// In en, this message translates to:
  /// **'Time Duration'**
  String get timeDuration;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @averageSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average Speed'**
  String get averageSpeed;

  /// No description provided for @topSpeed.
  ///
  /// In en, this message translates to:
  /// **'Top Speed'**
  String get topSpeed;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @fuelConsumed.
  ///
  /// In en, this message translates to:
  /// **'Fuel Consumed'**
  String get fuelConsumed;

  /// No description provided for @fuelCost.
  ///
  /// In en, this message translates to:
  /// **'Fuel Cost'**
  String get fuelCost;

  /// No description provided for @vsPreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'{value}% vs previous period'**
  String vsPreviousPeriod(String value);

  /// No description provided for @vehicleMakeListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Vehicle make list is empty for this selection'**
  String get vehicleMakeListEmpty;

  /// No description provided for @vehicleModelListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Vehicle model list is empty for this selection'**
  String get vehicleModelListEmpty;

  /// No description provided for @deviceInstallation.
  ///
  /// In en, this message translates to:
  /// **'Device Installation'**
  String get deviceInstallation;

  /// No description provided for @scanActivationCode.
  ///
  /// In en, this message translates to:
  /// **'Scan activation code'**
  String get scanActivationCode;

  /// No description provided for @enterActivationCodeManually.
  ///
  /// In en, this message translates to:
  /// **'Enter activation code manually'**
  String get enterActivationCodeManually;

  /// No description provided for @openAjjasBoxInstruction.
  ///
  /// In en, this message translates to:
  /// **'Open Ajjas box for the activation QR code.'**
  String get openAjjasBoxInstruction;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @enterUID.
  ///
  /// In en, this message translates to:
  /// **'Enter UID'**
  String get enterUID;

  /// No description provided for @enterIMEINumber.
  ///
  /// In en, this message translates to:
  /// **'Enter IMEI number'**
  String get enterIMEINumber;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @uidRequired.
  ///
  /// In en, this message translates to:
  /// **'UID is required'**
  String get uidRequired;

  /// No description provided for @imeiRequired.
  ///
  /// In en, this message translates to:
  /// **'IMEI number is required'**
  String get imeiRequired;

  /// No description provided for @deviceAssignedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device successfully assigned to vehicle!'**
  String get deviceAssignedSuccess;

  /// No description provided for @assigningDevice.
  ///
  /// In en, this message translates to:
  /// **'Assigning device...'**
  String get assigningDevice;

  /// No description provided for @invalidImeiError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 15-digit IMEI number'**
  String get invalidImeiError;

  /// No description provided for @sharedRides.
  ///
  /// In en, this message translates to:
  /// **'Shared Rides'**
  String get sharedRides;

  /// No description provided for @savedRides.
  ///
  /// In en, this message translates to:
  /// **'Saved Rides'**
  String get savedRides;

  /// No description provided for @allRides.
  ///
  /// In en, this message translates to:
  /// **'ALL RIDES'**
  String get allRides;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'TRIPS'**
  String get trips;

  /// No description provided for @clicked.
  ///
  /// In en, this message translates to:
  /// **'{value} Clicked'**
  String clicked(String value);

  /// No description provided for @noDailyRides.
  ///
  /// In en, this message translates to:
  /// **'No daily rides to show'**
  String get noDailyRides;

  /// No description provided for @getStartedFirstRide.
  ///
  /// In en, this message translates to:
  /// **'Get started by taking your first ride'**
  String get getStartedFirstRide;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @kmh.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmh;

  /// No description provided for @tripEmptyQuote.
  ///
  /// In en, this message translates to:
  /// **'“Group your rides into trips, add memories, and relive the journey”'**
  String get tripEmptyQuote;

  /// No description provided for @ridesCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'Rides completed: {completed}/{total}'**
  String ridesCompletedCount(String completed, String total);

  /// No description provided for @unlockTripsRequirement.
  ///
  /// In en, this message translates to:
  /// **'You need at least 3 rides to unlock trips'**
  String get unlockTripsRequirement;

  /// No description provided for @createNewTrip.
  ///
  /// In en, this message translates to:
  /// **'Create a New Trip'**
  String get createNewTrip;

  /// No description provided for @startByCreatingTrip.
  ///
  /// In en, this message translates to:
  /// **'Start by creating a New Trip'**
  String get startByCreatingTrip;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @todayText.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayText;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @rideDuration.
  ///
  /// In en, this message translates to:
  /// **'Ride Duration'**
  String get rideDuration;

  /// No description provided for @speedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesShort;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondsShort;

  /// No description provided for @getMoreOutOfTrackify.
  ///
  /// In en, this message translates to:
  /// **'Get more out of Trackify'**
  String get getMoreOutOfTrackify;

  /// No description provided for @discoverMoreDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover more — awesome things await!'**
  String get discoverMoreDesc;

  /// No description provided for @serviceLogs.
  ///
  /// In en, this message translates to:
  /// **'Service Logs'**
  String get serviceLogs;

  /// No description provided for @safeParking.
  ///
  /// In en, this message translates to:
  /// **'Safe Parking'**
  String get safeParking;

  /// No description provided for @appUpdates.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdates;

  /// No description provided for @deviceDataPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Data Plan'**
  String get deviceDataPlanLabel;

  /// No description provided for @deviceWarrantyLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Warranty'**
  String get deviceWarrantyLabel;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get videoTutorials;

  /// No description provided for @exploreNow.
  ///
  /// In en, this message translates to:
  /// **'Explore Now'**
  String get exploreNow;

  /// No description provided for @plusLabel.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get plusLabel;

  /// No description provided for @mapStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Map Style'**
  String get mapStyleLabel;

  /// No description provided for @darkStyle.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkStyle;

  /// No description provided for @lightStyle.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightStyle;

  /// No description provided for @simpleStyle.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get simpleStyle;

  /// No description provided for @satelliteStyle.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satelliteStyle;

  /// No description provided for @mapOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Map Options'**
  String get mapOptionsLabel;

  /// No description provided for @trafficLabel.
  ///
  /// In en, this message translates to:
  /// **'Traffic'**
  String get trafficLabel;

  /// No description provided for @labelsLabel.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labelsLabel;

  /// No description provided for @sharedWithMe.
  ///
  /// In en, this message translates to:
  /// **'Shared with me'**
  String get sharedWithMe;

  /// No description provided for @todaysStats.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Stats'**
  String get todaysStats;

  /// No description provided for @parkedSinceTime.
  ///
  /// In en, this message translates to:
  /// **'Parked Since: {time}'**
  String parkedSinceTime(String time);

  /// No description provided for @kmsMoreToGo.
  ///
  /// In en, this message translates to:
  /// **'{value} kms more to go'**
  String kmsMoreToGo(String value);

  /// No description provided for @buyTrackifyDevice.
  ///
  /// In en, this message translates to:
  /// **'Buy Trackify Device'**
  String get buyTrackifyDevice;

  /// No description provided for @recordViaPhone.
  ///
  /// In en, this message translates to:
  /// **'Record via Phone'**
  String get recordViaPhone;

  /// No description provided for @progressPercentage.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String progressPercentage(String value);

  /// No description provided for @labelColon.
  ///
  /// In en, this message translates to:
  /// **'{label}:'**
  String labelColon(String label);

  /// No description provided for @fuelEmpty.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get fuelEmpty;

  /// No description provided for @fuelFull.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get fuelFull;

  /// No description provided for @vehicleNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'SP 125'**
  String get vehicleNamePlaceholder;

  /// No description provided for @vehicleNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'MP09QV8269'**
  String get vehicleNumberPlaceholder;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @profileCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Profile completeness'**
  String get profileCompleteness;

  /// No description provided for @lastUpdatedOn.
  ///
  /// In en, this message translates to:
  /// **'Last updated on {date}'**
  String lastUpdatedOn(String date);

  /// No description provided for @addProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Add your profile picture'**
  String get addProfilePicture;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personalDetails;

  /// No description provided for @userNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userNameLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumberLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @medicalInsuranceInfo.
  ///
  /// In en, this message translates to:
  /// **'Medical insurance information'**
  String get medicalInsuranceInfo;

  /// No description provided for @addMedicalInsuranceInfo.
  ///
  /// In en, this message translates to:
  /// **'Add Medical insurance information'**
  String get addMedicalInsuranceInfo;

  /// No description provided for @vehicleInsuranceInfo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle insurance information'**
  String get vehicleInsuranceInfo;

  /// No description provided for @editViewVehicleInsuranceDesc.
  ///
  /// In en, this message translates to:
  /// **'Edit and view vehicle insurance details in vehicle settings.'**
  String get editViewVehicleInsuranceDesc;

  /// No description provided for @myGarageVehiclePath.
  ///
  /// In en, this message translates to:
  /// **'My Garage > Vehicle'**
  String get myGarageVehiclePath;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @addEditEmergencyContactDesc.
  ///
  /// In en, this message translates to:
  /// **'Add and edit emergency contact list in vehicle settings.'**
  String get addEditEmergencyContactDesc;

  /// No description provided for @smartContactSticker.
  ///
  /// In en, this message translates to:
  /// **'Smart Contact Sticker'**
  String get smartContactSticker;

  /// No description provided for @stickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A step forward to make your vehicle SAFE and SMART'**
  String get stickerSubtitle;

  /// No description provided for @activateContactSticker.
  ///
  /// In en, this message translates to:
  /// **'Activate contact sticker'**
  String get activateContactSticker;

  /// No description provided for @buyNewContactSticker.
  ///
  /// In en, this message translates to:
  /// **'Buy a new contact sticker'**
  String get buyNewContactSticker;

  /// No description provided for @beyondParkingProblems.
  ///
  /// In en, this message translates to:
  /// **'Beyond parking problems'**
  String get beyondParkingProblems;

  /// No description provided for @noParkings.
  ///
  /// In en, this message translates to:
  /// **'No Parkings'**
  String get noParkings;

  /// No description provided for @emergencies.
  ///
  /// In en, this message translates to:
  /// **'Emergencies'**
  String get emergencies;

  /// No description provided for @vehicleTowing.
  ///
  /// In en, this message translates to:
  /// **'Vehicle towing'**
  String get vehicleTowing;

  /// No description provided for @getInformedStayConnected.
  ///
  /// In en, this message translates to:
  /// **'Get informed & stay connected\nwith your vehicle'**
  String get getInformedStayConnected;

  /// No description provided for @securedCalls.
  ///
  /// In en, this message translates to:
  /// **'Secured Calls'**
  String get securedCalls;

  /// No description provided for @securedCallsDesc.
  ///
  /// In en, this message translates to:
  /// **'Internet-masked calls-keeps your phone number private.'**
  String get securedCallsDesc;

  /// No description provided for @notificationHistory.
  ///
  /// In en, this message translates to:
  /// **'Notification History'**
  String get notificationHistory;

  /// No description provided for @notificationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep track of all the current and previous notifications'**
  String get notificationHistoryDesc;

  /// No description provided for @beInformed.
  ///
  /// In en, this message translates to:
  /// **'Be Informed'**
  String get beInformed;

  /// No description provided for @beInformedDesc.
  ///
  /// In en, this message translates to:
  /// **'Know instantly when someone scans your QR code & take prompt actions when they call you.'**
  String get beInformedDesc;

  /// No description provided for @controlWhatOthersSee.
  ///
  /// In en, this message translates to:
  /// **'Control What Others See'**
  String get controlWhatOthersSee;

  /// No description provided for @controlWhatOthersSeeDesc.
  ///
  /// In en, this message translates to:
  /// **'Customize the details shown when someone scans the QR.'**
  String get controlWhatOthersSeeDesc;

  /// No description provided for @preventFrustrationDamage.
  ///
  /// In en, this message translates to:
  /// **'Prevent Frustration & Damage'**
  String get preventFrustrationDamage;

  /// No description provided for @preventFrustrationDamageDesc.
  ///
  /// In en, this message translates to:
  /// **'Avoid conflicts and vehicle damage caused by incorrect parking.'**
  String get preventFrustrationDamageDesc;

  /// No description provided for @serviceLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Never miss a vehicle service. Get reminders and track expenses to keep your vehicle in top condition.'**
  String get serviceLogsSubtitle;

  /// No description provided for @addServiceLogs.
  ///
  /// In en, this message translates to:
  /// **'Add Service Logs'**
  String get addServiceLogs;

  /// No description provided for @uploadServicingBill.
  ///
  /// In en, this message translates to:
  /// **'Upload Servicing bill'**
  String get uploadServicingBill;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @maxFileSizeNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Maximum File Size is 5MB'**
  String get maxFileSizeNote;

  /// No description provided for @serviceDate.
  ///
  /// In en, this message translates to:
  /// **'Service Date'**
  String get serviceDate;

  /// No description provided for @billingAmount.
  ///
  /// In en, this message translates to:
  /// **'Billing Amount'**
  String get billingAmount;

  /// No description provided for @serviceCenterName.
  ///
  /// In en, this message translates to:
  /// **'Service Center Name'**
  String get serviceCenterName;

  /// No description provided for @serviceCenterContact.
  ///
  /// In en, this message translates to:
  /// **'Service Center Contact'**
  String get serviceCenterContact;

  /// No description provided for @additionalNote.
  ///
  /// In en, this message translates to:
  /// **'Additional Note'**
  String get additionalNote;

  /// No description provided for @saveDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Details'**
  String get saveDetails;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// No description provided for @liveTab.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get historyTab;

  /// No description provided for @liveLocationSharingActive.
  ///
  /// In en, this message translates to:
  /// **'Live Location Sharing Active'**
  String get liveLocationSharingActive;

  /// No description provided for @noLiveLocationShared.
  ///
  /// In en, this message translates to:
  /// **'No live location shared'**
  String get noLiveLocationShared;

  /// No description provided for @realTimeSharingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your location is being shared in real-time with selected contacts.'**
  String get realTimeSharingDesc;

  /// No description provided for @startSharingPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Start sharing your phone\'s location to help others track you'**
  String get startSharingPhoneDesc;

  /// No description provided for @noHistoryAvailable.
  ///
  /// In en, this message translates to:
  /// **'No history available'**
  String get noHistoryAvailable;

  /// No description provided for @historyDesc.
  ///
  /// In en, this message translates to:
  /// **'Past location shares will appear here once they are completed.'**
  String get historyDesc;

  /// No description provided for @stopSharing.
  ///
  /// In en, this message translates to:
  /// **'Stop Sharing'**
  String get stopSharing;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get shareLocation;

  /// No description provided for @startSharing.
  ///
  /// In en, this message translates to:
  /// **'Start Sharing'**
  String get startSharing;

  /// No description provided for @phoneTracking.
  ///
  /// In en, this message translates to:
  /// **'Phone Tracking'**
  String get phoneTracking;

  /// No description provided for @liveRecordTab.
  ///
  /// In en, this message translates to:
  /// **'Live Record'**
  String get liveRecordTab;

  /// No description provided for @statsTab.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTab;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @totalRides.
  ///
  /// In en, this message translates to:
  /// **'Total Rides'**
  String get totalRides;

  /// No description provided for @avgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Avg Speed'**
  String get avgSpeed;

  /// No description provided for @totalFuel.
  ///
  /// In en, this message translates to:
  /// **'Total Fuel'**
  String get totalFuel;

  /// No description provided for @overallDistance.
  ///
  /// In en, this message translates to:
  /// **'Overall Distance'**
  String get overallDistance;

  /// No description provided for @drivingTime.
  ///
  /// In en, this message translates to:
  /// **'Driving Time'**
  String get drivingTime;

  /// No description provided for @safetyScore.
  ///
  /// In en, this message translates to:
  /// **'Safety Score'**
  String get safetyScore;

  /// No description provided for @speedAlertInput.
  ///
  /// In en, this message translates to:
  /// **'Speed alert input'**
  String get speedAlertInput;

  /// No description provided for @alertTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert title'**
  String get alertTitle;

  /// No description provided for @speedLimitKmH.
  ///
  /// In en, this message translates to:
  /// **'Speed limit (km/h)'**
  String get speedLimitKmH;

  /// No description provided for @timeDurationSec.
  ///
  /// In en, this message translates to:
  /// **'Time Duration (sec)'**
  String get timeDurationSec;

  /// No description provided for @selectYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select your vehicle'**
  String get selectYourVehicle;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @selectVehiclesOverspeedAlert.
  ///
  /// In en, this message translates to:
  /// **'Select vehicles on which to add overspeed alert'**
  String get selectVehiclesOverspeedAlert;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get sec;

  /// No description provided for @kmHr.
  ///
  /// In en, this message translates to:
  /// **'km/hr'**
  String get kmHr;
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
