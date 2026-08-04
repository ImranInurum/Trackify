import 'package:trackify/feature/add_fuel/data/data_source/add_fuel_datasource.dart';
import 'package:trackify/feature/add_fuel/data/model/add_fuel_model.dart';
import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';
import 'package:trackify/feature/add_fuel/domain/reppository/add_fuel_repository.dart';

class AddFuelRepositoryImpl implements AddFuelRepository{

  final AddFuelDataSource dataSource;


  AddFuelRepositoryImpl(this.dataSource);

  @override
  Future<void> saveFuel(AddFuelEntity entity) async{
    final model  = AddFuelModel(
        vehicle: entity.vehicle,
        dateTime: entity.dateTime,
        fuelStation: entity.fuelStation,
        amount: entity.amount,
        odometer: entity.odometer,
        fullTank: entity.fullTank,
        pricePerLitre: entity.pricePerLitre,
        fuelBeforeRefuel: entity.fuelBeforeRefuel
    );
    await dataSource.saveFuel(model);
  }

  @override
  Future<void> updateFuel(String refuelId, AddFuelEntity entity) async{
    final model  = AddFuelModel(
        vehicle: entity.vehicle,
        dateTime: entity.dateTime,
        fuelStation: entity.fuelStation,
        amount: entity.amount,
        odometer: entity.odometer,
        fullTank: entity.fullTank,
        pricePerLitre: entity.pricePerLitre,
        fuelBeforeRefuel: entity.fuelBeforeRefuel
    );
    await dataSource.updateFuel(refuelId, model);
  }

  
}