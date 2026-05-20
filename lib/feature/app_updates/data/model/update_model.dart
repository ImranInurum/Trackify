import 'package:trackify/feature/app_updates/domain/entity/update_entity.dart';

class UpdateModel extends UpdateEntity {

  UpdateModel({
    required super.date,
    required super.version,
    required super.titles,
    required super.descriptions,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {

    return UpdateModel(
      date: json['releaseDateText']?.toString() ?? "",

      version: json['version']?.toString() ?? "",

      titles: [
        json['title']?.toString() ?? "",
      ],

      descriptions: [
        json['description']?.toString() ?? "",
      ],
    );
  }
}