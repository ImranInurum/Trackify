import 'package:trackify/feature/add_fuel/data/model/add_fuel_model.dart';

class AddFuelDataSource {

  Future<void>saveFuel(
      AddFuelModel model,
      )async{
    await Future.delayed(Duration(seconds: 1));
    print(model.toMap());
  }
}