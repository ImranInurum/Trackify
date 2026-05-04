import '../../domain/entities/service_log_entity.dart';

class ServiceLogModel extends ServiceLogEntity {
  const ServiceLogModel({
    super.id,
    super.vehicleId,
    super.imei,
    super.serviceDate,
    super.amount,
    super.centerName,
    super.contact,
    super.note,
    super.billImages,
    super.createdAt,
    super.updatedAt,
    super.reminderSent,
  });

  factory ServiceLogModel.fromJson(Map<String, dynamic> json) {
    return ServiceLogModel(
      id: json['_id'],
      vehicleId: json['vehicle_id'],
      imei: json['imei'],
      serviceDate: json['service_date'],
      amount: (json['billing_amount'] as num?)?.toDouble(),
      centerName: json['service_center_name'],
      contact: json['service_center_contact'],
      note: json['additional_note'],
      billImages: json['service_bill_image'] != null 
          ? (json['service_bill_image'] is List 
              ? List<String>.from(json['service_bill_image']) 
              : [json['service_bill_image'].toString()])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      reminderSent: json['reminder_sent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'imei': imei,
      'service_date': serviceDate,
      'billing_amount': amount,
      'service_center_name': centerName,
      'service_center_contact': contact,
      'additional_note': note,
      'service_bill_image': (billImages != null && billImages!.isNotEmpty) 
          ? billImages!.first 
          : null,
    };
  }
}
