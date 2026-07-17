import 'package:trackify/core/utils/typedefs.dart';
import '../repository/device_warranty_repository.dart';
import '../../data/model/verify_payment_model.dart';

class VerifyPaymentUseCase {
  final DeviceWarrantyRepository _repository;

  const VerifyPaymentUseCase(this._repository);


  ResultFuture<void> call(VerifyPaymentRequest params) =>
      _repository.verifyPayment(params);
}
