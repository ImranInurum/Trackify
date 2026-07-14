class PromoOfferModel {
  final String id;
  final String imageUrl;
  final String tagText;
  final String? redirectScreen;

  PromoOfferModel({
    required this.id,
    required this.imageUrl,
    required this.tagText,
    this.redirectScreen,
  });

  factory PromoOfferModel.fromJson(Map<String, dynamic> json) {
    return PromoOfferModel(
      id: json['id'] ?? json['_id'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      tagText: json['tag_text'] ?? json['tagText'] ?? 'Offer expiring soon',
      redirectScreen: json['redirect_screen'] ?? json['redirectScreen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'tag_text': tagText,
      'redirect_screen': redirectScreen,
    };
  }
}
