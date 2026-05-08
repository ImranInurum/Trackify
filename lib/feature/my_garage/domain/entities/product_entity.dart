 class ProductEntity {
  final String title;
  final String description;
  final String image;
  final int mrp;
  final int discount;
  final int price;
  final String deviceType;
  final String idealText;
  final String deliveryText;
  final List<String> vehicleIcons;

  ProductEntity({
    required this.title,
    required this.description,
    required this.image,
    required this.mrp,
    required this.discount,
    required this.price,
    required this.deliveryText,
    required this.deviceType,
    required this.idealText,
    required this.vehicleIcons
 });
 }