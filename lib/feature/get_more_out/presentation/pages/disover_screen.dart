import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/get_more_out/presentation/pages/feature_details_screen.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/data source/feature_local_data.dart';
import '../../data/repository/feature_repository_impl.dart';
import '../../domain/usecase/get_safey_usecase.dart';
import '../cubit/discover_cubit.dart';
import '../cubit/disocver_state.dart';
import '../cubit/feature_cubit.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/get_more_out/presentation/cubit/geo_fenc_cubit.dart';
import 'package:trackify/feature/get_more_out/domain/usecase/geo_fenc_usecase.dart';
import 'package:trackify/feature/get_more_out/data/repository/geo_fenc_repository_impl.dart';
import 'package:trackify/feature/get_more_out/data/data%20source/geo_fence_local_data.dart';
import 'package:trackify/feature/get_more_out/presentation/pages/intro_details_screen.dart';
import 'package:trackify/feature/location_sharing/presentation/pages/location_sharing_screen.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import '../../domain/entities/discover_entity.dart';

class DiscoverFeaturesScreen extends StatefulWidget {
  const DiscoverFeaturesScreen({super.key});

  @override
  State<DiscoverFeaturesScreen> createState() => _DiscoverFeaturesScreenState();
}

class _DiscoverFeaturesScreenState extends State<DiscoverFeaturesScreen> {
  Color _getStatusColor(String text, ColorScheme colorScheme) {
    final match = RegExp(r'(\d+)/(\d+)').firstMatch(text);
    if (match != null) {
      final explored = int.tryParse(match.group(1) ?? '0') ?? 0;
      final total = int.tryParse(match.group(2) ?? '0') ?? 0;
      if (explored >= total && total > 0) {
        return Colors.green;
      } else {
        return Colors.amber.shade700;
      }
    }
    return colorScheme.primary;
  }

  String _getLocalExploredText(DiscoverEntity feature) {
    final prefs = AppPreference.instance;
    final list = prefs.getStringList(key: AppPreference.KEY_EXPLORED_FEATURES);
    
    // Count how many features of this category have been explored
    final exploredCount = list.where((id) => id.startsWith('${feature.id}_')).length;
    
    // Parse total from backend string
    int total = 0;
    final match = RegExp(r'\d+/(\d+)').firstMatch(feature.exploredText);
    if (match != null) {
      total = int.tryParse(match.group(1) ?? '0') ?? 0;
    } else {
      total = int.tryParse(feature.exploredText) ?? 0;
    }
    
    if (total == 0) return feature.exploredText; // Fallback
    
    final finalExplored = exploredCount > total ? total : exploredCount;
    return '$finalExplored/$total Features explored';
  }

  void _handleNavigation(BuildContext context, DiscoverEntity feature) {
    Widget? targetScreen;

    if (feature.route != null && feature.route!.isNotEmpty) {
      final route = feature.route!.toLowerCase();
      if (route.contains('geofence')) {
        targetScreen = BlocProvider(
          create: (_) => GeoFenceIntroCubit(
            GetGeoFenceIntroUseCase(
              GeoFenceIntroRepositoryImpl(GeoFenceIntroDataSource()),
            ),
          ),
          child: IntroDetailsScreen(title: feature.title, categoryId: feature.id),
        );
      } else if (route.contains('location') || route.contains('share')) {
        targetScreen = const LocationSharingScreen();
      }
    }

    if (targetScreen != null) {
      final prefs = AppPreference.instance;
      final list = prefs.getStringList(key: AppPreference.KEY_EXPLORED_FEATURES);
      final key = '${feature.id}_main';
      if (!list.contains(key)) {
        list.add(key);
        prefs.setStringList(key: AppPreference.KEY_EXPLORED_FEATURES, value: list);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => targetScreen!),
      ).then((_) {
        if (context.mounted) {
          setState(() {});
        }
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => FeatureCubit(
              GetFeatureUseCase(FeatureRepositoryImpl(FeatureDataSource())),
            ),
            child: FeatureDetailsScreen(
              appBarTitle: feature.title,
              categoryId: feature.id,
            ),
          ),
        ),
      ).then((_) {
        if (context.mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    context.read<DiscoverCubit>().fetchDiscoverFeatures();
    super.initState();
  }

  late final l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 18,
          ),
        ),
        title: Text(
          l10n.discoverTrackifyFeatures, ),
      ),

      /// ================= BODY =================
      body: BlocBuilder<DiscoverCubit, DiscoverState>(
        builder: (context, state) {
          /// ================= LOADED =================
          if (state is DiscoverLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.discoverList.length,
              itemBuilder: (context, index) {
                final feature = state.discoverList[index];

                return GestureDetector(
                  onTap: () => _handleNavigation(context, feature),
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withOpacity(0.2),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(feature.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colorScheme.surface.withValues(alpha: 0.95),
                            colorScheme.surface.withValues(alpha: 0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ================= TOP ROW =================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// FEATURE EXPLORED
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withOpacity(0.54),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final localText = _getLocalExploredText(feature);
                                    return Text(
                                      localText.toLowerCase().contains('feature') 
                                          ? localText 
                                          : '$localText Features explored',
                                      style: TextStyle(color: _getStatusColor(
                                          localText,
                                          colorScheme,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    );
                                  }
                                ),
                              ),

                              /// ARROW BUTTON
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withOpacity(0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: colorScheme.onSurface,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// ================= TITLE =================
                          Text(
                            feature.title,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// ================= SUBTITLE =================
                          Text(
                            feature.subtitle,
                            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          /// ================= LOADING =================
          return const Center(child: TrackifyLoader());
        },
      ),
    );
  }
}
