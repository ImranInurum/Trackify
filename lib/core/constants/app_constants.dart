class AppStrings {
  // Add Vehicle Screen
  static const String addVehicleTitle = 'Add Vehicle/Device';
  static const String vehicleType = 'Vehicle Type';
  static const String twoWheeler = 'Two Wheeler';
  static const String fourWheeler = 'Four Wheeler';
  static const String autoRickshaw = 'Auto Rickshaw';
  static const String heavyVehicle = 'Heavy Vehicle';
  static const String fuelType = 'Fuel Type';
  static const String petrol = 'Petrol';
  static const String electric = 'Electric';
  static const String vehicleMake = 'Vehicle Make';
  static const String vehicleModel = 'Vehicle Model';
  static const String vehicleNumber = 'Vehicle number';
  static const String vehicleNumberHint = 'e.g. MP46MX0743';
  static const String vehicleAddedSuccess = 'Vehicle added successfully!';
  static const String enterVehicleNumber = 'Please enter vehicle number';
  static const String selectMakeHint = 'Select Vehicle Make';
  static const String selectModelHint = 'Select Vehicle Model';

  // Choice Selector Screen
  static const String installDeviceTitle = 'Install Trackify Device';
  static const String installDeviceSubtitle =
      'Quickly set up your Trackify smart device with simple steps';
  static const String activateStickerTitle = 'Activate Contact Sticker';
  static const String activateStickerSubtitle =
      'Simple steps to quickly activate your contact sticker';
  static const String exploreAppTitle = 'Explore Our Free App';
  static const String exploreAppSubtitle =
      'Record rides using phone manually & keep track of it using our free app curated for you';
  static const String logout = 'Logout';

  // Forgot Password Screen
  static const String resetPasswordDesc = 'Enter your email address and we will send you a link to reset your password.';
  static const String sendResetLink = 'Send Reset Link';
  static const String otpSentSuccess = 'OTP sent successfully';
  static const String emailLabel = 'Email';
  static const String emailHint = 'example@test.com';
  static const String emailRequired = 'Email required';
  static const String invalidEmail = 'Please enter a valid email address';

  // OTP Verification Screen
  static const String otpVerifiedSuccess = 'OTP verified successfully';
  static String otpDesc(String email) => 'Enter the OTP sent to $email.';
  static const String otpLabel = 'OTP';
  static const String otpHint = '123456';
  static const String otpRequired = 'OTP is required';
  static const String verifyOtp = 'Verify OTP';

  // Reset Password Screen
  static const String passwordResetSuccess = 'Password reset successfully';
  static const String passwordDesc = 'Your new password must be different from previous used passwords.';
  static const String newPasswordLabel = 'New Password';
  static const String newPasswordHint = 'Enter your new password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Confirm your new password';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String resetPassword = 'Reset Password';
  static const String passwordRequired = 'Password required';
  static const String passwordMinLength = 'Password must be at least 6 characters';

  // Sign In Screen
  static String welcome(String email) => 'Welcome $email!';
  static const String loginFailed = 'Login failed';
  static const String passwordLabel = 'Password';
  static const String passwordHint = '******';
  static const String forgotPassword = 'Forgot Password?';
  static const String signIn = 'Sign In';
  static const String orDivider = 'or';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUp = 'Sign Up';

  // Sign Up Screen
  static const String registerSuccess = 'User Registered Successfully Please Login';
  static const String signUpFailed = 'Sign up failed';
  static const String nameLabel = 'Name';
  static const String nameHint = 'John Doe';
  static const String nameRequired = 'Name is required';
  static const String roleLabel = 'Role';
  static const String roleRequired = 'Please select a role';
  static const String selectRoleHint = 'Select Role';
  static const String createAccount = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account?';
}
