import '../../domain/entities/device_warranty_entity.dart';

class DeviceWarrantyModel extends DeviceWarrantyEntity {
  const DeviceWarrantyModel({
    super.vehicle,
    super.warranty,
    super.offer,
  });

  factory DeviceWarrantyModel.fromJson(Map<String, dynamic> json) {
    final vehicleJson = json['vehicle'] ?? json['vehicleInfo'] ?? json['device'];
    final warrantyJson = json['warranty'] ?? json['currentWarranty'] ?? json['deviceWarranty'];
    final offerJson = json['offer'] ?? json['warrantyPlan'] ?? json['plan'] ?? json['upgradePlan'];

    return DeviceWarrantyModel(
      vehicle: vehicleJson != null
          ? DeviceWarrantyVehicleModel.fromJson(vehicleJson as Map<String, dynamic>)
          : null,
      warranty: warrantyJson != null
          ? DeviceWarrantyDetailsModel.fromJson(warrantyJson as Map<String, dynamic>)
          : null,
      offer: offerJson != null
          ? DeviceWarrantyOfferModel.fromJson(offerJson as Map<String, dynamic>)
          : null,
    );
  }
}

class DeviceWarrantyVehicleModel extends DeviceWarrantyVehicleEntity {
  const DeviceWarrantyVehicleModel({
    required super.id,
    required super.imei,
    required super.vehicleName,
    required super.vehicleNumber,
    required super.displayName,
  });

  factory DeviceWarrantyVehicleModel.fromJson(Map<String, dynamic> json) {
    final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    final imei = json['imei']?.toString() ?? '';
    final vehicleName = json['vehicleName']?.toString() ?? json['vehicle_name'] ?? json['name']?.toString() ?? '';
    final vehicleNumber = json['vehicleNumber']?.toString() ?? json['vehicle_number'] ?? json['number']?.toString() ?? '';
    
    final maker = json['vehicleMaker']?.toString() ?? json['vehicle_maker'] ?? json['maker']?.toString() ?? '';
    final model = json['vehicleModel']?.toString() ?? json['vehicle_model'] ?? json['model']?.toString() ?? '';
    
    String parsedVehicleName = vehicleName;
    if (parsedVehicleName.isEmpty && (maker.isNotEmpty || model.isNotEmpty)) {
      parsedVehicleName = '$maker $model'.trim();
    }
    
    String parsedDisplayName = json['displayName']?.toString() ?? json['display_name']?.toString() ?? '';
    if (parsedDisplayName.isEmpty) {
      parsedDisplayName = parsedVehicleName.isNotEmpty ? parsedVehicleName : vehicleNumber;
    }

    return DeviceWarrantyVehicleModel(
      id: id,
      imei: imei,
      vehicleName: parsedVehicleName.isNotEmpty ? parsedVehicleName : vehicleNumber,
      vehicleNumber: vehicleNumber,
      displayName: parsedDisplayName,
    );
  }
}

class DeviceWarrantyDetailsModel extends DeviceWarrantyDetailsEntity {
  const DeviceWarrantyDetailsModel({
    required super.expiryDate,
    required super.expiryDateText,
    required super.daysLeft,
    required super.daysLeftText,
  });

  factory DeviceWarrantyDetailsModel.fromJson(Map<String, dynamic> json) {
    final expiryDate = json['expiryDate']?.toString() ?? 
                       json['expiry_date']?.toString() ?? 
                       json['expiresAt']?.toString() ?? 
                       json['end_date']?.toString() ?? '';
    
    final daysLeftVal = json['daysLeft'] ?? json['days_left'] ?? json['remainingDays'] ?? json['remaining_days'];
    int daysLeft = (daysLeftVal is num) ? daysLeftVal.toInt() : (int.tryParse(daysLeftVal?.toString() ?? '') ?? 0);
    
    if (expiryDate.isNotEmpty) {
      try {
        final expiry = DateTime.parse(expiryDate);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
        final diff = expiryDay.difference(today).inDays;
        if (diff >= 0) {
          daysLeft = diff;
        }
      } catch (_) {}
    }

    String expiryDateText = json['expiryDateText']?.toString() ?? json['expiry_date_text']?.toString() ?? '';
    if (expiryDateText.isEmpty && expiryDate.isNotEmpty) {
      try {
        final date = DateTime.parse(expiryDate);
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        expiryDateText = "${date.day} ${months[date.month - 1]} ${date.year}";
      } catch (_) {
        expiryDateText = expiryDate.split('T').first;
      }
    }
    
    String daysLeftText = json['daysLeftText']?.toString() ?? json['days_left_text']?.toString() ?? '';
    if (daysLeftText.isEmpty || daysLeftText.contains('Days Left') || daysLeftText.contains('days left')) {
      daysLeftText = "$daysLeft days left";
    }

    return DeviceWarrantyDetailsModel(
      expiryDate: expiryDate,
      expiryDateText: expiryDateText,
      daysLeft: daysLeft,
      daysLeftText: daysLeftText,
    );
  }
}

class DeviceWarrantyOfferModel extends DeviceWarrantyOfferEntity {
  const DeviceWarrantyOfferModel({
    required super.planId,
    required super.planName,
    required super.durationMonths,
    required super.title,
    required super.subtitle,
    required super.productName,
    required super.productImage,
    required super.originalPrice,
    required super.offerPrice,
    required super.buttonText,
    required super.benefits,
  });

  factory DeviceWarrantyOfferModel.fromJson(Map<String, dynamic> json) {
    final planId = json['planId']?.toString() ?? json['plan_id']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString() ?? '';
    final planName = json['planName']?.toString() ?? json['plan_name']?.toString() ?? json['name']?.toString() ?? '';
    
    final durationMonthsVal = json['durationMonths'] ?? json['duration_months'] ?? json['months'] ?? json['validity'];
    final durationMonths = (durationMonthsVal is num) ? durationMonthsVal.toInt() : (int.tryParse(durationMonthsVal?.toString() ?? '') ?? 0);
    
    final title = json['title']?.toString() ?? '';
    final subtitle = json['subtitle']?.toString() ?? '';
    final productName = json['productName']?.toString() ?? json['product_name']?.toString() ?? json['product']?.toString() ?? '';
    final productImage = json['productImage']?.toString() ?? json['product_image']?.toString() ?? json['image']?.toString() ?? '';
    
    final originalPriceVal = json['originalPrice'] ?? json['original_price'] ?? json['price'];
    final originalPrice = (originalPriceVal is num) ? originalPriceVal.toDouble() : (double.tryParse(originalPriceVal?.toString() ?? '') ?? 0.0);
    
    final offerPriceVal = json['offerPrice'] ?? json['offer_price'] ?? json['discountPrice'] ?? json['discount_price'] ?? json['price'];
    final offerPrice = (offerPriceVal is num) ? offerPriceVal.toDouble() : (double.tryParse(offerPriceVal?.toString() ?? '') ?? 0.0);
    
    final buttonText = json['buttonText']?.toString() ?? json['button_text']?.toString() ?? '';
    
    var benefitsList = json['benefits'] ?? json['benefit'] ?? json['features'];
    List<DeviceWarrantyBenefitModel> parsedBenefits = [];
    if (benefitsList is List) {
      parsedBenefits = benefitsList
          .map((item) => DeviceWarrantyBenefitModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return DeviceWarrantyOfferModel(
      planId: planId,
      planName: planName,
      durationMonths: durationMonths,
      title: title,
      subtitle: subtitle,
      productName: productName,
      productImage: productImage,
      originalPrice: originalPrice,
      offerPrice: offerPrice,
      buttonText: buttonText,
      benefits: parsedBenefits,
    );
  }
}

class DeviceWarrantyBenefitModel extends DeviceWarrantyBenefitEntity {
  const DeviceWarrantyBenefitModel({
    required super.id,
    required super.title,
    required super.subtitle,
  });

  factory DeviceWarrantyBenefitModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final title = json['title']?.toString() ?? '';
    final subtitle = json['subtitle']?.toString() ?? json['description']?.toString() ?? '';

    return DeviceWarrantyBenefitModel(
      id: id,
      title: title,
      subtitle: subtitle,
    );
  }
}
