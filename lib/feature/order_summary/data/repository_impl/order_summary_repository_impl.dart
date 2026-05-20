import 'package:fpdart/fpdart.dart';
import 'package:trackify/core/config/network/exceptions.dart';
import 'package:trackify/core/utils/typedefs.dart';
import 'package:trackify/feature/order_summary/data/data_source/order_summary_data_source.dart';
import 'package:trackify/feature/order_summary/data/model/purchase_plan_request_model.dart';
import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';
import 'package:trackify/feature/order_summary/domain/entities/purchase_plan_response_entity.dart';

import '../../domain/repository/order_summaray_repository.dart';

class OrderSummaryRepositoryImpl implements OrderSummaryRepository {
  final OrderSummaryRemoteDataSource remoteDataSource;

  OrderSummaryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderSummaryEntity>> getOrderSummary() async {
    return await remoteDataSource.getOrderSummary();
  }

  @override
  ResultFuture<PurchasePlanResponseEntity> purchaseDataPlan(PurchasePlanRequestModel request) async {
    try {
      final model = await remoteDataSource.purchaseDataPlan(request);
      return Right(model);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}