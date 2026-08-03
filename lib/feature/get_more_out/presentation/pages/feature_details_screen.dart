import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/feature_cubit.dart';
import '../cubit/feature_state.dart';
import 'intro_details_screen.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/core/utils/shared_preferences.dart';

class FeatureDetailsScreen extends StatefulWidget {

  final String appBarTitle;

  /// CATEGORY ID FROM API
  final String categoryId;

  const FeatureDetailsScreen({
    super.key,
    required this.appBarTitle,
    required this.categoryId,
  });

  @override
  State<FeatureDetailsScreen> createState() =>
      _FeatureDetailsScreenState();
}

class _FeatureDetailsScreenState
    extends State<FeatureDetailsScreen> {

  @override
  void initState() {

    super.initState();

    /// LOAD FEATURES FROM API
    context
        .read<FeatureCubit>()
        .loadFeatures(
      widget.categoryId,
    );
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

          onPressed: () =>
              Navigator.pop(context),

          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 18,
          ),
        ),

        title: Text(

          widget.appBarTitle, ),
      ),

      /// ================= BODY =================
      body: BlocBuilder<
          FeatureCubit,
          FeatureState>(

        builder: (context, state) {

          /// ================= LOADING =================
          if (state is FeatureLoading) {

            return const Center(child: TrackifyLoader());
          }

          /// ================= ERROR =================
          if (state is FeatureError) {

            return Center(
              child: Text(state.message),
            );
          }

          /// ================= LOADED =================
          if (state is FeatureLoaded) {

            return ListView.builder(

              padding:
              const EdgeInsets.all(16),

              itemCount:
              state.items.length,

              itemBuilder:
                  (context, index) {

                final item =
                state.items[index];

                return GestureDetector(

                  onTap: () {
                    final prefs = AppPreference.instance;
                    final list = prefs.getStringList(key: AppPreference.KEY_EXPLORED_FEATURES);
                    final key = '${widget.categoryId}_${item.id}';
                    if (!list.contains(key)) {
                      list.add(key);
                      prefs.setStringList(key: AppPreference.KEY_EXPLORED_FEATURES, value: list);
                    }

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            IntroDetailsScreen(
                              title: item.title,
                              categoryId: item.id,
                            ),
                      ),
                    );
                  },

                  child: Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 16,
                    ),

                    padding:
                    const EdgeInsets.all(16),

                    decoration: BoxDecoration(

                      color:
                      Theme.of(context)
                          .cardColor,

                      borderRadius:
                      BorderRadius.circular(16),

                      border: Border.all(

                        color: colorScheme
                            .outlineVariant
                            .withValues(alpha: 0.1),
                      ),
                    ),

                    child: Row(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        /// ================= ICON BOX =================
                        Container(

                          height: 70,
                          width: 70,

                          decoration: BoxDecoration(

                            color: colorScheme
                                .surface
                                .withValues(alpha: 0.54),

                            borderRadius:
                            BorderRadius.circular(
                              16,
                            ),

                            border: Border.all(

                              color: colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.1),
                            ),
                          ),

                          child: Padding(

                            padding:
                            const EdgeInsets.all(14),

                            child:Image.network(
                              item.icon,

                              fit: BoxFit.contain,

                              errorBuilder:
                                  (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {

                                return Icon(
                                  Icons.image_not_supported,
                                  color: colorScheme
                                      .onSurface,
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// ================= TEXT AREA =================
                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              /// TITLE
                              Text(

                                item.title,

                                style: TextStyle(

                                  color: colorScheme
                                      .onSurface,

                                  fontSize: 16,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// SUBTITLE
                              Text(

                                item.subtitle,

                                style: TextStyle(color: colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),

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

          return const SizedBox();
        },
      ),
    );
  }
}
