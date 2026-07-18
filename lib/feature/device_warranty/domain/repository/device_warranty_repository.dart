import 'package:trackify/core/utils/typedefs.dart';
import '../entities/device_warranty_entity.dart';
import '../entities/warranty_payment_summary_entity.dart';
import '../entities/extend_warranty_entity.dart';
import '../../data/model/warranty_payment_summary_model.dart';
import '../../data/model/extend_warranty_model.dart';
import '../../data/model/warranty_status_model.dart';
import '../../data/model/verify_payment_model.dart';

abstract class DeviceWarrantyRepository {
  ResultFuture<DeviceWarrantyEntity> getDeviceWarranty(String imei);
  ResultFuture<WarrantyPaymentSummaryEntity> getWarrantyPaymentSummary(
    WarrantyPaymentSummaryRequest request,
  );
  ResultFuture<ExtendWarrantyEntity> extendWarranty(
    ExtendWarrantyRequest request,
  );
  ResultFuture<void> verifyPayment(VerifyPaymentRequest request);
  ResultFuture<WarrantyStatusModel> getDeviceWarrantyStatus(String imei);
}
