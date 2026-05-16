import 'package:trackify/feature/add_fuel/domain/entities/add_fuel_entity.dart';

abstract class AddFuelRepository{
  Future<void> saveFuel(
      AddFuelEntity entity,
      );
}