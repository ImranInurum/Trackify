class AddInventoryRequest {
  final String imei;
  final String modelNo;

  AddInventoryRequest({
    required this.imei,
    required this.modelNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'imei': imei,
      'model_no': modelNo,
    };
  }
}
