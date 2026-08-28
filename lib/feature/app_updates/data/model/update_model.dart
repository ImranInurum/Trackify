import 'package:trackify/feature/app_updates/domain/entity/update_entity.dart';

class UpdateModel extends UpdateEntity {

  UpdateModel({
    required super.date,
    required super.version,
    required super.titles,
    required super.descriptions,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title']?.toString().trim() ?? '';
    final rawDesc = json['description']?.toString().trim() ?? '';

    List<String> titlesList = [];
    if (json['titles'] != null && json['titles'] is List && (json['titles'] as List).isNotEmpty) {
      titlesList = (json['titles'] as List).map((e) => e.toString()).where((s) => s.trim().isNotEmpty).toList();
    }
    if (titlesList.isEmpty) {
      titlesList = [rawTitle.isNotEmpty ? rawTitle : "🚀 App Enhancement Update"];
    }

    List<String> descList = [];
    if (json['descriptions'] != null && json['descriptions'] is List && (json['descriptions'] as List).isNotEmpty) {
      descList = (json['descriptions'] as List).map((e) => e.toString()).where((s) => s.trim().isNotEmpty).toList();
    }
    if (descList.isEmpty) {
      descList = [rawDesc.isNotEmpty ? rawDesc : "General performance optimizations and bug fixes for a smoother experience."];
    }

    return UpdateModel(
      date: json['releaseDateText']?.toString() ?? "",
      version: json['version']?.toString() ?? "",
      titles: titlesList,
      descriptions: descList,
    );
  }
}