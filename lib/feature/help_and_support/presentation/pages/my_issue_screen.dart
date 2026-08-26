import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:trackify/l10n/app_localizations.dart';
import '../../data/model/my_issue_model.dart';
import '../../data/model/suggestion_model.dart';
import '../cubit/help_cubit.dart';
import '../cubit/help_state.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class MyIssueScreen
    extends StatefulWidget {
  final bool isSuggestion;
  const MyIssueScreen({
    super.key,
    this.isSuggestion = false,
  });


  @override
  State<MyIssueScreen> createState() =>
      _MyIssueScreenState();
}

class _MyIssueScreenState
    extends State<MyIssueScreen> {

  @override
  void initState() {
    super.initState();
    if (widget.isSuggestion) {
      context.read<HelpCubit>().getMySuggestions();
    } else {
      context.read<HelpCubit>().getMyIssues();
    }
  }

  @override
  Widget build(BuildContext context) {





    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.isSuggestion ? l10n.mySuggestions : l10n.myIssues),
      ),

      body: BlocBuilder<
          HelpCubit,
          HelpState>(
        builder: (context, state) {

          if (state.isLoading) {
            return const Center(child: TrackifyLoader());
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
              ),
            );
          }

          if (!state.isLoading && state.error == null) {

            final items = widget.isSuggestion ? state.suggestions : state.issues;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  widget.isSuggestion ? "No suggestions found" : "No issues found",
                ),
              );
            }

            return ListView.builder(
              padding:
              const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder:
                  (context, index) {

                final item = items[index];

                if (widget.isSuggestion) {
                  final suggestion = item as MySuggestionModel;
                  return _buildSuggestionCard(suggestion, theme);
                }

                final issue = item as MyIssueModel;

                return Container(
                  margin:
                  const EdgeInsets.only(
                    bottom: 16,
                  ),

                  padding:
                  const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color:
                    theme.cardColor,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),

                    border: Border.all(
                      color: theme
                          .dividerColor,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [

                          Expanded(
                            child: Text(
                              issue.issueType == 'suggestion'
                                  ? issue.description
                                  : issue.issueRelatedTo,

                              style:
                              const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),

                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration:
                            BoxDecoration(
                              color: issue.statusColor ?? theme.primaryColor,

                              borderRadius:
                              BorderRadius
                                  .circular(
                                30,
                              ),
                            ),

                            child: Text(
                              issue
                                  .issueStatus,

                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      Row(
                        children: [

                          const Icon(
                            Icons
                                .directions_car,
                            size: 18,
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Text(
                            issue
                                .vehicleNumber,
                          ),
                        ],
                      ),

                      if (issue.issueType != 'suggestion') ...[
                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          issue.description,

                          style: TextStyle(color: theme
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 
                              0.7,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                      ],

                      if (issue.callSlot != null) ...[
                        Container(
                          padding:
                          const EdgeInsets
                              .all(14),

                          decoration:
                          BoxDecoration(
                            color: theme
                                .scaffoldBackgroundColor,

                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),

                          child: Column(
                            children: [

                              if (issue.callSlot?.dateText.isNotEmpty ?? false) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 16,
                                      color: Color(0xFF0284C7),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      issue.callSlot!.dateText,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (issue.callSlot?.displayTime.isNotEmpty ?? false) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 16,
                                      color: Color(0xFF0284C7),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      issue.callSlot!.displayTime,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 14,
                        ),
                      ],

                      Text(
                        DateFormat(
                          'dd MMM yyyy',
                        ).format(
                          issue.createdAt,
                        ),

                        style: TextStyle(color: theme
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 
                            0.5,
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildSuggestionCard(MySuggestionModel suggestion, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  suggestion.subject,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue, 
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  suggestion.status,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Type: ${suggestion.suggestionType}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion.description,
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 14),
          Text(
            DateFormat('dd MMM yyyy').format(suggestion.createdAt),
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
          ),
        ],
      ),
    );
  }
}