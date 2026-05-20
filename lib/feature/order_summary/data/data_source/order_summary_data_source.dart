import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/base_api_service.dart';
import '../model/order_summary_model.dart';
import '../model/purchase_plan_request_model.dart';
import '../model/purchase_plan_response_model.dart';

abstract class OrderSummaryRemoteDataSource {
  Future<List<OrderSummaryModel>> getOrderSummary();
  Future<PurchasePlanResponseModel> purchaseDataPlan(PurchasePlanRequestModel request);
}

class OrderSummaryRemoteDataSourceImpl implements OrderSummaryRemoteDataSource {
  final BaseApiServices _apiServices;

  OrderSummaryRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<OrderSummaryModel>> getOrderSummary() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      OrderSummaryModel(
        id: "mock_super_combo_12",
        title: "Super Combo Plan",
        validity: "12 Months",
        price: 1355,
        originalPrice: 3438,
        discount: 2083,
        gst: 244,
        toPay: 1599,
        benefit: const [
          "App & SIM recharge",
          "Extended Warranty",
          "Plus Membership",
        ],
        isCombo: true,
      ),
      OrderSummaryModel(
        id: "mock_validity_12",
        title: "12-Month Validity",
        validity: "12 Months",
        price: 1186,
        originalPrice: 1999,
        discount: 813,
        gst: 213,
        toPay: 1399,
        benefit: const [
          "App & SIM recharge",
        ],
        isCombo: false,
      ),
      OrderSummaryModel(
        id: "mock_validity_6",
        title: "6-Month Validity",
        validity: "6 Months",
        price: 999,
        originalPrice: 1499,
        discount: 500,
        gst: 180,
        toPay: 1179,
        benefit: const [
          "App & SIM recharge",
        ],
        isCombo: false,
      ),
    ];
  }

  @override
  Future<PurchasePlanResponseModel> purchaseDataPlan(PurchasePlanRequestModel request) async {
    final response = await _apiServices.getPostApiResponse(
      ApiURL.purchaseDataPlan,
      request.toJson(),
    );
    return response.fold(
      (l) => throw l,
      (r) {
        final Map<String, dynamic> data = r as Map<String, dynamic>? ?? {};
        return PurchasePlanResponseModel.fromJson(data);
      },
    );
  }
}