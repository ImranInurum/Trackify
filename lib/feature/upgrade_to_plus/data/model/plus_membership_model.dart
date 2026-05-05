import '../../domain/entity/plus_membership_entity.dart';

class PlusMembershipModel extends PlusMembershipEntity {
  const PlusMembershipModel({
    required super.currentPrice,
    required super.originalPrice,
    required super.duration,
    required super.usersCountMessage,
    required super.premiumBenefits,
    required super.otherBenefits,
    required super.reviews,
  });

  factory PlusMembershipModel.fromJson(Map<String, dynamic> json) {
    return PlusMembershipModel(
      currentPrice: (json['current_price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num).toDouble(),
      duration: json['duration'] as String,
      usersCountMessage: json['users_count_message'] as String,
      premiumBenefits: (json['premium_benefits'] as List)
          .map((e) => PremiumBenefitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherBenefits: (json['other_benefits'] as List)
          .map((e) => OtherBenefitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List)
          .map((e) => PlusReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PremiumBenefitModel extends PremiumBenefitEntity {
  const PremiumBenefitModel({
    required super.title,
    required super.subtitle,
    required super.iconType,
  });

  factory PremiumBenefitModel.fromJson(Map<String, dynamic> json) {
    return PremiumBenefitModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      iconType: json['icon_type'] as String,
    );
  }
}

class OtherBenefitModel extends OtherBenefitEntity {
  const OtherBenefitModel({
    required super.title,
    required super.description,
    required super.regularValue,
    required super.plusValue,
  });

  factory OtherBenefitModel.fromJson(Map<String, dynamic> json) {
    return OtherBenefitModel(
      title: json['title'] as String,
      description: json['description'] as String,
      regularValue: json['regular_value'] as String,
      plusValue: json['plus_value'] as String,
    );
  }
}

class PlusReviewModel extends PlusReviewEntity {
  const PlusReviewModel({
    required super.name,
    required super.duration,
    required super.review,
    super.profileImageUrl,
  });

  factory PlusReviewModel.fromJson(Map<String, dynamic> json) {
    return PlusReviewModel(
      name: json['name'] as String,
      duration: json['duration'] as String,
      review: json['review'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }
}
