import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

class AppleAuthResult {
  final String userIdentifier;
  final String email;
  final String name;
  final String? identityToken;
  final String? authorizationCode;

  AppleAuthResult({
    required this.userIdentifier,
    required this.email,
    required this.name,
    this.identityToken,
    this.authorizationCode,
  });
}

class AppleAuthService {
  static final AppleAuthService instance = AppleAuthService._();
  AppleAuthService._();

  /// Initiates the native Apple Sign-In flow
  Future<AppleAuthResult?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final userIdentifier = credential.userIdentifier ?? '';
      if (userIdentifier.isEmpty) return null;

      // Apple only returns name and email on the very FIRST sign-in attempt.
      // We persist them so subsequent logins still have access if needed.
      final prefs = AppPreference.instance;
      String email = credential.email ?? '';
      String name = [
        credential.givenName ?? '',
        credential.familyName ?? '',
      ].where((s) => s.trim().isNotEmpty).join(' ').trim();

      const appleEmailKey = 'apple_saved_email_';
      const appleNameKey = 'apple_saved_name_';

      if (email.isNotEmpty) {
        await prefs.set(key: '$appleEmailKey$userIdentifier', value: email);
      } else {
        email = prefs.getSync(key: '$appleEmailKey$userIdentifier');
      }

      if (name.isNotEmpty) {
        await prefs.set(key: '$appleNameKey$userIdentifier', value: name);
      } else {
        name = prefs.getSync(key: '$appleNameKey$userIdentifier');
        if (name.isEmpty) name = 'Apple User';
      }

      return AppleAuthResult(
        userIdentifier: userIdentifier,
        email: email,
        name: name,
        identityToken: credential.identityToken,
        authorizationCode: credential.authorizationCode,
      );
    } catch (error) {
      debugPrint('Apple Sign-In Error: $error');
      return null;
    }
  }
}
