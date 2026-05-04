import 'package:equatable/equatable.dart';

class ServiceLogEntity extends Equatable {
  final String? id;
  final String? vehicleId;
  final String? imei;
  final String? serviceDate;
  final double? amount;
  final String? centerName;
  final String? contact;
  final String? note;
  final List<String>? billImages;
  final String? createdAt;
  final String? updatedAt;
  final bool? reminderSent;

  const ServiceLogEntity({
    this.id,
    this.vehicleId,
    this.imei,
    this.serviceDate,
    this.amount,
    this.centerName,
    this.contact,
    this.note,
    this.billImages,
    this.createdAt,
    this.updatedAt,
    this.reminderSent,
  });

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        imei,
        serviceDate,
        amount,
        centerName,
        contact,
        note,
        billImages,
        createdAt,
        updatedAt,
        reminderSent,
      ];
}
