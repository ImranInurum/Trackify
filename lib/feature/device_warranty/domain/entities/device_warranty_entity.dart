import 'package:equatable/equatable.dart';

class DeviceWarrantyEntity extends Equatable {
  final DeviceWarrantyVehicleEntity? vehicle;
  final DeviceWarrantyDetailsEntity? warranty;
  final DeviceWarrantyOfferEntity? offer;

  const DeviceWarrantyEntity({
    this.vehicle,
    this.warranty,
    this.offer,
  });

  @override
  List<Object?> get props => [vehicle, warranty, offer];
}

class DeviceWarrantyVehicleEntity extends Equatable {
  final String id;
  final String imei;
  final String vehicleName;
  final String vehicleNumber;
  final String displayName;

  const DeviceWarrantyVehicleEntity({
    required this.id,
    required this.imei,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.displayName,
  });

  @override
  List<Object?> get props => [id, imei, vehicleName, vehicleNumber, displayName];
}

class DeviceWarrantyDetailsEntity extends Equatable {
  final String expiryDate;
  final String expiryDateText;
  final int daysLeft;
  final String daysLeftText;

  const DeviceWarrantyDetailsEntity({
    required this.expiryDate,
    required this.expiryDateText,
    required this.daysLeft,
    required this.daysLeftText,
  });

  @override
  List<Object?> get props => [expiryDate, expiryDateText, daysLeft, daysLeftText];
}

class DeviceWarrantyOfferEntity extends Equatable {
  final String planId;
  final String planName;
  final int durationMonths;
  final String title;
  final String subtitle;
  final String productName;
  final String productImage;
  final double originalPrice;
  final double offerPrice;
  final String buttonText;
  final List<DeviceWarrantyBenefitEntity> benefits;

  const DeviceWarrantyOfferEntity({
    required this.planId,
    required this.planName,
    required this.durationMonths,
    required this.title,
    required this.subtitle,
    required this.productName,
    required this.productImage,
    required this.originalPrice,
    required this.offerPrice,
    required this.buttonText,
    required this.benefits,
  });

  @override
  List<Object?> get props => [
        planId,
        planName,
        durationMonths,
        title,
        subtitle,
        productName,
        productImage,
        originalPrice,
        offerPrice,
        buttonText,
        benefits,
      ];
}

class DeviceWarrantyBenefitEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;

  const DeviceWarrantyBenefitEntity({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, subtitle];
}
