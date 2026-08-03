import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';

import '../../app/cubit/app_cubit.dart';

extension DistanceUnitExt on BuildContext {
  String get displayKm {
    final l10n = AppLocalizations.of(this)!;
    return watch<AppCubit>().state.distanceUnit == 'km' ? l10n.km : 'mi';
  }

  String get displayKmh {
    final l10n = AppLocalizations.of(this)!;
    return watch<AppCubit>().state.distanceUnit == 'km' ? l10n.kmh : 'mi/h';
  }
  
  String get displayKms {
    final l10n = AppLocalizations.of(this)!;
    return watch<AppCubit>().state.distanceUnit == 'km' ? l10n.kms : 'mi';
  }
  
  String get displayKmHr {
    final l10n = AppLocalizations.of(this)!;
    return watch<AppCubit>().state.distanceUnit == 'km' ? l10n.kmHr : 'mi/hr';
  }
  
  String get displayKmL {
    final l10n = AppLocalizations.of(this)!;
    return watch<AppCubit>().state.distanceUnit == 'km' ? l10n.kmL : 'mi/L'; 
  }

  static double convertDistance(double value, String savedUnit, String currentUnit) {
    if (savedUnit == currentUnit) return value;
    if (savedUnit == 'km' && (currentUnit == 'mi' || currentUnit == 'miles')) {
      return value / 1.60934;
    } else if ((savedUnit == 'mi' || savedUnit == 'miles') && currentUnit == 'km') {
      return value * 1.60934;
    }
    return value;
  }

  static double convertSpeed(double value, String savedUnit, String currentUnit) {
    return convertDistance(value, savedUnit, currentUnit); // Speed uses same conversion ratio
  }
}
