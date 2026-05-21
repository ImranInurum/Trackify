import 'package:trackify/core/utils/typedefs.dart';
import '../entities/extend_warranty_entity.dart';
import '../repository/device_warranty_repository.dart';
import '../../data/model/extend_warranty_model.dart';

class ExtendWarrantyUseCase {
  final DeviceWarrantyRepository repository;

  ExtendWarrantyUseCase(this.repository);

  ResultFuture<ExtendWarrantyEntity> call(ExtendWarrantyRequest request) {
    return repository.extendWarranty(request);
  }
}
