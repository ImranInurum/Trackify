import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/onboarding/domain/entities/logo_entity.dart';

class LogoModel extends LogoEntity {
  const LogoModel({
    super.id,
    super.filename,
    super.path,
    super.createdAt,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    String? path = json['path'];
    if (path != null && !path.startsWith('http')) {
      final String base = ApiURL.baseURL.endsWith('/')
          ? ApiURL.baseURL.substring(0, ApiURL.baseURL.length - 1)
          : ApiURL.baseURL;
      final String cleanPath = path.startsWith('/') ? path : '/$path';
      path = "$base$cleanPath";
    }
    return LogoModel(
      id: json['_id'] ?? json['id'],
      filename: json['filename'],
      path: path,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'filename': filename,
      'path': path,
      'createdAt': createdAt,
    };
  }
}
