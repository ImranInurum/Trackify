import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/feature_cubit.dart';
import '../cubit/feature_state.dart';
import 'geo_fenc_screen.dart';

class VehicleTrackingScreen extends StatefulWidget {
  const VehicleTrackingScreen({super.key});

  @override
  State<VehicleTrackingScreen> createState() => _VehicleTrackingScreenState();
}

class _VehicleTrackingScreenState extends State<VehicleTrackingScreen> {

  @override
  void initState() {
    context.read<FeatureCubit>().loadTrackingItems();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 18),
        ),
        title: Text(
         "Vehicle Tracking & More",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      /// ================= BODY =================
      body: BlocBuilder<FeatureCubit, FeatureState>(
        builder: (context, state) {
          /// ================= LOADED STATE =================
          if (state is FeatureLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                /// CURRENT ITEM
                final item = state.items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GeofancyScreen(title: item.title),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ================= ICON BOX =================
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withOpacity(0.54),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withOpacity(0.1),
                            ),
                          ),
                          child: Icon(
                            IconData(
                              item.icon,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: colorScheme.onSurface,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// ================= TEXT AREA =================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// SUBTITLE
                              Text(
                                item.subtitle,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          /// ================= LOADING =================
          return Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
