import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trackify/feature/help_and_support/presentation/cubit/time_slot_state.dart';

import '../../data/data source/time_slot_data_source.dart';

import 'package:trackify/core/config/network/network_api_service.dart';

class BookingSlotCubit
    extends Cubit<BookingSlotState> {

  BookingSlotCubit()
      : super(
    BookingSlotInitial(),
  );

  final BookingRemoteDataSource
  _remoteDataSource =
  BookingRemoteDataSource(NetworkApiService());

  /// GET API
  Future<void> getSlots() async {

    try {

      emit(
        BookingSlotLoading(),
      );

      final response =
      await _remoteDataSource
          .getSlots();

      emit(

        BookingSlotLoaded(
          slotResponse: response,
        ),
      );

    } catch (e) {

      emit(

        BookingSlotError(
          message: e.toString(),
        ),
      );
    }
  }
}