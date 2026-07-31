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
    required super.fuelBeforeRefuel,
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
      fullTank: map['fullTank'] ?? 1,
      pricePerLitre:
      (map['pricePerLitre'] ?? 0).toDouble(),
      fuelBeforeRefuel:
      (map['fuelBeforeRefuel'] ?? "0"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicle,
      'refuelDate': "${dateTime.year}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}",
      'refuelTime' : "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}",
      "currentOdometer": odometer,
      "totalAmount": amount,
      "stationName": fuelStation,
      "pricePerLiter": pricePerLitre,
      "tankStatus": int.tryParse(fullTank) ?? 1,
      "fuelBeforeRefuel": fuelBeforeRefuel,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'vehicleId': vehicle,
      'refuelDate': "${dateTime.year}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}",
      'refuelTime' : "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}",
      "currentOdometer": odometer,
      "totalAmount": amount,
      "pricePerLiter": pricePerLitre,
      "tankStatus": int.tryParse(fullTank) ?? 1,
      "fuelBeforeRefuel": fuelBeforeRefuel,
    };
  }
}