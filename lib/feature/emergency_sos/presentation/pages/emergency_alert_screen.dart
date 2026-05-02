import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/emergency_alert_cubit.dart';
import '../cubit/emergency_alert_state.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() =>
      _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState
    extends State<EmergencyAlertScreen> {

  late final l10n = AppLocalizations.of(context)!;

  late final theme = Theme.of(context);
  late final colorScheme = theme.colorScheme;

  @override
  void initState() {
    super.initState();

    /// start countdown
    context
        .read<EmergencyAlertCubit>()
        .startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;


    return Scaffold(
      backgroundColor: colorScheme.onPrimaryContainer,

      body: SafeArea(
        child: BlocConsumer<
            EmergencyAlertCubit,
            EmergencyAlertState>(
          listener: (context, state) {

            /// success
            if (state is EmergencySent) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content:
                  Text(state.message),
                ),
              );
              Navigator.pop(context);
            }
            /// error
            if (state
            is EmergencyError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content:
                  Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {

            int seconds = 10;

            if (state
            is EmergencyTimerTick) {
              seconds = state.second;
            }

            final loading =
            state is EmergencySending;

            return Padding(
              padding:
              EdgeInsets.symmetric(
                horizontal:
                width * .04,
              ),
              child: Column(
                children: [

                  SizedBox(
                      height:
                      height * .06),

                  /// warning icon
                  Icon(
                    Icons
                        .warning_rounded,
                    color:
                    AppColors
                        .errorLight,
                    size:
                    width * .38,
                  ),

                  SizedBox(
                      height:
                      height * .01),

                  /// title
                  Text(
                    l10n.initiatingEmergencyAlert,
                    textAlign:
                    TextAlign
                        .center,
                    style:
                    TextStyle(
                      fontSize:
                      width *
                          .045,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight:
                      FontWeightManager
                          .semibold,
                    ),
                  ),

                  SizedBox(
                      height:
                      height * .006),

                  /// subtitle
                  Text(
                    l10n.pleaseUseResponsibly,
                    style:
                    TextStyle(
                      fontSize:
                      width *
                          .038,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.9),
                    ),
                  ),

                  const Spacer(),

                  /// timer
                  Text(
                    "$seconds",
                    style:
                    TextStyle(
                      fontSize:
                      width *
                          .34,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight:
                      FontWeightManager
                          .semibold,
                    ),
                  ),

                  SizedBox(
                      height:
                      height * .01),

                  Text(
                    l10n.secondsBeforeSendingAlert,
                    style:
                    TextStyle(
                      fontSize:
                      width *
                          .04,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeightManager.semibold
                    ),
                  ),

                  const Spacer(),

                  ///  button
                  SizedBox(
                    width: double
                        .infinity,
                    height:
                    height *
                        .065,
                    child:
                    ElevatedButton(
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        AppColors
                            .errorLight,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              10),
                        ),
                      ),
                      onPressed:
                      loading
                          ? null
                          : () {
                        context
                            .read<
                            EmergencyAlertCubit>()
                            .sendAlert();
                      },
                      child: loading
                          ? SizedBox(
                        height:
                        22,
                        width:
                        22,
                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          2,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )

                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.sendNow,
                            style:
                            TextStyle(
                              color:
                              Colors.white,
                              fontSize:
                              width * .042,
                              fontWeight:
                              FontWeightManager.semibold,
                            ),
                          ),
                          SizedBox(
                            width:
                            width * .02,
                          ),

                           Icon(
                            Icons.arrow_forward_ios,
                            color: colorScheme.onSurfaceVariant,
                            size:
                            18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                      height:
                      height * .04),

                  /// cancel
                  GestureDetector(
                    onTap: () {
                      context
                          .read<
                          EmergencyAlertCubit>()
                          .cancelAlert();

                      Navigator.pop(
                          context);
                    },
                    child: Text(
                      l10n.cancel,
                      style:
                      TextStyle(
                        color:colorScheme.onSurfaceVariant,
                        fontSize:
                        width *
                            .043,
                        fontWeight: FontWeightManager.bold
                      ),
                    ),
                  ),

                  SizedBox(
                      height:
                      height * .04),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}