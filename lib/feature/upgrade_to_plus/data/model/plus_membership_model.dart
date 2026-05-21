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

  factory PlusMembershipModel.fromJson(
      Map<String, dynamic> json,
      ) {

    final data = json['data'] ?? {};

    final plan = data['plan'] ?? {};

    return PlusMembershipModel(

      currentPrice:
      (plan['price'] ?? 0).toDouble(),

      originalPrice:
      (plan['originalPrice'] ?? 0).toDouble(),

      duration:
      plan['durationText'] ?? "",

      usersCountMessage:
      plan['boughtText'] ?? "",

      premiumBenefits:
      (data['premiumBenefits'] as List? ?? [])
          .map(
            (e) => PremiumBenefitModel.fromJson(e),
      )
          .toList(),

      otherBenefits:
      (data['otherBenefits'] as List? ?? [])
          .map(
            (e) => OtherBenefitModel.fromJson(e),
      )
          .toList(),

      reviews:
      (data['reviews'] as List? ?? [])
          .map(
            (e) => PlusReviewModel.fromJson(e),
      )
          .toList(),
    );
  }
}

class PremiumBenefitModel
    extends PremiumBenefitEntity {

  const PremiumBenefitModel({
    required super.title,
    required super.subtitle,
    required super.iconType,
  });

  factory PremiumBenefitModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return PremiumBenefitModel(

      title:
      json['title'] ?? "",

      subtitle:
      json['description'] ?? "",

      iconType:
      json['icon'] ?? "",
    );
  }
}

class OtherBenefitModel
    extends OtherBenefitEntity {

  const OtherBenefitModel({
    required super.title,
    required super.description,
    required super.regularValue,
    required super.plusValue,
  });

  factory OtherBenefitModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return OtherBenefitModel(

      title:
      json['offering'] ?? "",

      description:
      json['description'] ?? "",

      regularValue:
      json['regular'] ?? "",

      plusValue:
      json['plus'] ?? "",
    );
  }
}

class PlusReviewModel
    extends PlusReviewEntity {

  const PlusReviewModel({
    required super.name,
    required super.duration,
    required super.review,
    super.profileImageUrl,
  });

  factory PlusReviewModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return PlusReviewModel(

      name:
      json['name'] ?? "",

      duration:
      json['subtitle'] ?? "",

      review:
      json['review'] ?? "",

      profileImageUrl:
      json['image'],
    );
  }
}