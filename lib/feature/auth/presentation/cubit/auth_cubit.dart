import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../../core/utils/shared_preferences.dart';
import '../../../../core/widgets/loading_screen_ol.dart';
import '../../domain/usecase/auth_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthCase _authCase;

  AuthCubit(this._authCase) : super(AuthInitial());

  Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceModel = 'Unknown Device';
    String osVersion = 'Unknown OS';

    try {
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          final manufacturer = androidInfo.manufacturer.isNotEmpty ? androidInfo.manufacturer : '';
          final model = androidInfo.model.isNotEmpty ? androidInfo.model : '';
          deviceModel = '$manufacturer $model'.trim();
          if (deviceModel.isEmpty) deviceModel = 'Android Device';
          osVersion = 'Android ${androidInfo.version.release}';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.name.isNotEmpty ? iosInfo.name : (iosInfo.model.isNotEmpty ? iosInfo.model : 'iPhone');
          osVersion = 'iOS ${iosInfo.systemVersion}';
        } else if (Platform.isWindows) {
          final windowsInfo = await deviceInfo.windowsInfo;
          deviceModel = windowsInfo.computerName.isNotEmpty ? windowsInfo.computerName : 'Windows PC';
          osVersion = 'Windows ${windowsInfo.majorVersion}.${windowsInfo.minorVersion}';
        }
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
    }

    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
    };
  }

  Future<void> loginUser(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final devInfo = await _getDeviceInfo();
      body['deviceModel'] = devInfo['deviceModel'];
      body['osVersion'] = devInfo['osVersion'];
      
      var fcmToken = await AppPreference.instance.get(key: AppPreference.KEY_FCM_TOKEN);
      if (fcmToken.isEmpty) {
        try {
          fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
          if (fcmToken.isNotEmpty) {
            await AppPreference.instance.set(key: AppPreference.KEY_FCM_TOKEN, value: fcmToken);
          }
        } catch (e) {
          debugPrint('Error fetching FCM token: $e');
        }
      }
      body['fcmToken'] = fcmToken;


      final result = await _authCase.loginCall(body);
      await result.fold(
        (failure) async {
          emit(AuthFailure(failure));
        },
        (user) async {
          final prefs = AppPreference.instance;
          await prefs.set(
            key: AppPreference.KEY_TOKEN,
            value: user.token ?? "",
          );
          await prefs.set(
            key: AppPreference.KEY_USER_ID,
            value: user.user?.id ?? "",
          );
          await prefs.set(
            key: AppPreference.KEY_USER_DETAILS,
            value: jsonEncode(user.user?.toJson()),
          );
          ApiURL.updateAuthToken(user.token ?? "");
          await _updateFcmToken(user.user?.id ?? "");
          emit(AuthSuccess(user));
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> registerUser(Map<String, dynamic> body) async {
    emit(AuthLoading());
    final result = await _authCase.registerCall(body);
    result.fold(
      (failure) => emit(AuthFailure(failure)),
      (user) => emit(RegisterSuccess()),
    );
  }

  Future<void> sendOtp(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.sendOtpCall(body);
      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (data) {
          emit(ForgotPasswordOtpSent());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> verifyOtp(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.verifyOtpCall(body);
      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (data) {
          emit(ForgotPasswordOtpVerified());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> resetPassword(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(AuthLoading());
    try {
      final result = await _authCase.resetPasswordCall(body);
      result.fold(
        (failure) {
          emit(AuthFailure(failure));
        },
        (data) {
          emit(ForgotPasswordResetSuccess());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final userCredential = await GoogleAuthService.instance
          .signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        final firebaseUser = userCredential.user!;

        final devInfo = await _getDeviceInfo();
        var fcmToken = await AppPreference.instance.get(key: AppPreference.KEY_FCM_TOKEN);
        if (fcmToken.isEmpty) {
          try {
            fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
            if (fcmToken.isNotEmpty) {
              await AppPreference.instance.set(key: AppPreference.KEY_FCM_TOKEN, value: fcmToken);
            }
          } catch (e) {
            debugPrint('Error fetching FCM token: $e');
          }
        }

        final body = {
          "name": firebaseUser.displayName ?? "Google User",
          "email": firebaseUser.email,
          "socialId": firebaseUser.uid,
          "deviceModel": devInfo['deviceModel'],
          "osVersion": devInfo['osVersion'],
          "fcmToken": fcmToken,
        };

        final result = await _authCase.socialLoginCall(body);

        result.fold(
          (failure) {
            emit(AuthFailure(failure));
          },
          (user) async {
            final prefs = AppPreference.instance;
            await prefs.set(
              key: AppPreference.KEY_TOKEN,
              value: user.token ?? "",
            );
            await prefs.set(
              key: AppPreference.KEY_USER_ID,
              value: user.user?.id ?? "",
            );
            await prefs.set(
              key: AppPreference.KEY_USER_DETAILS,
              value: jsonEncode(user.user?.toJson()),
            );
            ApiURL.updateAuthToken(user.token ?? "");

            await _updateFcmToken(user.user?.id ?? "");

            emit(AuthSuccess(user));
          },
        );
      } else {}
    } catch (e) {
      print("Google Login Failed ${e.toString()}");
    }
  }

  Future<void> _updateFcmToken(String userId) async {
    try {
      final fcmToken = await AppPreference.instance.get(
        key: AppPreference.KEY_FCM_TOKEN,
      );
      if (fcmToken.isNotEmpty && userId.isNotEmpty) {
        final body = {"userId": userId, "fcmToken": fcmToken};
        final result = await _authCase.saveFcmTokenCall(body);
        result.fold(
          (failure) => print('Failed to save FCM token: $failure'),
          (data) => print('FCM token saved successfully: $data'),
        );
      } else {
        print(
          'FCM token or userId is empty, skipping save. FCM: $fcmToken, UID: $userId',
        );
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<void> changePassword(Map<String, dynamic> body) async {
    LoadingScreenOL().show();
    emit(ChangePasswordLoading());
    try {
      final result = await _authCase.changePasswordCall(body);
      result.fold(
        (failure) {
          emit(ChangePasswordFailure(failure));
        },
        (data) {
          emit(ChangePasswordSuccess());
        },
      );
    } finally {
      LoadingScreenOL().hide();
    }
  }
}
