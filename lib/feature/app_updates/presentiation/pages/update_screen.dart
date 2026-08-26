import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/update_cubit.dart';
import '../cubit/update_cubit_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UpdateCubit>().fetchUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.appUpdates,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocBuilder<UpdateCubit, UpdateState>(
          builder: (context, state) {
            /// Loading
            if (state is UpdateLoading) {
              return const Center(child: TrackifyLoader());
            }

            /// Loaded
            if (state is UpdateLoaded) {
              if (state.updates.isEmpty) {
                return Center(
                  child: Text(
                    "No app updates found",
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 15,
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: state.updates.length,
                itemBuilder: (context, index) {
                  final item = state.updates[index];
                  final count = item.titles.length < item.descriptions.length
                      ? item.titles.length
                      : item.descriptions.length;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.surface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE8EEF5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// CARD HEADER
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark ? colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF0F5FA),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.date.isNotEmpty ? item.date : "Recent Update",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              if (item.version.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFBAE6FD)),
                                  ),
                                  child: Text(
                                    "Version ${item.version}",
                                    style: const TextStyle(
                                      color: Color(0xFF0284C7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        /// CARD CONTENT
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              count,
                              (i) => Padding(
                                padding: EdgeInsets.only(bottom: i == count - 1 ? 0 : 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.titles[i].toString().isNotEmpty)
                                      Text(
                                        item.titles[i].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                          height: 1.3,
                                        ),
                                      ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.descriptions[i].toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.45,
                                        color: colorScheme.onSurface.withOpacity(0.8),
                                        fontFamily: FontFamilyManager.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            /// Error
            if (state is UpdateError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: colorScheme.error,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: TextStyle(color: colorScheme.error, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}