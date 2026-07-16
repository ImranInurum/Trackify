class PromoOfferModel {
  final String id;
  final String imageUrl;
  final String tagText;
  final String? redirectScreen;
  final DateTime? showDateTime;
  final DateTime? expiryDateTime;
  final bool isActive;

  PromoOfferModel({
    required this.id,
    required this.imageUrl,
    required this.tagText,
    this.redirectScreen,
    this.showDateTime,
    this.expiryDateTime,
    this.isActive = true,
  });

  factory PromoOfferModel.fromJson(Map<String, dynamic> json) {
    final String imgUrl = json['banner_url'] ?? json['image_url'] ?? json['imageUrl'] ?? '';
    final String tag = json['title'] ?? json['tag_text'] ?? json['tagText'] ?? 'Offer expiring soon';
    
    // Parse show_date and show_time
    final String? showDateStr = json['show_date'];
    final String? showTimeStr = json['show_time'];
    final DateTime? showDt = _combineDateTime(showDateStr, showTimeStr);

    // Parse expiry_date and expiry_time
    final String? expiryDateStr = json['expiry_date'];
    final String? expiryTimeStr = json['expiry_time'];
    final DateTime? expiryDt = _combineDateTime(expiryDateStr, expiryTimeStr);

    final bool active = json['isActive'] ?? true;

    return PromoOfferModel(
      id: json['id'] ?? json['_id'] ?? '',
      imageUrl: imgUrl,
      tagText: tag,
      redirectScreen: json['redirect_screen'] ?? json['redirectScreen'],
      showDateTime: showDt,
      expiryDateTime: expiryDt,
      isActive: active,
    );
  }

  static DateTime? _combineDateTime(String? dateStr, String? timeStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final datePart = dateStr.split('T')[0];
      final dateParts = datePart.split('-');
      if (dateParts.length < 3) return null;
      
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      
      int hour = 0;
      int minute = 0;
      if (timeStr != null && timeStr.isNotEmpty) {
        final timeParts = timeStr.split(':');
        if (timeParts.isNotEmpty) {
          hour = int.parse(timeParts[0]);
        }
        if (timeParts.length > 1) {
          minute = int.parse(timeParts[1]);
        }
      }
      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'tag_text': tagText,
      'redirect_screen': redirectScreen,
      'show_date_time': showDateTime?.toIso8601String(),
      'expiry_date_time': expiryDateTime?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
