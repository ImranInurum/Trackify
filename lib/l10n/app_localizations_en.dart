// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select your language';

  @override
  String get letsGetStarted => 'Let\'s Get Started';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailHint => 'example@test.com';

  @override
  String get passwordHint => '******';

  @override
  String get emailRequired => 'Email required';

  @override
  String get passwordRequired => 'Password required';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'or';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String welcome(String email) {
    return 'Welcome $email!';
  }

  @override
  String get loginFailed => 'Login failed';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'John Doe';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get role => 'Role';

  @override
  String get roleRequired => 'Please select a role';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerSuccess => 'User Registered Successfully Please Login';

  @override
  String get signUpFailed => 'Sign up failed';

  @override
  String get otpSent => 'OTP sent successfully';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get otpVerified => 'OTP verified successfully';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get otpHeader => 'OTP Verification';

  @override
  String otpDesc(String email) {
    return 'Enter the OTP sent to $email.';
  }

  @override
  String get otp => 'OTP';

  @override
  String get otpHint => '123456';

  @override
  String get otpRequired => 'OTP is required';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get passwordDesc =>
      'Your new password must be different from previous used passwords.';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter your new password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your new password';

  @override
  String get confirmPasswordRequired => 'Confirm Password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get selectDevice => 'Select Device';

  @override
  String get noDevicesFound => 'No devices found.';

  @override
  String get proceed => 'Proceed';

  @override
  String get unknownDevice => 'Unknown Device';

  @override
  String imeiLabel(String imei) {
    return 'IMEI: $imei';
  }

  @override
  String get initializeFetch => 'Initialize to fetch devices.';

  @override
  String get recordRide => 'Record Ride';

  @override
  String get phoneAsGps => 'Make your phone a GPS Tracking device';

  @override
  String get goToDashboard => 'Go to Dashboard';

  @override
  String get seeFullMap => 'See full map';

  @override
  String get exploreMore => 'Explore More';

  @override
  String get reachMeSticker => 'ReachMe Sticker';

  @override
  String get products => 'Products';

  @override
  String get fuelLogs => 'Fuel Logs';

  @override
  String get locationSharing => 'Location Sharing';

  @override
  String get documentFolder => 'Document Folder';

  @override
  String get voiceMonitoring => 'Voice Monitoring';

  @override
  String get remoteEngineOff => 'Remote Engine OFF';

  @override
  String get networkBooster => 'Network Booster';

  @override
  String get emergency => 'Emergency';

  @override
  String get overspeedAlert => 'Overspeed Alert';

  @override
  String get geoFenceAlert => 'Geo-fence Alert';

  @override
  String get more => 'More';

  @override
  String get profile => 'Profile';

  @override
  String get bikeSmartMsg =>
      '1000+ people made their bike smart with our device';

  @override
  String get features => 'Features';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsDesc => 'Got questions? We are here to help.';

  @override
  String get userReviews => 'User Reviews';

  @override
  String get accidentAlert => 'Accident Alert';

  @override
  String get antiTheftAlert => 'Anti-Theft Alert';

  @override
  String get geoFence => 'Geo Fence';

  @override
  String get statistics => 'Statistics';

  @override
  String get myGarage => 'My Garage';

  @override
  String get noVehiclesInGarage => 'No vehicles found in your garage.';

  @override
  String get unknownVehicle => 'Unknown Vehicle';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get subscription => 'Subscription';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String get initializeGarage => 'Initialize to fetch your garage.';

  @override
  String get ourProducts => 'Our Products';

  @override
  String get proTitle => 'Trackify Pro';

  @override
  String get proSubtitle => 'Advanced tracking with max features';

  @override
  String get goTitle => 'Trackify Go';

  @override
  String get goSubtitle => 'Standard tracking for everyday use';

  @override
  String get liteTitle => 'Trackify Lite';

  @override
  String get liteSubtitle => 'Basic locator device';

  @override
  String get realTime1s => 'Real-time 1s tracking';

  @override
  String get remoteEngineCutOff => 'Remote engine cut-off';

  @override
  String get detailedFuelAnalytics => 'Detailed Fuel Analytics';

  @override
  String get realTime5s => 'Real-time 5s tracking';

  @override
  String get antiTheftAlerts => 'Anti-theft alerts';

  @override
  String get basicJourneyLogs => 'Basic journey logs';

  @override
  String get locationUpdates => 'Location updates';

  @override
  String get batteryMonitor => 'Battery monitor';

  @override
  String get featuresLabel => 'Features:';

  @override
  String addedToCart(String title) {
    return 'Added $title to cart!';
  }

  @override
  String get buyNow => 'Buy Now';

  @override
  String get retry => 'Retry';

  @override
  String errorMsg(String message) {
    return 'Error: $message';
  }
}
