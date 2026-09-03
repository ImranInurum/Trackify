import 'package:trackify/feature/my_garage/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity{
  ProductModel({

  required super.title,
  required super.description,
  required super.image,
  required super.mrp,
  required super.discount, required super.price, required super.deliveryText, required super.deviceType, required super.idealText, required super.vehicleIcons,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty)
          ? json['imageUrl'].toString()
          : (json['image'] ?? 'assets/images/device_image.png'),
      mrp: (json['mrp'] is num) ? (json['mrp'] as num).toInt() : int.tryParse(json['mrp']?.toString() ?? '0') ?? 0,
      discount: (json['discount'] is num) ? (json['discount'] as num).toInt() : int.tryParse(json['discount']?.toString() ?? '0') ?? 0,
      price: (json['price'] is num) ? (json['price'] as num).toInt() : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      deliveryText: json['deliveryText'] ?? 'Free delivery from Trackify',
      deviceType: json['deviceType'] ?? 'Wired Device',
      idealText: json['idealText'] ?? 'Ideal for:',
      vehicleIcons: json['vehicleIcons'] != null ? List<String>.from(json['vehicleIcons']) : ["🛵", "🚗", "🚚", "🚜"],
    );
  }
}