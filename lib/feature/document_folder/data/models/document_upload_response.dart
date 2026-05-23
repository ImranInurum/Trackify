class DocumentUploadResponse {
  final bool? success;
  final String? message;
  final DocumentResponseData? data;

  const DocumentUploadResponse({
    this.success,
    this.message,
    this.data,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? DocumentResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DocumentResponseData {
  final String? id;
  final String? vehicleId;
  final String? imei;
  final String? type;
  final String? subtype;
  final String? title;
  final String? expiryDate;
  final String? billingDate;
  final double? billingAmount;
  final String? shopName;
  final String? shopContact;
  final String? warrantyExpiry;
  final String? frontImage;
  final String? backImage;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;

  const DocumentResponseData({
    this.id,
    this.vehicleId,
    this.imei,
    this.type,
    this.subtype,
    this.title,
    this.expiryDate,
    this.billingDate,
    this.billingAmount,
    this.shopName,
    this.shopContact,
    this.warrantyExpiry,
    this.frontImage,
    this.backImage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentResponseData.fromJson(Map<String, dynamic> json) {
    return DocumentResponseData(
      id: json['_id'] as String?,
      vehicleId: json['vehicleId'] as String?,
      imei: json['imei'] as String?,
      type: json['type'] as String?,
      subtype: json['subtype'] as String?,
      title: json['title'] as String?,
      expiryDate: json['expiryDate'] as String?,
      billingDate: json['billingDate'] as String?,
      billingAmount: (json['billingAmount'] as num?)?.toDouble(),
      shopName: json['shopName'] as String?,
      shopContact: json['shopContact'] as String?,
      warrantyExpiry: json['warrantyExpiry'] as String?,
      frontImage: json['frontImage'] as String?,
      backImage: json['backImage'] as String?,
      status: json['status'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
