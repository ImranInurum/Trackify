class PromoVideoModel {
  final String id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PromoVideoModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PromoVideoModel.fromJson(Map<String, dynamic> json) {
    String rawVideoUrl = json['video_url']?.toString() ?? '';
    // Clean up malformed urls like "stringhttps..."
    if (rawVideoUrl.startsWith('string')) {
      rawVideoUrl = rawVideoUrl.substring(6);
    }
    rawVideoUrl = rawVideoUrl.trim();

    return PromoVideoModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      videoUrl: rawVideoUrl,
      thumbnailUrl: json['thumbnail_url']?.toString().trim() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
