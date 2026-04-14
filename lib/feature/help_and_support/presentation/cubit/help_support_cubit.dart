import 'package:bloc/bloc.dart';
import 'package:trackify/feature/help_and_support/domain/use_case/help_support_use_case.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_support_state.dart';

class HelpSupportCubit extends Cubit<HelpSupportState> {
  final HelpSupportUseCase _helpSupportUseCase;

  HelpSupportCubit(this._helpSupportUseCase) : super(HelpSupportInitial());
}
