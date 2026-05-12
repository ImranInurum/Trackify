import 'package:trackify/feature/order_summary/data/model/order_summary_model.dart';

class OrderSummaryDataSource{

  Future<List<OrderSummaryModel>> getOrerSummary()async{

    await Future.delayed(Duration(seconds: 1));

    return [
      OrderSummaryModel(
        title: "Super Combo Plan",
        validity: "12 Months",
        price: 1355,
        originalPrice: 3438,
        discount: 2083,
        gst: 244,
        toPay: 1599,
        benefit: [
          "App & SIM recharge",
          "Extended Warranty",
          "Plus Membership",
        ],
        isCombo: true,
      ),

      OrderSummaryModel(
        title: "12-Month Validity",
        validity: "12 Months",
        price: 1186,
        originalPrice: 1999,
        discount: 813,
        gst: 213,
        toPay: 1399,
        benefit: [
          "App & SIM recharge",
        ],
        isCombo: false,
      ),

      OrderSummaryModel(
        title: "6-Month Validity",
        validity: "6 Months",
        price: 999,
        originalPrice: 1499,
        discount: 500,
        gst: 180,
        toPay: 1179,
        benefit: [
          "App & SIM recharge",
        ],
        isCombo: false,
      ),

    ];
  }

}