import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/app_updates/presentiation/pages/update_screen.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/app_web_view_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/my_issue_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/time_slot_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'package:trackify/feature/help_and_support/data/repository_impl/help_repository_impl.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_cubit.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_support_cubit.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/time_slot_cubit.dart';
import 'package:trackify/feature/help_and_support/data/model/report_issue_model.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../../data/model/suggestion_model.dart';
import '../cubit/suggestion_cubit.dart';

class HelpSuggestionScreen extends StatefulWidget {
  final bool isReportIssue;
  const HelpSuggestionScreen({super.key, this.isReportIssue = true});

  @override
  State<HelpSuggestionScreen> createState() => _HelpSuggestionScreenState();
}

class _HelpSuggestionScreenState extends State<HelpSuggestionScreen> {
  late bool isReportIssue;

  String? selectedVehicleId;
  String? selectedVehicleImei;
  String? selectedCallSlotId;
  String? selectedSuggestionType;
  String _appVersion = 'v19.7.1';

  final TextEditingController issueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    isReportIssue = widget.isReportIssue;
    _loadAppVersion();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ServiceLogsCubit>().loadVehicles();
      }
    });
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = 'v${info.version}';
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    issueController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.helpAndSuggestion,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: FontFamilyManager.fontFamily,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIssueCard(l10n, theme, isDark),
                const SizedBox(height: 16),
                _buildMenuRow(
                  isReportIssue ? l10n.myIssues : l10n.mySuggestions,
                  icon: isReportIssue ? Icons.assignment_outlined : Icons.lightbulb_outline,
                  theme: theme,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => HelpCubit(HelpRepositoryImpl()),
                          child: MyIssueScreen(isSuggestion: !isReportIssue),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildBottomMenu(l10n, theme, isDark),
                const SizedBox(height: 40),
                _buildVersionInfo(theme, isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuggestionTypeSelector(BuildContext context, AppLocalizations l10n) {
    FocusScope.of(context).unfocus();
    
    final types = [
      {"value": "design", "label": l10n.designOption},
      {"value": "functionality", "label": l10n.functionalityOption},
      {"value": "other", "label": l10n.otherOption},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  final isSelected = selectedSuggestionType == type["value"];
                  return ListTile(
                    title: Text(
                      type["label"]!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? const Color(0xFF0284C7) : theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Color(0xFF0284C7))
                        : null,
                    onTap: () {
                      setState(() {
                        selectedSuggestionType = type["value"];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIssueCard(AppLocalizations l10n, ThemeData theme, bool isDark) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colorScheme.outline.withOpacity(0.15) : const Color(0xFFE2E8F0),
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
          /// MODERN SEGMENTED TAB SWITCHER
          Container(
            height: 44,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.onSurface.withOpacity(0.08) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                /// REPORT ISSUE TAB
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isReportIssue = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isReportIssue
                            ? (isDark ? colorScheme.surface : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: isReportIssue
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        l10n.reportAnIssue,
                        style: TextStyle(
                          color: isReportIssue ? const Color(0xFF0284C7) : colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: isReportIssue ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                /// SUGGESTION TAB
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isReportIssue = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !isReportIssue
                            ? (isDark ? colorScheme.surface : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: !isReportIssue
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        l10n.suggestion,
                        style: TextStyle(
                          color: !isReportIssue ? const Color(0xFF0284C7) : colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: !isReportIssue ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// HEADER TITLE WITH ICON BADGE
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isReportIssue ? Icons.bug_report_outlined : Icons.lightbulb_outline,
                  color: const Color(0xFF0284C7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isReportIssue ? l10n.reportAnIssue : l10n.suggestion,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isReportIssue
                        ? l10n.iHaveAnIssueWith
                        : l10n.iWantToProvideSuggestion,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// DROPDOWN CONTAINER / VEHICLE SELECTOR
          isReportIssue
              ? BlocBuilder<ServiceLogsCubit, ServiceLogsState>(
                  builder: (context, serviceState) {
                    if (serviceState is ServiceLogsLoaded) {
                      final bool vehicleExists = serviceState.vehicles.any((v) => v.id == selectedVehicleId);
                      if (!vehicleExists || selectedVehicleId == null) {
                        selectedVehicleId = serviceState.selectedVehicle?.id;
                        selectedVehicleImei = serviceState.selectedVehicle?.imei;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.onSurface.withOpacity(0.05) : const Color(0xFFF8FAFC),
                          border: Border.all(
                            color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: VehicleSelectionAppBar(
                          isMinimal: true,
                          title: l10n.selectVehicle,
                          selectedVehicle: serviceState.selectedVehicle,
                          vehicles: serviceState.vehicles,
                          onBack: () => Navigator.pop(context),
                          onVehicleSelected: (vehicle) {
                            context.read<ServiceLogsCubit>().selectVehicle(
                              vehicle.id!,
                            );
                            setState(() {
                              selectedVehicleId = vehicle.id;
                              selectedVehicleImei = vehicle.imei;
                            });
                          },
                        ),
                      );
                    }
                    return Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.onSurface.withOpacity(0.05) : const Color(0xFFF8FAFC),
                        border: Border.all(
                          color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                )
              : GestureDetector(
                  onTap: () => _showSuggestionTypeSelector(context, l10n),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.onSurface.withOpacity(0.05) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedSuggestionType == "design" ? l10n.designOption :
                            selectedSuggestionType == "functionality" ? l10n.functionalityOption :
                            selectedSuggestionType == "other" ? l10n.otherOption :
                            l10n.selectType,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: selectedSuggestionType == null 
                                  ? colorScheme.onSurface.withOpacity(0.4)
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF0284C7),
                        ),
                      ],
                    ),
                  ),
                ),

          const SizedBox(height: 16),

          /// SUBJECT INPUT FIELD
          TextField(
            controller: issueController,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: isReportIssue
                  ? l10n.whatIsYourIssueRelatedTo
                  : l10n.whatIsSuggestionSubject,
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.4),
                fontSize: 14,
              ),
              filled: true,
              fillColor: isDark ? colorScheme.onSurface.withOpacity(0.05) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// DESCRIPTION INPUT FIELD
          TextField(
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: isReportIssue
                  ? l10n.giveShortDescription
                  : l10n.giveSuggestionFeedback,
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.4),
                fontSize: 14,
              ),
              filled: true,
              fillColor: isDark ? colorScheme.onSurface.withOpacity(0.05) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
              ),
            ),
          ),

          if (_showValidationError) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 14),
                const SizedBox(width: 4),
                Text(
                  l10n.allFieldsMandatory,
                  style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          /// SUBMIT / SELECT CALL SLOT GRADIENT CTA BUTTON
          BlocListener<SuggestionCubit, SuggestionState>(
            listener: (context, suggestionState) {
              if (suggestionState is SuggestionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(suggestionState.message)),
                );
                issueController.clear();
                descriptionController.clear();
                setState(() {
                  selectedSuggestionType = null;
                });
              }
              if (suggestionState is SuggestionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(suggestionState.error)),
                );
              }
            },
            child: BlocConsumer<ReportIssueCubit, ReportIssueState>(
              listener: (context, state) {
                if (state is ReportIssueSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  setState(() {
                    selectedCallSlotId = null;
                  });
                  issueController.clear();
                  descriptionController.clear();
                }

                if (state is ReportIssueError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                final isSuggestionLoading = context.watch<SuggestionCubit>().state is SuggestionLoading;
                final isLoading = state is ReportIssueLoading || isSuggestionLoading;

                return GestureDetector(
                  onTap: isLoading
                      ? null
                      : () async {
                          final token = AppPreference.instance.getSync(
                            key: AppPreference.KEY_TOKEN,
                          );

                          if (isReportIssue) {
                            if (selectedVehicleId == null ||
                                selectedVehicleId!.isEmpty ||
                                issueController.text.trim().isEmpty ||
                                descriptionController.text.trim().isEmpty) {
                              setState(() => _showValidationError = true);
                              return;
                            }
                            setState(() => _showValidationError = false);

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => BookingSlotCubit()..getSlots(),
                                  child: const BookCallSlotScreen(),
                                ),
                              ),
                            );

                            if (result != null) {
                              context.read<ReportIssueCubit>().submitIssue(
                                token: token,
                                request: ReportIssueRequest(
                                  userId: AppPreference.instance.getSync(
                                    key: AppPreference.KEY_USER_ID,
                                  ) ?? "",
                                  vehicleId: (selectedVehicleId != null && selectedVehicleId!.isNotEmpty)
                                      ? selectedVehicleId!
                                      : (selectedVehicleImei ?? ""),
                                  issueType: "report_issue",
                                  issueRelatedTo: issueController.text,
                                  description: descriptionController.text,
                                  callSlotId: result,
                                ),
                              );
                            }
                          } else {
                            if (selectedSuggestionType == null ||
                                selectedSuggestionType!.isEmpty ||
                                issueController.text.trim().isEmpty ||
                                descriptionController.text.trim().isEmpty) {
                              setState(() => _showValidationError = true);
                              return;
                            }
                            setState(() => _showValidationError = false);

                            context.read<SuggestionCubit>().submitSuggestion(
                              token: token,
                              request: SuggestionRequest(
                                userId: AppPreference.instance.getSync(
                                  key: AppPreference.KEY_USER_ID,
                                ),
                                suggestionType: selectedSuggestionType ?? "other",
                                subject: issueController.text,
                                description: descriptionController.text,
                              ),
                            );
                          }
                        },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0284C7),
                          Color(0xFF0369A1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isReportIssue ? l10n.selectCallSlot : l10n.send,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(
    String title, {
    required IconData icon,
    required ThemeData theme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? colorScheme.outline.withOpacity(0.15) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0284C7),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomMenu(AppLocalizations l10n, ThemeData theme, bool isDark) {
    final colorScheme = theme.colorScheme;

    final menuItems = [
      {
        "title": l10n.faq,
        "icon": Icons.help_outline_rounded,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppWebViewScreen(
                title: l10n.faq,
                url: '${ApiURL.baseURL}/faq.html',
              ),
            ),
          );
        }
      },
      {
        "title": l10n.termsConditions,
        "icon": Icons.description_outlined,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppWebViewScreen(
                title: l10n.termsConditions,
                url: '${ApiURL.baseURL}/terms.html',
              ),
            ),
          );
        }
      },
      {
        "title": l10n.privacyPolicy,
        "icon": Icons.shield_outlined,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppWebViewScreen(
                title: l10n.privacyPolicy,
                url: '${ApiURL.baseURL}/privacy_policy.html',
              ),
            ),
          );
        }
      },
      {
        "title": l10n.changeLog,
        "icon": Icons.system_update_outlined,
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UpdateScreen(),
            ),
          );
        }
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colorScheme.outline.withOpacity(0.15) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          final isLast = index == menuItems.length - 1;

          return InkWell(
            onTap: item["onTap"] as VoidCallback,
            borderRadius: BorderRadius.vertical(
              top: index == 0 ? const Radius.circular(16) : Radius.zero,
              bottom: isLast ? const Radius.circular(16) : Radius.zero,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item["icon"] as IconData,
                          color: const Color(0xFF0284C7),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item["title"] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 52,
                    endIndent: 16,
                    color: isDark ? colorScheme.outline.withOpacity(0.15) : const Color(0xFFF1F5F9),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVersionInfo(ThemeData theme, bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.onSurface.withOpacity(0.06) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Trackify  •  $_appVersion",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
