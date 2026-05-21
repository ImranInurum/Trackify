import 'package:trackify/feature/auth/data/entity/login_response_model.dart';

class UpdateProfileResponse {
  final bool success;
  final String message;
  final User? data;

  UpdateProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      success: json['success'] is bool
          ? json['success']
          : json['success']?.toString().toLowerCase() == 'true',
      message: json['message'] ?? '',
      data: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
