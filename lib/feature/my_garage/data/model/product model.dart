import 'package:trackify/feature/my_garage/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity{
  ProductModel({

  required super.title,
  required super.description,
  required super.image,
  required super.mrp,
  required super.discount, required super.price, required super.deliveryText, required super.deviceType, required super.idealText, required super.vehicleIcons,
  });

  factory ProductModel.fromJson(Map<String,dynamic>json){
    return ProductModel(title: json['title'],
     description: json['description'],
     image: json['image'],
      mrp: json['mrp'],
      discount: json['discount'],
        price: json['price'],
        deliveryText: json['deliveryText'],
        deviceType: json['deviceType'],
        idealText: json['idealText'],
        vehicleIcons: json['vehicleIcons']
       );
  }
}