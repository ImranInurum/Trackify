import 'package:trackify/feature/fuel_logs/presentation/pages/widgets/spending_card.dart';


class FuelCalculationModel {

  final String imei;
  final String vehicleImage;
  final String vehicleIcon;
  final String vehicleColor;

  final int tankCapacity;
  final int  odometerReading;
  final double vehicleMileage;

  final double fuelRemaining;
  final double distanceRemaining;
  final double distanceTravel;

  final SpendingCard spendingCard;

  FuelCalculationModel({
    required this.imei,
    required this.vehicleImage,
    required this.vehicleIcon,
    required this.vehicleColor,

    required this.tankCapacity,
    required this.odometerReading,
    required this.vehicleMileage,

    required this.fuelRemaining,
    required  this.distanceRemaining,
    required this.distanceTravel,

    required this.spendingCard,


});

  factory FuelCalculationModel.fromJson(Map<String,dynamic>json){

    final data = json['data'];
    return FuelCalculationModel(imei: data['imei'] ?? '',
        vehicleImage: data['vehicleImage'] ?? "",
        vehicleIcon: data['vehicleIcon'] ?? " ",
        vehicleColor: data['vehicleColor'] ?? "",
        tankCapacity:( data['tankCapacity'] ?? 0).toDouble(),
        odometerReading: (data['odometerReading'] ?? 0).toDouble(),
        vehicleMileage: (data['vehicleMileage']?? 0).toDouble(),
        fuelRemaining: (data['fuelRemaining'] ?? 0).toDouble(),
        distanceRemaining:( data['distanceRemaining'] ?? 0).toDouble(),
        distanceTravel:( data['distanceTravel']?? 0).toDouble(),
        spendingCard: data['spendingCard']?? ""
    );
  }
}
class Spending {

  final double thisWeekAmount;
  final double thisWeekFuel;

  final double thisMonthAmount;
  final double thisMonthFuel;

  Spending({

    required this.thisWeekAmount,
    required this.thisWeekFuel,

    required this.thisMonthAmount,
    required this.thisMonthFuel,
  });

  factory Spending.fromJson(
      Map<String, dynamic> json,
      ) {

    return Spending(

      thisWeekAmount:
      (json['thisWeekAmount'] ?? 0)
          .toDouble(),

      thisWeekFuel:
      (json['thisWeekFuel'] ?? 0)
          .toDouble(),

      thisMonthAmount:
      (json['thisMonthAmount'] ?? 0)
          .toDouble(),

      thisMonthFuel:
      (json['thisMonthFuel'] ?? 0)
          .toDouble(),
    );
  }
}

