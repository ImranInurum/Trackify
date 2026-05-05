import 'package:equatable/equatable.dart';

class PlusMembershipEntity extends Equatable {
  final double currentPrice;
  final double originalPrice;
  final String duration;
  final String usersCountMessage;
  final List<PremiumBenefitEntity> premiumBenefits;
  final List<OtherBenefitEntity> otherBenefits;
  final List<PlusReviewEntity> reviews;

  const PlusMembershipEntity({
    required this.currentPrice,
    required this.originalPrice,
    required this.duration,
    required this.usersCountMessage,
    required this.premiumBenefits,
    required this.otherBenefits,
    required this.reviews,
  });

  @override
  List<Object?> get props => [
    currentPrice,
    originalPrice,
    duration,
    usersCountMessage,
    premiumBenefits,
    otherBenefits,
    reviews,
  ];
}

class PremiumBenefitEntity extends Equatable {
  final String title;
  final String subtitle;
  final String iconType; // e.g., 'speed', 'car', 'parking', 'stats'

  const PremiumBenefitEntity({
    required this.title,
    required this.subtitle,
    required this.iconType,
  });

  @override
  List<Object?> get props => [title, subtitle, iconType];
}

class OtherBenefitEntity extends Equatable {
  final String title;
  final String description;
  final String regularValue;
  final String plusValue;

  const OtherBenefitEntity({
    required this.title,
    required this.description,
    required this.regularValue,
    required this.plusValue,
  });

  @override
  List<Object?> get props => [title, description, regularValue, plusValue];
}

class PlusReviewEntity extends Equatable {
  final String name;
  final String duration;
  final String review;
  final String? profileImageUrl;

  const PlusReviewEntity({
    required this.name,
    required this.duration,
    required this.review,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [name, duration, review, profileImageUrl];
}
