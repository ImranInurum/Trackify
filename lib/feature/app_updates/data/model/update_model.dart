import 'package:trackify/feature/app_updates/domain/entity/update_entity.dart';

class UpdateModel extends UpdateEntity{
  UpdateModel({
    required super.date,
    required super.version,
    required super.titles,
    required super.descriptions
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json){
    return UpdateModel(
        date: json['date'],
        version: json['version'],
        titles: json['titles'],
        descriptions: json['descriptions']
    );

  }




}