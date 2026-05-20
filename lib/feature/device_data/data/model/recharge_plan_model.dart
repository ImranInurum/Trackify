import '../../domain/entity/recharge_plan_entity.dart';

class RechargePlanModel extends RechargePlanEntity {
  const RechargePlanModel({
    required super.id,
    required super.planName,
    required super.durationMonths,
    required super.validityText,
    required super.price,
    required super.originalPrice,
    required super.gstApplicable,
    required super.isSuperCombo,
    required super.tagText,
    required super.savingText,
    required super.popularText,
    required super.features,
  });

  factory RechargePlanModel.fromJson(Map<String, dynamic> json) {
    return RechargePlanModel(
      id: json['_id'] as String? ?? '',
      planName: json['planName'] as String? ?? '',
      durationMonths: json['durationMonths'] as int? ?? 0,
      validityText: json['validityText'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      gstApplicable: json['gstApplicable'] as bool? ?? false,
      isSuperCombo: json['isSuperCombo'] as bool? ?? false,
      tagText: json['tagText'] as String? ?? '',
      savingText: json['savingText'] as String? ?? '',
      popularText: json['popularText'] as String? ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
      'durationMonths': durationMonths,
      'validityText': validityText,
      'price': price,
      'originalPrice': originalPrice,
      'gstApplicable': gstApplicable,
      'isSuperCombo': isSuperCombo,
      'tagText': tagText,
      'savingText': savingText,
      'popularText': popularText,
      'features': features,
    };
  }
}
