import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_sharing_state.dart';

class LocationSharingCubit extends Cubit<LocationSharingState> {
  LocationSharingCubit() : super(LocationSharingInitial());

  void loadLocations() async {
    emit(LocationSharingLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    final items = [
      const LocationSharingItem(
        id: '1',
        name: "Your Phone's Location",
        subtitle: 'No active sharing',
        isSharing: false,
        isPhone: true,
      ),
      const LocationSharingItem(
        id: '2',
        name: 'SP 125 (MP09QV8269)',
        subtitle: 'No active sharing',
        isSharing: false,
        isPhone: false,
      ),
    ];
    
    emit(LocationSharingLoaded(items: items));
  }

  void toggleSharing(String id) {
    if (state is LocationSharingLoaded) {
      final items = (state as LocationSharingLoaded).items;
      final updatedItems = items.map((item) {
        if (item.id == id) {
          return item.copyWith(
            isSharing: !item.isSharing,
            subtitle: !item.isSharing ? 'Sharing active' : 'No active sharing',
          );
        }
        return item;
      }).toList();
      emit(LocationSharingLoaded(items: updatedItems));
    }
  }
}
