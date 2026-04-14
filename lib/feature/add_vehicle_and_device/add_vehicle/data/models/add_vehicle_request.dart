class AddVehicleRequest {
  final String vehicleType;
  final String fuelType;
  final String brandId;
  final String modelId;
  final String vehicleNumber;
  final String userId;

  AddVehicleRequest({
    required this.vehicleType,
    required this.fuelType,
    required this.brandId,
    required this.modelId,
    required this.vehicleNumber,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleType': vehicleType,
      'fuelType': fuelType,
      'brandId': brandId,
      'modelId': modelId,
      'vehicleNumber': vehicleNumber,
      'userId': userId,
    };
  }
}
