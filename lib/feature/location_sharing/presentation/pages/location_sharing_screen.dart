import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/location_sharing_cubit.dart';
import '../cubit/location_sharing_state.dart';
import 'location_sharing_detail_screen.dart';
import 'widgets/location_sharing_card.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({super.key});

  @override
  State<LocationSharingScreen> createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the Cubit is available if it was provided higher up
    // or just call it here if we're creating it here.
    // In this case, I'll assume it's provided via BlocProvider in the parent or I'll wrap it.
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => LocationSharingCubit()..loadLocations(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.cardColor,
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.1),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            l10n.locationSharing,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            BlocBuilder<LocationSharingCubit, LocationSharingState>(
              builder: (context, state) {
                if (state is LocationSharingLoading) {
                  return const Center(child: TrackifyLoader());
                } else if (state is LocationSharingLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return LocationSharingCard(
                        item: item,
                        onShareTap: () {
                          context.read<LocationSharingCubit>().toggleSharing(
                            item.id,
                          );
                        },
                        onCardTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<LocationSharingCubit>(),
                                child: LocationSharingDetailScreen(item: item),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is LocationSharingError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned.fill(
              child: Container(
                color: theme.scaffoldBackgroundColor.withOpacity(0.75),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.comingSoonOption,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
