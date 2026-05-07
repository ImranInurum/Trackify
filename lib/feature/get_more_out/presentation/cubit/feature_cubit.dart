import 'package:flutter_bloc/flutter_bloc.dart';


import '../../domain/usecase/get_safey_usecase.dart';
import 'feature_state.dart';


class FeatureCubit extends Cubit<FeatureState> {

  final GetSafetyUseCase
  getSafetyItemsUseCase;

  final GetTrackingUseCase
  getTrackingItemsUseCase;

  final GetRideUseCase
  getRideItemsUseCase;

  final GetDeviceUseCase
  getDeviceItemsUseCase;

  FeatureCubit(
      this.getSafetyItemsUseCase,
      this.getTrackingItemsUseCase,
      this.getRideItemsUseCase,
      this.getDeviceItemsUseCase,
      ) : super(FeatureInitial());

  /// SAFETY
  void loadSafetyItems() {

    final items =
    getSafetyItemsUseCase.call();

    emit(FeatureLoaded(items));
  }

  /// TRACKING
  void loadTrackingItems() {

    final items =
    getTrackingItemsUseCase.call();

    emit(FeatureLoaded(items));
  }

  /// RIDES
  void loadRideItems() {

    final items =
    getRideItemsUseCase.call();

    emit(FeatureLoaded(items));
  }

  /// DEVICE
  void loadDeviceItems() {

    final items =
    getDeviceItemsUseCase.call();

    emit(FeatureLoaded(items));
  }
}