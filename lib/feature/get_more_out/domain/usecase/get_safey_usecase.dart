import 'package:trackify/feature/get_more_out/domain/entities/feature_entity.dart';
import 'package:trackify/feature/get_more_out/domain/repository/feature_repository.dart';

class GetSafetyUseCase{

  final FeatureRepository repository;

  GetSafetyUseCase(this.repository);

  List<FeatureEntity>call(){
    return repository.safetyItems();
  }
}
 //TRACKING

class GetTrackingUseCase{

  final FeatureRepository repository;

  GetTrackingUseCase(this.repository);

  List<FeatureEntity> call(){
    return repository.trackingItems();
  }
}

 //RIDE

class GetRideUseCase {
  final FeatureRepository repository;

  GetRideUseCase(this.repository);

  List<FeatureEntity>call(){
    return repository.ridesItems();
  }
}

  //DEVICE

class GetDeviceUseCase {
  final FeatureRepository repository;

  GetDeviceUseCase(this.repository);

  List<FeatureEntity>call(){
    return repository.deviceItems();
  }
}