import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/app_updates/presentiation/pages/update_screen.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/app_web_view_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/my_issue_screen.dart';
import 'package:trackify/feature/help_and_support/presentation/pages/time_slot_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';

import 'package:trackify/feature/help_and_support/data/repository_impl/help_repository_impl.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_cubit.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_state.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/help_support_cubit.dart';
import 'package:trackify/feature/help_and_support/presentation/cubit/time_slot_cubit.dart';
import 'package:trackify/feature/help_and_support/data/model/report_issue_model.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_cubit.dart';
import 'package:trackify/feature/service_logs/presentation/cubit/service_logs_state.dart';
import 'package:trackify/feature/service_logs/presentation/widgets/vehicle_selection_app_bar.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';

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

  final TextEditingController issueController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    isReportIssue = widget.isReportIssue;

    // Load fresh vehicles for current user session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ServiceLogsCubit>().loadVehicles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.helpAndSuggestion, ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIssueCard(l10n),
                const SizedBox(height: 16),
                _buildMenuRow(
                  isReportIssue ? l10n.myIssues : l10n.mySuggestions,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) {
                            return HelpCubit(HelpRepositoryImpl());
                          },
                          child: MyIssueScreen(isSuggestion: !isReportIssue),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // _buildWhatsAppButton(l10n),
                // const SizedBox(height: 24),
                // _buildForceMigrateSection(l10n),
                // const SizedBox(height: 24),
                _buildBottomMenu(l10n),
                const SizedBox(height: 48),
                _buildVersionInfo(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuggestionTypeSelector(BuildContext context, AppLocalizations l10n) {
    FocusScope.of(context).unfocus(); // Close keyboard before showing sheet
    
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
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
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

  Widget _buildIssueCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOGGLE
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                /// REPORT ISSUE
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isReportIssue = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(3),
                        ),
                      ),
                      child: Text(
                        l10n.reportAnIssue,
                        style: TextStyle(color: isReportIssue
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                VerticalDivider(
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),

                /// SUGGESTION
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isReportIssue = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(3),
                        ),
                      ),
                      child: Text(
                        l10n.suggestion,
                        style: TextStyle(color: !isReportIssue
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// TITLE
          Text(
            isReportIssue
                ? l10n.reportAnIssue
                : l10n.suggestion, // Or another key if available
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 18),

          /// SUBTITLE
          Text(
            isReportIssue
                ? l10n.iHaveAnIssueWith
                : l10n.iWantToProvideSuggestion,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 14),

          /// DROPDOWN CONTAINER
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
                        padding: const EdgeInsets.symmetric(vertical: 1.2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
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
                              selectedVehicleImei =
                                  vehicle.imei;
                            });
                          },
                        ),
                      );
                    }
                    return Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(4),
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
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
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
                              color: selectedSuggestionType == null 
                                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),

          const SizedBox(height: 26),

          /// SUBJECT FIELD
          TextField(
            controller: issueController,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: isReportIssue
                  ? l10n.whatIsYourIssueRelatedTo
                  : l10n.whatIsSuggestionSubject,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                fontSize: 15,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// DESCRIPTION FIELD
          TextField(
            controller: descriptionController,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              counterText: "",
              hintText: isReportIssue
                  ? l10n.giveShortDescription
                  : l10n.giveSuggestionFeedback,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                fontSize: 15,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (_showValidationError)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                l10n.allFieldsMandatory,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),


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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  setState(() {
                    selectedCallSlotId = null;
                  });
                  issueController.clear();
                  descriptionController.clear();
                }

                if (state is ReportIssueError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },

              builder: (context, state) {
                final isSuggestionLoading = context.watch<SuggestionCubit>().state is SuggestionLoading;
                final isLoading = state is ReportIssueLoading || isSuggestionLoading;
                return Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: isLoading
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
                                    create: (_) =>
                                        BookingSlotCubit()..getSlots(),
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

                              print("BUTTON CLICKED");
                              print(selectedSuggestionType);
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

                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            isReportIssue
                                ? l10n.selectCallSlot
                                : l10n.send,

                            style: TextStyle(color: Theme.of(context).colorScheme.primary,

                              fontWeight: FontWeight.bold,

                              fontSize: 15,
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

  Widget _buildMenuRow(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFF25D366),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.whatsApp,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForceMigrateSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.forceMigrate,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.forceMigrateDesc1,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.forceMigrateDesc2,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.forceMigrate,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomMenu(AppLocalizations l10n) {
    return Column(
      children: [
        _buildSimplifiedMenuRow(l10n.faq, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppWebViewScreen(
                title: l10n.faq,
                url: 'http://139.59.1.109/faq.html',
              ),
            ),
          );
        }),
        _buildSimplifiedMenuRow(l10n.termsConditions, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppWebViewScreen(
                title: l10n.termsConditions,
                url: 'http://139.59.1.109/terms.html',
              ),
            ),
          );
        }),
        _buildSimplifiedMenuRow(l10n.privacyPolicy, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppWebViewScreen(
                title: l10n.privacyPolicy,
                url: 'http://139.59.1.109/privacy_policy.html',
              ),
            ),
          );
        }),
        _buildSimplifiedMenuRow(l10n.changeLog, onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UpdateScreen(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSimplifiedMenuRow(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        "B3000507.V19.7.1.J406",
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          fontSize: 11,
        ),
      ),
    );
  }
}
