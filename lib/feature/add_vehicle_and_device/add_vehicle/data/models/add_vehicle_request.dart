class AddVehicleRequest {
  final String vehicleType;
  final String fuelType;
  final String vehicleMaker;
  final String vehicleNumber;
  final String vehicleModel;
  final String userId;

  AddVehicleRequest({
    required this.vehicleType,
    required this.fuelType,
    required this.vehicleMaker,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'vehicleMaker': vehicleMaker,
      'vehicleNumber': vehicleNumber,
      'vehicleModel': vehicleModel,
      'userId': userId,
    };
  }
}
