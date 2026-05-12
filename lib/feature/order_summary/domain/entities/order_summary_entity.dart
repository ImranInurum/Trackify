class OrderSummaryEntity {
  final String title;
  final String validity;
  final int price;
  final int originalPrice;
  final int discount;
  final int gst;
  final int toPay;
  final List<String> benefit;
  final bool isCombo;

  OrderSummaryEntity({
    required this.title,
    required this.validity,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.gst,
    required this.toPay,
    required this.benefit,
    required this.isCombo
});
}