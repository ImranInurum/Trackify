import 'package:trackify/feature/onboarding/domain/entities/logo_entity.dart';

class LogoModel extends LogoEntity {
  const LogoModel({
    super.id,
    super.filename,
    super.path,
    super.createdAt,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    return LogoModel(
      id: json['_id'],
      filename: json['filename'],
      path: json['path'],
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
