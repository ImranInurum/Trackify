import 'package:equatable/equatable.dart';

class RechargePlanEntity extends Equatable {
  final String id;
  final String planName;
  final int durationMonths;
  final String validityText;
  final double price;
  final double originalPrice;
  final bool gstApplicable;
  final bool isSuperCombo;
  final String tagText;
  final String savingText;
  final String popularText;
  final List<String> features;

  const RechargePlanEntity({
    required this.id,
    required this.planName,
    required this.durationMonths,
    required this.validityText,
    required this.price,
    required this.originalPrice,
    required this.gstApplicable,
    required this.isSuperCombo,
    required this.tagText,
    required this.savingText,
    required this.popularText,
    required this.features,
  });

  @override
  List<Object?> get props => [
        id,
        planName,
        durationMonths,
        validityText,
        price,
        originalPrice,
        gstApplicable,
        isSuperCombo,
        tagText,
        savingText,
        popularText,
        features,
      ];
}
