import 'package:trackify/core/utils/typedefs.dart';
import '../entities/warranty_payment_summary_entity.dart';
import '../repository/device_warranty_repository.dart';
import '../../data/model/warranty_payment_summary_model.dart';

class GetWarrantyPaymentSummaryUseCase {
  final DeviceWarrantyRepository repository;

  GetWarrantyPaymentSummaryUseCase(this.repository);

  ResultFuture<WarrantyPaymentSummaryEntity> call(
    WarrantyPaymentSummaryRequest request,
  ) {
    return repository.getWarrantyPaymentSummary(request);
  }
}
