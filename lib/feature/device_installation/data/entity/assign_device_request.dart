class AssignDeviceRequest {
  final String userId;
  final String vehicleId;
  final String imei;
  final String? uid;

  AssignDeviceRequest({
    required this.userId,
    required this.vehicleId,
    required this.imei,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'imei': imei,
      'uid': uid ?? '',
    };
  }
}
