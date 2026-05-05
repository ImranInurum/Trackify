import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/upgrade_to_plus_state.dart';
import '../../domain/usecase/get_plus_membership_details.dart';
import '../../domain/repository/plus_membership_repository.dart';

class UpgradeToPlusCubit extends Cubit<UpgradeToPlusState> {
  final GetPlusMembershipDetails getPlusMembershipDetails;
  final PlusMembershipRepository repository;

  UpgradeToPlusCubit({
    required this.getPlusMembershipDetails,
    required this.repository,
  }) : super(UpgradeToPlusInitial());

  void getDetails() async {
    emit(UpgradeToPlusLoading());
    try {
      final details = await getPlusMembershipDetails();
      emit(UpgradeToPlusSuccess(details));
    } catch (e) {
      emit(UpgradeToPlusFailure(e.toString()));
    }
  }

  void upgradeToPlus() async {
    // We don't want to lose the current details if we were in success state
    final currentState = state;
    
    try {
      await repository.upgradeToPlus();
      // Handle success (maybe navigate or show toast)
    } catch (e) {
      emit(UpgradeToPlusFailure(e.toString()));
      // If it fails, we might want to restore the previous success state
      if (currentState is UpgradeToPlusSuccess) {
        emit(currentState);
      }
    }
  }
}

