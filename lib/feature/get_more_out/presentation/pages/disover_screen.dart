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
import 'package:trackify/core/constants/app_images.dart';
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
    final prefs = AppPreference.instance;
    final list = prefs.getStringList(key: AppPreference.KEY_EXPLORED_FEATURES);
    final key = '${feature.id}_main';
    if (!list.contains(key)) {
      list.add(key);
      prefs.setStringList(key: AppPreference.KEY_EXPLORED_FEATURES, value: list);
    }

    final targetScreen = BlocProvider(
      create: (_) => GeoFenceIntroCubit(
        GetGeoFenceIntroUseCase(
          GeoFenceIntroRepositoryImpl(GeoFenceIntroDataSource()),
        ),
      ),
      child: IntroDetailsScreen(title: feature.title, categoryId: feature.id),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
    ).then((_) {
      if (context.mounted) {
        setState(() {});
      }
    });
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
                        color: colorScheme.outlineVariant.withOpacity( 0.2),
                      ),
                      image: DecorationImage(
                        image: (feature.image.startsWith('http://') || feature.image.startsWith('https://'))
                            ? NetworkImage(feature.image) as ImageProvider
                            : AssetImage(
                                feature.image.startsWith('assets/')
                                    ? feature.image
                                    : AppImages.roadImage,
                              ),
                        fit: BoxFit.cover,
                        alignment: feature.image.contains('road') ? Alignment.bottomCenter : Alignment.center,
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
                            Colors.black.withOpacity(0.82),
                            Colors.black.withOpacity(0.55),
                            Colors.black.withOpacity(0.20),
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
                                  color: Colors.black.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final localText = _getLocalExploredText(feature);
                                    return Text(
                                      localText.toLowerCase().contains('feature') 
                                          ? localText 
                                          : '$localText Features explored',
                                      style: const TextStyle(
                                        color: Colors.amberAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    );
                                  }
                                ),
                              ),

                              /// ARROW BUTTON
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          /// ================= TITLE =================
                          Text(
                            feature.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// ================= SUBTITLE =================
                          Text(
                            feature.subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 14,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.80),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
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
