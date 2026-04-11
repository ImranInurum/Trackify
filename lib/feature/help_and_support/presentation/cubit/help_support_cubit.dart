import 'package:bloc/bloc.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_support_state.dart';

class HelpSupportCubit extends Cubit<HelpSupportState> {
  HelpSupportCubit() : super(HelpSupportInitial());
}
