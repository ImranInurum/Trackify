import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';

class AddFuelModel extends AddFuelEntity {

  AddFuelModel({
    required super.vehicle,
    required super.dateTime,
    required super.fuelStation,
    required super.amount,
    required super.odometer,
    required super.fullTank,
    required super.pricePerLitre,
  });

  factory AddFuelModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return AddFuelModel(
      vehicle: map['vehicle'] ?? '',
      dateTime: DateTime.parse(
        map['dateTime'],
      ),
      fuelStation: map['fuelStation'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      odometer: map['odometer'] ?? 0,
      fullTank: map['fullTank'] ?? false,
      pricePerLitre:
      (map['pricePerLitre'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle': vehicle,
      'dateTime': dateTime.toIso8601String(),
      'fuelStation': fuelStation,
      'amount': amount,
      'odometer': odometer,
      'fullTank': fullTank,
      'pricePerLitre': pricePerLitre,
    };
  }
}