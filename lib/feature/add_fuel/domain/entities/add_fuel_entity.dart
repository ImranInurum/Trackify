class AddFuelEntity{
  final String vehicle;
  final DateTime dateTime;
  final String fuelStation;
  final int odometer;
  final double amount;
  final double pricePerLitre;
  final bool fullTank;

  AddFuelEntity({
    required this.vehicle,
    required  this.dateTime,
    required this.fuelStation,
    required this.amount,
    required this.odometer,
    required this.fullTank,
    required this.pricePerLitre
});
}