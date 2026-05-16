import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../map/data/entity/user_vehicles.dart';
import 'location_sharing_state.dart';

class LocationSharingCubit
    extends Cubit<LocationSharingState> {

  LocationSharingCubit()
      : super(LocationSharingInitial());

  void loadLocations({Vehicles? selectedVehicle}) async {

    emit(LocationSharingLoading());

    await Future.delayed(
      const Duration(seconds: 1),
    );

    final items = [

      const LocationSharingItem(
        id: '1',
        name: "Your Phone's Location",
        isSharing: false,
        isPhone: true,
      ),

      if (selectedVehicle != null)
        LocationSharingItem(
          id: selectedVehicle.id,
          name: '${selectedVehicle.vehicleModel} (${selectedVehicle.vehicleNumber})',
          isSharing: false,
          isPhone: false,
        ),
    ];

    emit(
      LocationSharingLoaded(
        items: items,
      ),
    );
  }

  void toggleSharing(String id) {

    if (state is LocationSharingLoaded) {

      final items =
          (state as LocationSharingLoaded)
              .items;

      final updatedItems =
      items.map((item) {

        if (item.id == id) {

          return item.copyWith(
            isSharing: !item.isSharing,
          );
        }

        return item;

      }).toList();

      emit(
        LocationSharingLoaded(
          items: updatedItems,
        ),
      );
    }
  }
}