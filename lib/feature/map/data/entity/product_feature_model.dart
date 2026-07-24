class ProductFeatureModel {
  final String id;
  final String title;
  final List<String> features;
  final List<String> featuresVideos;
  final List<String> titleVideos;

  ProductFeatureModel({
    required this.id,
    required this.title,
    required this.features,
    required this.featuresVideos,
    required this.titleVideos,
  });

  /// All videos combined: titleVideos first, then featuresVideos
  List<String> get allVideos => [...titleVideos, ...featuresVideos];

  factory ProductFeatureModel.fromJson(Map<String, dynamic> json) {
    List<String> toStringList(dynamic raw) {
      if (raw == null) return [];
      if (raw is List) {
        return raw
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [];
    }

    return ProductFeatureModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      features: toStringList(json['features']),
      featuresVideos: toStringList(json['featuresvideos']),
      titleVideos: toStringList(json['titlevideos']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'features': features,
        'featuresvideos': featuresVideos,
        'titlevideos': titleVideos,
      };
}
