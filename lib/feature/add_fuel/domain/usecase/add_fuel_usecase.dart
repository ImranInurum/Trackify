import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';
import 'package:trackify/feature/add_fuel/domain/reppository/add_fuel_repository.dart';

class AddFuelUseCase{
  final AddFuelRepository repository;

  AddFuelUseCase(this.repository);

  Future<void> call(AddFuelEntity entity,)async{
    await repository.saveFuel(entity);
  }

  Future<void> updateFuel(String refuelId, AddFuelEntity entity) async {
    await repository.updateFuel(refuelId, entity);
  }
}