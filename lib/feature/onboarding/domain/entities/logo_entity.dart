import 'package:equatable/equatable.dart';

class LogoEntity extends Equatable {
  final String? id;
  final String? filename;
  final String? path;
  final String? createdAt;

  const LogoEntity({
    this.id,
    this.filename,
    this.path,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, filename, path, createdAt];
}
