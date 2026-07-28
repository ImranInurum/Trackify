class DocumentEntity {
  final String id;
  final String type;
  final String? subtype;
  final String? title;
  final String? fontpath;
  final String? backpath;
  final String? expiryDate;
  final String? billingDate;
  final double? billingAmount;
  final String? shopName;
  final String? shopContact;
  final String? warrantyExpiry;
  final String? createdAt;
  final String? updatedAt;

  DocumentEntity({
    required this.id,
    required this.type,
    this.subtype,
    this.title,
    this.fontpath,
    this.backpath,
    this.expiryDate,
    this.billingDate,
    this.billingAmount,
    this.shopName,
    this.shopContact,
    this.warrantyExpiry,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentEntity.fromJson(Map<String, dynamic> json) {
    return DocumentEntity(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      subtype: json['subtype']?.toString() ?? json['subType']?.toString() ?? json['sub_type']?.toString(),
      title: json['title']?.toString(),
      fontpath: json['fontpath']?.toString() ??
          json['frontImage']?.toString() ??
          json['frontpath']?.toString() ??
          json['frontPath']?.toString() ??
          json['front_image']?.toString() ??
          json['image']?.toString() ??
          json['filePath']?.toString() ??
          json['fileUrl']?.toString() ??
          json['url']?.toString(),
      backpath: json['backpath']?.toString() ??
          json['backImage']?.toString() ??
          json['backPath']?.toString() ??
          json['back_image']?.toString(),
      expiryDate: json['expiryDate']?.toString(),
      billingDate: json['billingDate']?.toString(),
      billingAmount: json['billingAmount'] != null ? double.tryParse(json['billingAmount'].toString()) : null,
      shopName: json['shopName']?.toString(),
      shopContact: json['shopContact']?.toString(),
      warrantyExpiry: json['warrantyExpiry']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}