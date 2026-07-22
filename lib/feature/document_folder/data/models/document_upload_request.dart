class DocumentUploadRequest {
  final String vehicleId;
  final String type;
  final String subtype;
  final String? title;
  final String? expiryDate;
  final String? billingDate;
  final double? billingAmount;
  final String? shopName;
  final String? shopContact;
  final String? warrantyExpiry;

  const DocumentUploadRequest({
    required this.vehicleId,
    required this.type,
    required this.subtype,
    this.title,
    this.expiryDate,
    this.billingDate,
    this.billingAmount,
    this.shopName,
    this.shopContact,
    this.warrantyExpiry,
  });

  Map<String, String> toFields() {
    final fields = <String, String>{
      'vehicleId': vehicleId,
      'type': type,
      'subtype': subtype,
    };
    if (title != null && title!.isNotEmpty) fields['title'] = title!;
    if (expiryDate != null && expiryDate!.isNotEmpty) fields['expiryDate'] = expiryDate!;
    if (billingDate != null && billingDate!.isNotEmpty) fields['billingDate'] = billingDate!;
    if (billingAmount != null) fields['billingAmount'] = billingAmount!.toString();
    if (shopName != null && shopName!.isNotEmpty) fields['shopName'] = shopName!;
    if (shopContact != null && shopContact!.isNotEmpty) fields['shopContact'] = shopContact!;
    if (warrantyExpiry != null && warrantyExpiry!.isNotEmpty) fields['warrantyExpiry'] = warrantyExpiry!;
    return fields;
  }
}
