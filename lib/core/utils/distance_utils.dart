import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../app/cubit/app_cubit.dart';

extension DistanceUnitExt on BuildContext {
  String get displayKm {
    final l10n = AppLocalizations.of(this)!;
    return read<AppCubit>().state.distanceUnit == 'km' ? l10n.km : 'mi';
  }

  String get displayKmh {
    final l10n = AppLocalizations.of(this)!;
    return read<AppCubit>().state.distanceUnit == 'km' ? l10n.kmh : 'mi/h';
  }
  
  String get displayKms {
    final l10n = AppLocalizations.of(this)!;
    return read<AppCubit>().state.distanceUnit == 'km' ? l10n.kms : 'mi';
  }
  
  String get displayKmHr {
    final l10n = AppLocalizations.of(this)!;
    return read<AppCubit>().state.distanceUnit == 'km' ? l10n.kmHr : 'mi/hr';
  }
  
  String get displayKmL {
    final l10n = AppLocalizations.of(this)!;
    return read<AppCubit>().state.distanceUnit == 'km' ? l10n.kmL : 'mi/L'; 
  }
}
