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
  /// **'PROCEED'**
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

  /// No description provided for @vehicleImage.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Image'**
  String get vehicleImage;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newLabel;

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
  /// **'Quickly set up your Trackify smart device with simple steps'**
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
  /// **'Buy Trackify device now for real-time tracking and complete peace of mind.'**
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

  /// No description provided for @buyTrackifyDevice.
  ///
  /// In en, this message translates to:
  /// **'Buy Trackify Device'**
  String get buyTrackifyDevice;

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
  /// **'Upgrade to Plus'**
  String get upgradeToPlus;

  /// No description provided for @getMoreOutOfTrackify.
  ///
  /// In en, this message translates to:
  /// **'Get more out of Trackify'**
  String get getMoreOutOfTrackify;

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
  /// **'What is your issue related to?'**
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

  /// No description provided for @mySuggestions.
  ///
  /// In en, this message translates to:
  /// **'My Suggestions'**
  String get mySuggestions;

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
  /// **'Trackify Device Installation'**
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

  /// No description provided for @openTrackifyBoxInstruction.
  ///
  /// In en, this message translates to:
  /// **'Open Trackify box for the activation QR code.'**
  String get openTrackifyBoxInstruction;

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
  /// **'Note: Max file size is 5MB'**
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

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get viewMore;

  /// No description provided for @viewLess.
  ///
  /// In en, this message translates to:
  /// **'View less'**
  String get viewLess;

  /// No description provided for @previousRides.
  ///
  /// In en, this message translates to:
  /// **'Previous Rides'**
  String get previousRides;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @videosYouMightLike.
  ///
  /// In en, this message translates to:
  /// **'Videos You Might Like'**
  String get videosYouMightLike;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to Top'**
  String get scrollToTop;

  /// No description provided for @noRecentRidesFound.
  ///
  /// In en, this message translates to:
  /// **'No recent rides found'**
  String get noRecentRidesFound;

  /// No description provided for @failedToLoadRides.
  ///
  /// In en, this message translates to:
  /// **'Failed to load rides'**
  String get failedToLoadRides;

  /// No description provided for @hrMin.
  ///
  /// In en, this message translates to:
  /// **'hr:min'**
  String get hrMin;

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel;

  /// No description provided for @switchLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchLabel;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @rechargePlans.
  ///
  /// In en, this message translates to:
  /// **'Recharge Plans'**
  String get rechargePlans;

  /// No description provided for @superComboPlan.
  ///
  /// In en, this message translates to:
  /// **'Super Combo Plan'**
  String get superComboPlan;

  /// No description provided for @month12Validity.
  ///
  /// In en, this message translates to:
  /// **'12-Month Validity'**
  String get month12Validity;

  /// No description provided for @month6Validity.
  ///
  /// In en, this message translates to:
  /// **'6-Month Validity'**
  String get month6Validity;

  /// No description provided for @saveAmount.
  ///
  /// In en, this message translates to:
  /// **'Save ₹{amount} with this plan'**
  String saveAmount(Object amount);

  /// No description provided for @superComboPopularity.
  ///
  /// In en, this message translates to:
  /// **'95% of users choose the Super Combo Plan'**
  String get superComboPopularity;

  /// No description provided for @appSimRecharge.
  ///
  /// In en, this message translates to:
  /// **'App & SIM Recharge'**
  String get appSimRecharge;

  /// No description provided for @extendedWarranty.
  ///
  /// In en, this message translates to:
  /// **'Extended Warranty'**
  String get extendedWarranty;

  /// No description provided for @plusMembership.
  ///
  /// In en, this message translates to:
  /// **'Plus Membership'**
  String get plusMembership;

  /// No description provided for @continueSuperCombo.
  ///
  /// In en, this message translates to:
  /// **'Continue with Super Combo Plan'**
  String get continueSuperCombo;

  /// No description provided for @continue12Month.
  ///
  /// In en, this message translates to:
  /// **'Continue with 12-Month Plan'**
  String get continue12Month;

  /// No description provided for @continue6Month.
  ///
  /// In en, this message translates to:
  /// **'Continue with 6-Month Plan'**
  String get continue6Month;

  /// No description provided for @vehicleDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Documents'**
  String get vehicleDocumentsTitle;

  /// No description provided for @personalDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your vehicle documents handy by uploading them'**
  String get personalDocumentsSubtitle;

  /// No description provided for @vehicleRC.
  ///
  /// In en, this message translates to:
  /// **'Vehicle RC'**
  String get vehicleRC;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @puc.
  ///
  /// In en, this message translates to:
  /// **'PUC'**
  String get puc;

  /// No description provided for @vehicleRCTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle RC'**
  String get vehicleRCTitle;

  /// No description provided for @insuranceTitle.
  ///
  /// In en, this message translates to:
  /// **'Insurance Details'**
  String get insuranceTitle;

  /// No description provided for @pucTitle.
  ///
  /// In en, this message translates to:
  /// **'PUC Certificate'**
  String get pucTitle;

  /// No description provided for @notificationControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Controls'**
  String get notificationControlsTitle;

  /// No description provided for @ignitionOnOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Ignition ON/OFF'**
  String get ignitionOnOffTitle;

  /// No description provided for @ignitionOnOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notification when vehicle ignition is ON or OFF'**
  String get ignitionOnOffDesc;

  /// No description provided for @motionWithIgnitionOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Motion with Ignition OFF'**
  String get motionWithIgnitionOffTitle;

  /// No description provided for @motionWithIgnitionOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notification when vehicle moves when ignition is OFF'**
  String get motionWithIgnitionOffDesc;

  /// No description provided for @powerSupplyOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Power supply OFF'**
  String get powerSupplyOffTitle;

  /// No description provided for @powerSupplyOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notification when Trackify is not receiving power'**
  String get powerSupplyOffDesc;

  /// No description provided for @appNotification.
  ///
  /// In en, this message translates to:
  /// **'App notification'**
  String get appNotification;

  /// No description provided for @odometerReading.
  ///
  /// In en, this message translates to:
  /// **'Odometer Reading'**
  String get odometerReading;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @gpsReadingNote.
  ///
  /// In en, this message translates to:
  /// **'GPS-based reading, minor differences may occur.'**
  String get gpsReadingNote;

  /// No description provided for @tankCapacity.
  ///
  /// In en, this message translates to:
  /// **'Tank Capacity'**
  String get tankCapacity;

  /// No description provided for @afterLastRefuel.
  ///
  /// In en, this message translates to:
  /// **'After Last Refuel'**
  String get afterLastRefuel;

  /// No description provided for @fuelRemaining.
  ///
  /// In en, this message translates to:
  /// **'Fuel Remaining'**
  String get fuelRemaining;

  /// No description provided for @distanceRemaining.
  ///
  /// In en, this message translates to:
  /// **'Distance Remaining'**
  String get distanceRemaining;

  /// No description provided for @mileageArai.
  ///
  /// In en, this message translates to:
  /// **'Mileage (ARAI)'**
  String get mileageArai;

  /// No description provided for @spendingOnFuel.
  ///
  /// In en, this message translates to:
  /// **'Spending on Fuel'**
  String get spendingOnFuel;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get thisYear;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @customDates.
  ///
  /// In en, this message translates to:
  /// **'Custom dates'**
  String get customDates;

  /// No description provided for @refuelHistory.
  ///
  /// In en, this message translates to:
  /// **'Refuel History'**
  String get refuelHistory;

  /// No description provided for @addRefuelingDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Refueling Details'**
  String get addRefuelingDetails;

  /// No description provided for @fuelStations.
  ///
  /// In en, this message translates to:
  /// **'Fuel Stations'**
  String get fuelStations;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @litersShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get litersShort;

  /// No description provided for @fuelEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'These values are estimates based on your fuel entries. Add fuel logs regularly for better accuracy.'**
  String get fuelEstimateNote;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @currentOdometerReading.
  ///
  /// In en, this message translates to:
  /// **'Current Odometer Reading'**
  String get currentOdometerReading;

  /// No description provided for @odometerUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Regularly update your odometer for accurate fuel and distance estimates'**
  String get odometerUpdateDesc;

  /// No description provided for @updateTankCapacity.
  ///
  /// In en, this message translates to:
  /// **'Update Tank Capacity'**
  String get updateTankCapacity;

  /// No description provided for @tankCapacityDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the maximum fuel capacity of your vehicle tank'**
  String get tankCapacityDesc;

  /// No description provided for @litres.
  ///
  /// In en, this message translates to:
  /// **'Litres'**
  String get litres;

  /// No description provided for @kms.
  ///
  /// In en, this message translates to:
  /// **'Kms'**
  String get kms;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @updateMileageArai.
  ///
  /// In en, this message translates to:
  /// **'Update Mileage (ARAI)'**
  String get updateMileageArai;

  /// No description provided for @mileageDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter current mileage (Km/L) to track remaining fuel & distance accurately.'**
  String get mileageDesc;

  /// No description provided for @kmL.
  ///
  /// In en, this message translates to:
  /// **'Km/L'**
  String get kmL;

  /// No description provided for @serviceLogAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service log added successfully'**
  String get serviceLogAddedSuccess;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'₹'**
  String get currencySymbol;

  /// No description provided for @validityLabel.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get validityLabel;

  /// No description provided for @plusGst.
  ///
  /// In en, this message translates to:
  /// **'+ GST'**
  String get plusGst;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @refuelHistoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Refuel History Coming Soon'**
  String get refuelHistoryComingSoon;

  /// No description provided for @fuelStationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Fuel Stations Coming Soon'**
  String get fuelStationsComingSoon;

  /// No description provided for @percentageValue.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentageValue(String value);

  /// No description provided for @totalFuelAdded.
  ///
  /// In en, this message translates to:
  /// **'Total Fuel Added'**
  String get totalFuelAdded;

  /// No description provided for @totalSpendings.
  ///
  /// In en, this message translates to:
  /// **'Total spendings'**
  String get totalSpendings;

  /// No description provided for @avgMileage.
  ///
  /// In en, this message translates to:
  /// **'Avg Mileage'**
  String get avgMileage;

  /// No description provided for @refuels.
  ///
  /// In en, this message translates to:
  /// **'Refuels'**
  String get refuels;

  /// No description provided for @refuelingHistory.
  ///
  /// In en, this message translates to:
  /// **'Refueling History'**
  String get refuelingHistory;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldestFirst;

  /// No description provided for @mostExpensive.
  ///
  /// In en, this message translates to:
  /// **'Most Expensive'**
  String get mostExpensive;

  /// No description provided for @leastExpensive.
  ///
  /// In en, this message translates to:
  /// **'Least Expensive'**
  String get leastExpensive;

  /// No description provided for @bestMileage.
  ///
  /// In en, this message translates to:
  /// **'Best Mileage'**
  String get bestMileage;

  /// No description provided for @worstMileage.
  ///
  /// In en, this message translates to:
  /// **'Worst Mileage'**
  String get worstMileage;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @hintEg.
  ///
  /// In en, this message translates to:
  /// **'e.g., {value}'**
  String hintEg(String value);

  /// No description provided for @addStation.
  ///
  /// In en, this message translates to:
  /// **'Add Station'**
  String get addStation;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @addedByMe.
  ///
  /// In en, this message translates to:
  /// **'Added by me'**
  String get addedByMe;

  /// No description provided for @noFavourites.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get noFavourites;

  /// No description provided for @noStationsAdded.
  ///
  /// In en, this message translates to:
  /// **'No stations added yet'**
  String get noStationsAdded;

  /// No description provided for @fuelStationNearVehicle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Station Near Vehicle'**
  String get fuelStationNearVehicle;

  /// No description provided for @warranty_title.
  ///
  /// In en, this message translates to:
  /// **'Device Warranty'**
  String get warranty_title;

  /// No description provided for @warranty_benefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefits you do not want to miss'**
  String get warranty_benefitsTitle;

  /// No description provided for @warranty_extend.
  ///
  /// In en, this message translates to:
  /// **'Extend warranty of your Trackify Lite by 1 year @ ₹1/day'**
  String get warranty_extend;

  /// No description provided for @warranty_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get warranty_vehicle;

  /// No description provided for @warranty_expiry.
  ///
  /// In en, this message translates to:
  /// **'Warranty expiry date'**
  String get warranty_expiry;

  /// No description provided for @warranty_button.
  ///
  /// In en, this message translates to:
  /// **'Extend warranty now @ ₹365 '**
  String get warranty_button;

  /// No description provided for @warranty_button_old.
  ///
  /// In en, this message translates to:
  /// **'₹730'**
  String get warranty_button_old;

  /// No description provided for @benefit1_highlight.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed replacement'**
  String get benefit1_highlight;

  /// No description provided for @benefit1_normal.
  ///
  /// In en, this message translates to:
  /// **' in case of failure'**
  String get benefit1_normal;

  /// No description provided for @benefit2_highlight.
  ///
  /// In en, this message translates to:
  /// **'Save upto ₹1200'**
  String get benefit2_highlight;

  /// No description provided for @benefit2_normal.
  ///
  /// In en, this message translates to:
  /// **' on device repair'**
  String get benefit2_normal;

  /// No description provided for @benefit3_highlight.
  ///
  /// In en, this message translates to:
  /// **'Instant support'**
  String get benefit3_highlight;

  /// No description provided for @benefit3_normal.
  ///
  /// In en, this message translates to:
  /// **' for device related issues'**
  String get benefit3_normal;

  /// No description provided for @benefit4_highlight.
  ///
  /// In en, this message translates to:
  /// **'Free extended subscription upto ₹2000'**
  String get benefit4_highlight;

  /// No description provided for @benefit4_normal.
  ///
  /// In en, this message translates to:
  /// **' for faulty period'**
  String get benefit4_normal;

  /// No description provided for @initiatingEmergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Initiating Emergency Alert to Trackify users'**
  String get initiatingEmergencyAlert;

  /// No description provided for @pleaseUseResponsibly.
  ///
  /// In en, this message translates to:
  /// **'Please use responsibly'**
  String get pleaseUseResponsibly;

  /// No description provided for @secondsBeforeSendingAlert.
  ///
  /// In en, this message translates to:
  /// **'seconds before sending alert'**
  String get secondsBeforeSendingAlert;

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send Now'**
  String get sendNow;

  /// No description provided for @geoFenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Geo-fence'**
  String get geoFenceTitle;

  /// No description provided for @geoFenceRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius: {radius}m'**
  String geoFenceRadius(String radius);

  /// No description provided for @geoFenceLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get geoFenceLocating;

  /// No description provided for @geoFenceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a geo-fence name'**
  String get geoFenceNameRequired;

  /// No description provided for @geoFenceSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Geo-fence saved successfully!'**
  String get geoFenceSaveSuccess;

  /// No description provided for @geoFenceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get geoFenceSearchHint;

  /// No description provided for @geoFenceSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select Geo-fence type for '**
  String get geoFenceSelectType;

  /// No description provided for @geoFenceTypeHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get geoFenceTypeHome;

  /// No description provided for @geoFenceTypeOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get geoFenceTypeOffice;

  /// No description provided for @geoFenceTypeFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get geoFenceTypeFamily;

  /// No description provided for @geoFenceTypeParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get geoFenceTypeParking;

  /// No description provided for @geoFenceTypeOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get geoFenceTypeOthers;

  /// No description provided for @geoFenceNameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Geo-fence name, eg: Home'**
  String get geoFenceNameFieldHint;

  /// No description provided for @geoFenceAddSmsContacts.
  ///
  /// In en, this message translates to:
  /// **'Add Contacts for SMS Alert'**
  String get geoFenceAddSmsContacts;

  /// No description provided for @geoFenceEmptyStateDesc.
  ///
  /// In en, this message translates to:
  /// **'Draw a circle on the map and be alerted whenever a bike enters or exits the circle.'**
  String get geoFenceEmptyStateDesc;

  /// No description provided for @addGeoFenceButton.
  ///
  /// In en, this message translates to:
  /// **'Add Geo-fence'**
  String get addGeoFenceButton;

  /// No description provided for @safeParkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Parking'**
  String get safeParkingTitle;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @setupSafeParking.
  ///
  /// In en, this message translates to:
  /// **'Set up Safe Parking'**
  String get setupSafeParking;

  /// No description provided for @safeParkingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get call alerts for engine ON & towing alerts'**
  String get safeParkingSubtitle;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @safeParkingDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable alerts when engine is turned ON or towing is detected'**
  String get safeParkingDescription;

  /// No description provided for @geoFenceDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this Geo-Fence?'**
  String get geoFenceDeleteConfirmation;

  /// No description provided for @geoFenceTurnOffConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to turn Off this geo fence?'**
  String get geoFenceTurnOffConfirmation;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOff;

  /// No description provided for @plusMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **'PLUS MEMBERSHIP'**
  String get plusMembershipTitle;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @premiumBenefits.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM BENEFITS'**
  String get premiumBenefits;

  /// No description provided for @otherBenefits.
  ///
  /// In en, this message translates to:
  /// **'OTHER BENEFITS'**
  String get otherBenefits;

  /// No description provided for @trackifyPlusReviews.
  ///
  /// In en, this message translates to:
  /// **'TRACKIFY PLUS REVIEWS'**
  String get trackifyPlusReviews;

  /// No description provided for @offerings.
  ///
  /// In en, this message translates to:
  /// **'Offerings'**
  String get offerings;

  /// No description provided for @plus.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get plus;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @upgradeNowAtJust.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now at Just ₹{price}'**
  String upgradeNowAtJust(String price);

  /// No description provided for @viewMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'View More Reviews'**
  String get viewMoreReviews;

  /// No description provided for @speciallyForYou.
  ///
  /// In en, this message translates to:
  /// **'Specially For You'**
  String get speciallyForYou;

  /// No description provided for @footerMotto.
  ///
  /// In en, this message translates to:
  /// **'Creating a future where every bike is SMART\nand every rider is SAFE'**
  String get footerMotto;

  /// No description provided for @cropDocument.
  ///
  /// In en, this message translates to:
  /// **'Crop Document'**
  String get cropDocument;

  /// No description provided for @cropVehicleImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Vehicle Image'**
  String get cropVehicleImage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large (max 5MB)'**
  String get fileTooLarge;

  /// No description provided for @pickImageError.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get pickImageError;

  /// No description provided for @pickPdfError.
  ///
  /// In en, this message translates to:
  /// **'Error picking PDF'**
  String get pickPdfError;

  /// No description provided for @pdfTooLarge.
  ///
  /// In en, this message translates to:
  /// **'PDF size exceeds 5MB limit'**
  String get pdfTooLarge;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @frontSide.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get frontSide;

  /// No description provided for @backSide.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get backSide;

  /// No description provided for @commitmentText.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your privacy and ensuring your documents are safe with us.'**
  String get commitmentText;

  /// No description provided for @documentsSafe.
  ///
  /// In en, this message translates to:
  /// **'Your documents are safe with us'**
  String get documentsSafe;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @frontRequired.
  ///
  /// In en, this message translates to:
  /// **'Front side document is required'**
  String get frontRequired;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'Document saved successfully'**
  String get successMessage;

  /// No description provided for @selectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Select Expiry Date'**
  String get selectExpiryDate;

  /// No description provided for @documentsEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Your documents are encrypted & safe'**
  String get documentsEncrypted;

  /// No description provided for @fileSizeNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Maximum File Size is 5MB'**
  String get fileSizeNote;

  /// No description provided for @personalDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Documents'**
  String get personalDocumentsTitle;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicense;

  /// No description provided for @drivingLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicenseTitle;

  /// No description provided for @otherDocuments.
  ///
  /// In en, this message translates to:
  /// **'Other Documents'**
  String get otherDocuments;

  /// No description provided for @otherDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Other Documents'**
  String get otherDocumentTitle;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document Name*'**
  String get documentName;

  /// No description provided for @billsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get billsTitle;

  /// No description provided for @billsDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload and manage your vehicle-related bills'**
  String get billsDescription;

  /// No description provided for @movedTo.
  ///
  /// In en, this message translates to:
  /// **'Moved to'**
  String get movedTo;

  /// No description provided for @viewNow.
  ///
  /// In en, this message translates to:
  /// **'View Now'**
  String get viewNow;

  /// No description provided for @accessoryBills.
  ///
  /// In en, this message translates to:
  /// **'Accessory Bills'**
  String get accessoryBills;

  /// No description provided for @tutorialVideos.
  ///
  /// In en, this message translates to:
  /// **'Tutorial Videos'**
  String get tutorialVideos;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @amazingFeatures.
  ///
  /// In en, this message translates to:
  /// **'Amazing Features'**
  String get amazingFeatures;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos found'**
  String get noVideos;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRange;

  /// No description provided for @notificationTypes.
  ///
  /// In en, this message translates to:
  /// **'Notification types'**
  String get notificationTypes;

  /// No description provided for @motionSensed.
  ///
  /// In en, this message translates to:
  /// **'Motion sensed'**
  String get motionSensed;

  /// No description provided for @ignitionOff.
  ///
  /// In en, this message translates to:
  /// **'Ignition off'**
  String get ignitionOff;

  /// No description provided for @ignitionOn.
  ///
  /// In en, this message translates to:
  /// **'Ignition on'**
  String get ignitionOn;

  /// No description provided for @accidentDetected.
  ///
  /// In en, this message translates to:
  /// **'Accident detected'**
  String get accidentDetected;

  /// No description provided for @stationaryFallDetected.
  ///
  /// In en, this message translates to:
  /// **'Stationary fall detected'**
  String get stationaryFallDetected;

  /// No description provided for @vehicleSwitchedOff.
  ///
  /// In en, this message translates to:
  /// **'Vehicle switched off'**
  String get vehicleSwitchedOff;

  /// No description provided for @vehicleSwitchedOn.
  ///
  /// In en, this message translates to:
  /// **'Vehicle switched on'**
  String get vehicleSwitchedOn;

  /// No description provided for @powerSupplyOn.
  ///
  /// In en, this message translates to:
  /// **'Power supply on'**
  String get powerSupplyOn;

  /// No description provided for @vibrationSensed.
  ///
  /// In en, this message translates to:
  /// **'Vibration sensed'**
  String get vibrationSensed;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// No description provided for @diesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// No description provided for @cng.
  ///
  /// In en, this message translates to:
  /// **'CNG'**
  String get cng;

  /// No description provided for @updateVehicle.
  ///
  /// In en, this message translates to:
  /// **'Update Vehicle'**
  String get updateVehicle;

  /// No description provided for @vehicleMileage.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Mileage'**
  String get vehicleMileage;

  /// No description provided for @notificationControls.
  ///
  /// In en, this message translates to:
  /// **'Notification controls'**
  String get notificationControls;

  /// No description provided for @changeNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Change your notification preferences'**
  String get changeNotificationPreferences;

  /// No description provided for @unmapTrackify.
  ///
  /// In en, this message translates to:
  /// **'Unmap your Trackify'**
  String get unmapTrackify;

  /// No description provided for @unmapStep1.
  ///
  /// In en, this message translates to:
  /// **'Step 1: To un-map device, call at +918061971443'**
  String get unmapStep1;

  /// No description provided for @unmapStep2.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Remove vehicle'**
  String get unmapStep2;

  /// No description provided for @updateMileage.
  ///
  /// In en, this message translates to:
  /// **'Update Mileage'**
  String get updateMileage;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: '**
  String get lastUpdated;

  /// No description provided for @lockUnlockVehicle.
  ///
  /// In en, this message translates to:
  /// **'Lock and Unlock Vehicle'**
  String get lockUnlockVehicle;

  /// No description provided for @sleepModeWarning.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle will not be Locked / Unlocked if the device is in sleep mode. '**
  String get sleepModeWarning;

  /// No description provided for @journeyWithTrackify.
  ///
  /// In en, this message translates to:
  /// **'Journey with Trackify'**
  String get journeyWithTrackify;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetime;

  /// No description provided for @hrMinFormat.
  ///
  /// In en, this message translates to:
  /// **'{hr} hr {min} min'**
  String hrMinFormat(Object hr, Object min);

  /// No description provided for @yourVehicleOnMap.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle on map'**
  String get yourVehicleOnMap;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @bike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get bike;

  /// No description provided for @scooty.
  ///
  /// In en, this message translates to:
  /// **'Scooty'**
  String get scooty;

  /// No description provided for @myVehicle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get myVehicle;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get selectColor;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get white;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @aqua.
  ///
  /// In en, this message translates to:
  /// **'Aqua'**
  String get aqua;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @sky.
  ///
  /// In en, this message translates to:
  /// **'Sky'**
  String get sky;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @whatIsSleepMode.
  ///
  /// In en, this message translates to:
  /// **'What is Sleep Mode?'**
  String get whatIsSleepMode;

  /// No description provided for @sleepModeDesc1.
  ///
  /// In en, this message translates to:
  /// **'When the Trackify device doesn\'t detect any vibration or motion, it automatically enters sleep mode to save the vehicle\'s battery.'**
  String get sleepModeDesc1;

  /// No description provided for @sleepModeDesc2.
  ///
  /// In en, this message translates to:
  /// **'The device instantly wakes up and begins tracking when it senses any motion and is in good network coverage.'**
  String get sleepModeDesc2;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hr;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @tankCapacityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 13'**
  String get tankCapacityHint;

  /// No description provided for @mileageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 50'**
  String get mileageHint;

  /// No description provided for @powerSupplyOff.
  ///
  /// In en, this message translates to:
  /// **'Power supply off'**
  String get powerSupplyOff;

  /// No description provided for @lastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated: '**
  String get lastUpdatedLabel;

  /// No description provided for @litresShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get litresShort;

  /// No description provided for @discoverTrackifyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Discover Trackify Features'**
  String get discoverTrackifyFeatures;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @pleaseEnterDetails.
  ///
  /// In en, this message translates to:
  /// **'Please enter the details given below'**
  String get pleaseEnterDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @houseFloorLine.
  ///
  /// In en, this message translates to:
  /// **'House, Floor, Line'**
  String get houseFloorLine;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get landmark;

  /// No description provided for @pinCode.
  ///
  /// In en, this message translates to:
  /// **'Pin Code'**
  String get pinCode;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// No description provided for @officeAddress.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddress;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get product;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get errorPickingImage;

  /// No description provided for @frontDocumentRequired.
  ///
  /// In en, this message translates to:
  /// **'Front document image is required'**
  String get frontDocumentRequired;

  /// No description provided for @documentUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadedSuccessfully;

  /// No description provided for @addAccessoryBill.
  ///
  /// In en, this message translates to:
  /// **'Add Accessory Bill'**
  String get addAccessoryBill;

  /// No description provided for @accessoryName.
  ///
  /// In en, this message translates to:
  /// **'Accessory Name'**
  String get accessoryName;

  /// No description provided for @billingDate.
  ///
  /// In en, this message translates to:
  /// **'Billing Date'**
  String get billingDate;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// No description provided for @shopContact.
  ///
  /// In en, this message translates to:
  /// **'Shop Contact'**
  String get shopContact;

  /// No description provided for @uploadBill.
  ///
  /// In en, this message translates to:
  /// **'Upload Bill'**
  String get uploadBill;

  /// No description provided for @yearExtendedWarranty.
  ///
  /// In en, this message translates to:
  /// **'1 year extended warranty'**
  String get yearExtendedWarranty;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @boosterOffer.
  ///
  /// In en, this message translates to:
  /// **'Booster offer @50% OFF'**
  String get boosterOffer;

  /// No description provided for @toPay.
  ///
  /// In en, this message translates to:
  /// **'To Pay'**
  String get toPay;

  /// No description provided for @amountPayable.
  ///
  /// In en, this message translates to:
  /// **'Amount Payable {amount}'**
  String amountPayable(String amount);

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @recentToOldest.
  ///
  /// In en, this message translates to:
  /// **'Recent to Oldest'**
  String get recentToOldest;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @backToDefault.
  ///
  /// In en, this message translates to:
  /// **'Back to Default'**
  String get backToDefault;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @oldestToRecent.
  ///
  /// In en, this message translates to:
  /// **'Oldest to Recent'**
  String get oldestToRecent;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @noTripsFound.
  ///
  /// In en, this message translates to:
  /// **'No trips found for \"{query}\"'**
  String noTripsFound(String query);

  /// No description provided for @ridesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rides'**
  String ridesCount(String count);

  /// No description provided for @searchTrips.
  ///
  /// In en, this message translates to:
  /// **'Search Trips'**
  String get searchTrips;

  /// No description provided for @searchRides.
  ///
  /// In en, this message translates to:
  /// **'Search Rides'**
  String get searchRides;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @yesImSure.
  ///
  /// In en, this message translates to:
  /// **'Yes I\'m Sure'**
  String get yesImSure;

  /// No description provided for @topSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Top Speed'**
  String get topSpeedLabel;

  /// No description provided for @rideDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Ride Duration'**
  String get rideDurationLabel;

  /// No description provided for @editRides.
  ///
  /// In en, this message translates to:
  /// **'Edit Rides'**
  String get editRides;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @tripQuoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip Quote'**
  String get tripQuoteLabel;

  /// No description provided for @unmerge.
  ///
  /// In en, this message translates to:
  /// **'Unmerge'**
  String get unmerge;

  /// No description provided for @tripNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip Name'**
  String get tripNameLabel;

  /// No description provided for @deleteTripConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your trip. Are you sure you want to continue?'**
  String get deleteTripConfirmation;

  /// No description provided for @tripStats.
  ///
  /// In en, this message translates to:
  /// **'Trip Stats'**
  String get tripStats;

  /// No description provided for @avgSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg. Speed'**
  String get avgSpeedLabel;

  /// No description provided for @tripQuoteDefault.
  ///
  /// In en, this message translates to:
  /// **'Every trip has a story. Yours goes here.'**
  String get tripQuoteDefault;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip'**
  String get deleteTrip;

  /// No description provided for @hrLabel.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hrLabel;

  /// No description provided for @ridesSelectedSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} rides selected | {distance} km • {duration}'**
  String ridesSelectedSummary(String count, String distance, String duration);

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear Selection'**
  String get clearSelection;

  /// No description provided for @secLabel.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get secLabel;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minLabel;

  /// No description provided for @selectionTooltipMessage.
  ///
  /// In en, this message translates to:
  /// **'Select the rides you want to add to your trip.'**
  String get selectionTooltipMessage;

  /// No description provided for @selectRides.
  ///
  /// In en, this message translates to:
  /// **'Select Rides'**
  String get selectRides;

  /// No description provided for @createTrip.
  ///
  /// In en, this message translates to:
  /// **'Create Trip'**
  String get createTrip;

  /// No description provided for @bestAverageSpeed.
  ///
  /// In en, this message translates to:
  /// **'Best average speed'**
  String get bestAverageSpeed;

  /// No description provided for @topSpeedClocked.
  ///
  /// In en, this message translates to:
  /// **'Top speed clocked'**
  String get topSpeedClocked;

  /// No description provided for @searchTripsHint.
  ///
  /// In en, this message translates to:
  /// **'Search Trips by Name'**
  String get searchTripsHint;

  /// No description provided for @noRidesFound.
  ///
  /// In en, this message translates to:
  /// **'No rides found for \"{query}\"'**
  String noRidesFound(String query);

  /// No description provided for @tripLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip {number}'**
  String tripLabel(String number);

  /// No description provided for @extraordinaryTrips.
  ///
  /// In en, this message translates to:
  /// **'Extraordinary Trips'**
  String get extraordinaryTrips;

  /// No description provided for @maxDistanceCovered.
  ///
  /// In en, this message translates to:
  /// **'Max distance covered'**
  String get maxDistanceCovered;

  /// No description provided for @searchRidesHint.
  ///
  /// In en, this message translates to:
  /// **'Search Rides by City'**
  String get searchRidesHint;

  /// No description provided for @healthInsurance.
  ///
  /// In en, this message translates to:
  /// **'Health Insurance'**
  String get healthInsurance;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @selectBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Blood Group'**
  String get selectBloodGroup;

  /// No description provided for @healthInsuranceCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Health Insurance Card Number'**
  String get healthInsuranceCardNumber;

  /// No description provided for @policyNumber.
  ///
  /// In en, this message translates to:
  /// **'Policy Number'**
  String get policyNumber;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @editEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit email address'**
  String get editEmailAddress;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get emailNotVerified;

  /// No description provided for @saveAndVerify.
  ///
  /// In en, this message translates to:
  /// **'Save & Verify'**
  String get saveAndVerify;

  /// No description provided for @editMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit mobile number'**
  String get editMobileNumber;

  /// No description provided for @tenDigitMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Ten digit mobile number'**
  String get tenDigitMobileNumber;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle name'**
  String get middleName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Address (max 100 characters)'**
  String get enterAddress;

  /// No description provided for @india.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get india;

  /// No description provided for @usa.
  ///
  /// In en, this message translates to:
  /// **'USA'**
  String get usa;

  /// No description provided for @uk.
  ///
  /// In en, this message translates to:
  /// **'UK'**
  String get uk;

  /// No description provided for @uae.
  ///
  /// In en, this message translates to:
  /// **'UAE'**
  String get uae;

  /// No description provided for @madhyaPradesh.
  ///
  /// In en, this message translates to:
  /// **'Madhya Pradesh'**
  String get madhyaPradesh;

  /// No description provided for @maharashtra.
  ///
  /// In en, this message translates to:
  /// **'Maharashtra'**
  String get maharashtra;

  /// No description provided for @rajasthan.
  ///
  /// In en, this message translates to:
  /// **'Rajasthan'**
  String get rajasthan;

  /// No description provided for @gujarat.
  ///
  /// In en, this message translates to:
  /// **'Gujarat'**
  String get gujarat;

  /// No description provided for @karnataka.
  ///
  /// In en, this message translates to:
  /// **'Karnataka'**
  String get karnataka;

  /// No description provided for @tamilNadu.
  ///
  /// In en, this message translates to:
  /// **'Tamil Nadu'**
  String get tamilNadu;

  /// No description provided for @uttarPradesh.
  ///
  /// In en, this message translates to:
  /// **'Uttar Pradesh'**
  String get uttarPradesh;

  /// No description provided for @delhi.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get delhi;

  /// No description provided for @indoreDistrict.
  ///
  /// In en, this message translates to:
  /// **'Indore district'**
  String get indoreDistrict;

  /// No description provided for @bhopal.
  ///
  /// In en, this message translates to:
  /// **'Bhopal'**
  String get bhopal;

  /// No description provided for @gwalior.
  ///
  /// In en, this message translates to:
  /// **'Gwalior'**
  String get gwalior;

  /// No description provided for @jabalpur.
  ///
  /// In en, this message translates to:
  /// **'Jabalpur'**
  String get jabalpur;

  /// No description provided for @ujjain.
  ///
  /// In en, this message translates to:
  /// **'Ujjain'**
  String get ujjain;

  /// No description provided for @notificationSounds.
  ///
  /// In en, this message translates to:
  /// **'Notification Sounds'**
  String get notificationSounds;

  /// No description provided for @changeSoundForNotification.
  ///
  /// In en, this message translates to:
  /// **'Change sound for different Notification'**
  String get changeSoundForNotification;

  /// No description provided for @vibrationAlert.
  ///
  /// In en, this message translates to:
  /// **'Vibration Alerts'**
  String get vibrationAlert;

  /// No description provided for @motionAlert.
  ///
  /// In en, this message translates to:
  /// **'Motion Alert'**
  String get motionAlert;

  /// No description provided for @ignitionAlert.
  ///
  /// In en, this message translates to:
  /// **'Ignition Alerts'**
  String get ignitionAlert;

  /// No description provided for @fallAlert.
  ///
  /// In en, this message translates to:
  /// **'Fall Alerts'**
  String get fallAlert;

  /// No description provided for @batteryAlert.
  ///
  /// In en, this message translates to:
  /// **'Battery Alerts'**
  String get batteryAlert;

  /// No description provided for @geofenceAlert.
  ///
  /// In en, this message translates to:
  /// **'Geofence Alerts'**
  String get geofenceAlert;

  /// No description provided for @speedAlert.
  ///
  /// In en, this message translates to:
  /// **'Speed Alerts'**
  String get speedAlert;

  /// No description provided for @otherAlert.
  ///
  /// In en, this message translates to:
  /// **'Other Alerts'**
  String get otherAlert;

  /// No description provided for @customNotification.
  ///
  /// In en, this message translates to:
  /// **'Custom Notifications'**
  String get customNotification;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @selectedPlan.
  ///
  /// In en, this message translates to:
  /// **'Selected Plan'**
  String get selectedPlan;

  /// No description provided for @validity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get validity;

  /// No description provided for @greatSaving.
  ///
  /// In en, this message translates to:
  /// **'Great! Saving ₹{amount} with this plan'**
  String greatSaving(Object amount);

  /// No description provided for @billSummary.
  ///
  /// In en, this message translates to:
  /// **'Bill Summary'**
  String get billSummary;

  /// No description provided for @planPrice.
  ///
  /// In en, this message translates to:
  /// **'Plan Price'**
  String get planPrice;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @gstTaxes.
  ///
  /// In en, this message translates to:
  /// **'GST (govt. taxes)'**
  String get gstTaxes;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹{amount}'**
  String payAmount(Object amount);

  /// No description provided for @liveRecord.
  ///
  /// In en, this message translates to:
  /// **'Live Record'**
  String get liveRecord;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @lastReportedPosition.
  ///
  /// In en, this message translates to:
  /// **'Last Reported Position'**
  String get lastReportedPosition;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @appUpdate.
  ///
  /// In en, this message translates to:
  /// **'App Update'**
  String get appUpdate;

  /// No description provided for @fuelStation.
  ///
  /// In en, this message translates to:
  /// **'Fuel Station'**
  String get fuelStation;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @currentOdometer.
  ///
  /// In en, this message translates to:
  /// **'Current Odometer (Km)'**
  String get currentOdometer;

  /// No description provided for @lastRecorded.
  ///
  /// In en, this message translates to:
  /// **'Last Recorded: 32789km'**
  String get lastRecorded;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @pricePerLitre.
  ///
  /// In en, this message translates to:
  /// **'Price / Litre'**
  String get pricePerLitre;

  /// No description provided for @tankStatus.
  ///
  /// In en, this message translates to:
  /// **'Tank Status'**
  String get tankStatus;

  /// No description provided for @fullTank.
  ///
  /// In en, this message translates to:
  /// **'Full tank'**
  String get fullTank;

  /// No description provided for @partialTank.
  ///
  /// In en, this message translates to:
  /// **'Partial Tank'**
  String get partialTank;

  /// No description provided for @fuelBeforeRefuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel Before Refuel'**
  String get fuelBeforeRefuel;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// No description provided for @fuelBeforeRefuelDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the estimated amount of fuel that was in the tank you refuelled.'**
  String get fuelBeforeRefuelDesc;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved Successfully'**
  String get savedSuccessfully;

  /// No description provided for @fuelStationName.
  ///
  /// In en, this message translates to:
  /// **'C.M. Petro Point, BPCL petr...'**
  String get fuelStationName;

  /// No description provided for @yourPhoneLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Phone\'s Location'**
  String get yourPhoneLocation;

  /// No description provided for @sharingActive.
  ///
  /// In en, this message translates to:
  /// **'Sharing active'**
  String get sharingActive;

  /// No description provided for @noActiveSharing.
  ///
  /// In en, this message translates to:
  /// **'No active sharing'**
  String get noActiveSharing;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @switchBetweenLightAndDarkThemes.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark themes'**
  String get switchBetweenLightAndDarkThemes;

  /// No description provided for @iHaveAnIssueWith.
  ///
  /// In en, this message translates to:
  /// **'I have an issue with'**
  String get iHaveAnIssueWith;

  /// No description provided for @iWantToProvideSuggestion.
  ///
  /// In en, this message translates to:
  /// **'I want to provide a suggestion for'**
  String get iWantToProvideSuggestion;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get selectType;

  /// No description provided for @whatIsSuggestionSubject.
  ///
  /// In en, this message translates to:
  /// **'What is the subject of your suggestion?'**
  String get whatIsSuggestionSubject;

  /// No description provided for @giveShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Give short description'**
  String get giveShortDescription;

  /// No description provided for @giveSuggestionFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give your suggestion/feedback (max 200 characters)'**
  String get giveSuggestionFeedback;

  /// No description provided for @giveSuggestionFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Give a suggestion/feedback'**
  String get giveSuggestionFeedbackTitle;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @bookCallSlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Call Slot'**
  String get bookCallSlotTitle;

  /// No description provided for @bookCallSlotHeading.
  ///
  /// In en, this message translates to:
  /// **'Book Call Slot for Solving Your Issue'**
  String get bookCallSlotHeading;

  /// No description provided for @importantPoint.
  ///
  /// In en, this message translates to:
  /// **'Important Point'**
  String get importantPoint;

  /// No description provided for @callSlotDescription.
  ///
  /// In en, this message translates to:
  /// **'You need to be next to your vehicle during the issue resolution. Please keep yourself free :)'**
  String get callSlotDescription;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get selectDay;

  /// No description provided for @selectTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Time Slot'**
  String get selectTimeSlot;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @slotUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Slot Unavailable'**
  String get slotUnavailable;

  /// No description provided for @slotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Slot Available'**
  String get slotAvailable;

  /// No description provided for @distanceUnitSelection.
  ///
  /// In en, this message translates to:
  /// **'Distance Unit'**
  String get distanceUnitSelection;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get miles;

  /// No description provided for @locationSharedWithMe.
  ///
  /// In en, this message translates to:
  /// **'Location shared with me'**
  String get locationSharedWithMe;

  /// No description provided for @noOneSharedLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'No one has shared their vehicle\'s location with you right now'**
  String get noOneSharedLocationTitle;

  /// No description provided for @noOneSharedLocationSub.
  ///
  /// In en, this message translates to:
  /// **'You\'ll find the names of individuals who have shared their location with you right here.'**
  String get noOneSharedLocationSub;

  /// No description provided for @vehicleRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle removed successfully'**
  String get vehicleRemovedSuccessfully;

  /// No description provided for @vehicleDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetailsLabel;

  /// No description provided for @addOneMore.
  ///
  /// In en, this message translates to:
  /// **'..add 1 more'**
  String get addOneMore;

  /// No description provided for @removeVehicleNamed.
  ///
  /// In en, this message translates to:
  /// **'Remove {vehicleName} {vehicleNumber}'**
  String removeVehicleNamed(String vehicleName, String vehicleNumber);

  /// No description provided for @removeVehicleWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: this cannot be undone. All your vehicle history will be deleted permanently.'**
  String get removeVehicleWarning;

  /// No description provided for @removeVehicle.
  ///
  /// In en, this message translates to:
  /// **'Remove Vehicle'**
  String get removeVehicle;

  /// No description provided for @removeVehicleConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this vehicle? This action cannot be undone.'**
  String get removeVehicleConfirmDesc;

  /// No description provided for @removeBtn.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeBtn;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @buyFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Buy feature coming soon...'**
  String get buyFeatureComingSoon;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @vehicleLockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Locked successfully!'**
  String get vehicleLockedSuccessfully;

  /// No description provided for @vehicleUnlockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Unlocked successfully!'**
  String get vehicleUnlockedSuccessfully;

  /// No description provided for @failedToUpdateLockStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update lock status'**
  String get failedToUpdateLockStatus;

  /// No description provided for @registerNewVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'Register a new Vehicle or Trackify Device'**
  String get registerNewVehicleDesc;

  /// No description provided for @userSessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'User session not found. Please log in again.'**
  String get userSessionNotFound;

  /// No description provided for @comingSoonOption.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoonOption;

  /// No description provided for @noDeviceFound.
  ///
  /// In en, this message translates to:
  /// **'No device found'**
  String get noDeviceFound;

  /// No description provided for @noVideosFound.
  ///
  /// In en, this message translates to:
  /// **'No videos found'**
  String get noVideosFound;

  /// No description provided for @designOption.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get designOption;

  /// No description provided for @functionalityOption.
  ///
  /// In en, this message translates to:
  /// **'Functionality'**
  String get functionalityOption;

  /// No description provided for @otherOption.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherOption;

  /// No description provided for @allFieldsMandatory.
  ///
  /// In en, this message translates to:
  /// **'ALL fields are mandatory'**
  String get allFieldsMandatory;

  /// No description provided for @selectVehicleTypeForFuel.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle type to see fuel options'**
  String get selectVehicleTypeForFuel;

  /// No description provided for @pleaseSelectFuelTypeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select fuel type first'**
  String get pleaseSelectFuelTypeFirst;

  /// No description provided for @pleaseSelectVehicleMakeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle make first'**
  String get pleaseSelectVehicleMakeFirst;

  /// No description provided for @deleteFunctionalityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Delete functionality coming soon'**
  String get deleteFunctionalityComingSoon;

  /// No description provided for @errorImeiNotFound.
  ///
  /// In en, this message translates to:
  /// **'Error: IMEI not found'**
  String get errorImeiNotFound;

  /// No description provided for @healthInsuranceSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Health insurance details saved successfully'**
  String get healthInsuranceSavedSuccess;

  /// No description provided for @noSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Slots Available'**
  String get noSlotsAvailable;

  /// No description provided for @noIntroDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No intro data available'**
  String get noIntroDataAvailable;

  /// No description provided for @retryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryBtn;

  /// No description provided for @areYouSureDeleteRefuelLog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this refuel log?'**
  String get areYouSureDeleteRefuelLog;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @noAlertsCreated.
  ///
  /// In en, this message translates to:
  /// **'No alerts created for this vehicle.'**
  String get noAlertsCreated;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change password & logout from all phones'**
  String get changePasswordSubtitle;

  /// No description provided for @currentSessions.
  ///
  /// In en, this message translates to:
  /// **'Current sessions'**
  String get currentSessions;

  /// No description provided for @manageLoggedInDevices.
  ///
  /// In en, this message translates to:
  /// **'Manage logged-in devices'**
  String get manageLoggedInDevices;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account permanently'**
  String get deleteAccountSubtitle;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @confirmNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordTitle;

  /// No description provided for @logoutOfAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Logout of all devices'**
  String get logoutOfAllDevices;

  /// No description provided for @otherDevices.
  ///
  /// In en, this message translates to:
  /// **'Other devices'**
  String get otherDevices;

  /// No description provided for @activeOnThisDevice.
  ///
  /// In en, this message translates to:
  /// **'Active on this device'**
  String get activeOnThisDevice;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used -'**
  String get lastUsed;

  /// No description provided for @osLabel.
  ///
  /// In en, this message translates to:
  /// **'OS -'**
  String get osLabel;

  /// No description provided for @chromeNotificationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Chrome notification - disabled'**
  String get chromeNotificationDisabled;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @sorryToSeeYouGo.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to see you go.'**
  String get sorryToSeeYouGo;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note:'**
  String get note;

  /// No description provided for @deleteAccountNote1.
  ///
  /// In en, this message translates to:
  /// **'After 30 days, your account will be deleted permanently.'**
  String get deleteAccountNote1;

  /// No description provided for @deleteAccountNote2.
  ///
  /// In en, this message translates to:
  /// **'You can reactivate the account within 30 Days by signing back.'**
  String get deleteAccountNote2;

  /// No description provided for @deleteAccountExplanationPrompt.
  ///
  /// In en, this message translates to:
  /// **'We would love to know why you are deleting your account, as we may be able to help with common issues. You can also just continue.'**
  String get deleteAccountExplanationPrompt;

  /// No description provided for @explanationOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Your explanation is completely optional'**
  String get explanationOptionalHint;

  /// No description provided for @deleteWarningPart1.
  ///
  /// In en, this message translates to:
  /// **'Your device will be unmapped, subscription will be '**
  String get deleteWarningPart1;

  /// No description provided for @terminated.
  ///
  /// In en, this message translates to:
  /// **'terminated'**
  String get terminated;

  /// No description provided for @deleteWarningPart2.
  ///
  /// In en, this message translates to:
  /// **' and your all data will be lost from the server after 30 days of account deletion.'**
  String get deleteWarningPart2;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get confirmDeleteAccount;
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
