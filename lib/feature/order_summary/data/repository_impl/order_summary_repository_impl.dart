import 'package:trackify/feature/order_summary/data/data_source/order_summary_data_source.dart';
import 'package:trackify/feature/order_summary/domain/entities/order_summary_entity.dart';

import '../../domain/repository/order_summaray_repository.dart';

class OrderSummaryRepositoryImpl implements OrderSummaryRepository{
  final OrderSummaryDataSource dataSource;

  OrderSummaryRepositoryImpl(this.dataSource);

  @override
  Future<List<OrderSummaryEntity>> getOrderSummary()async {
    return await dataSource.getOrerSummary();
  }

}