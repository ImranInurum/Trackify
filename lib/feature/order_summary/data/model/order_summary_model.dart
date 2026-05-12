import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';

class OrderSummaryModel extends OrderSummaryEntity{
  OrderSummaryModel({
  required super.title,
  required super.validity,
  required super.price,
  required super.originalPrice,
  required super.discount,
  required super.gst,
  required super.toPay,
  required super.benefit,
  required super.isCombo
  });

  factory OrderSummaryModel.fromJson(Map<String,dynamic>json){
    return OrderSummaryModel(
        title: json['title'],
        validity: json['validity'],
        price: json['price'],
        originalPrice: json['originalPrice'],
        discount: json['discount'],
        gst: json['gst'],
        toPay: json['toPay'],
        benefit: json['benefit'],
        isCombo: json['isCombo']
    );
  }
}