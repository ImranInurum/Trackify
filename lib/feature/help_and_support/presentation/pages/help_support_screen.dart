import 'package:flutter/material.dart';
import 'package:trackify/l10n/app_localizations.dart';

class HelpSuggestionScreen extends StatefulWidget {
  const HelpSuggestionScreen({super.key});

  @override
  State<HelpSuggestionScreen> createState() => _HelpSuggestionScreenState();
}

class _HelpSuggestionScreenState extends State<HelpSuggestionScreen> {
  bool isReportIssue = true;

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
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.helpAndSuggestion,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIssueCard(l10n),
              const SizedBox(height: 16),
              _buildMenuRow(l10n.myIssues, onTap: () {}),
              const SizedBox(height: 12),
              _buildWhatsAppButton(l10n),
              const SizedBox(height: 24),
              _buildForceMigrateSection(l10n),
              const SizedBox(height: 24),
              _buildBottomMenu(l10n),
              const SizedBox(height: 48),
              _buildVersionInfo(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Toggle
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => isReportIssue = true),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isReportIssue ? Theme.of(context).cardColor : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(3)),
                      ),
                      child: Text(
                        l10n.reportAnIssue,
                        style: TextStyle(
                          color: isReportIssue ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 1, color: Theme.of(context).dividerColor),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => isReportIssue = false),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !isReportIssue ? Theme.of(context).cardColor : Colors.transparent,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(3)),
                      ),
                      child: Text(
                        l10n.suggestion,
                        style: TextStyle(
                          color: !isReportIssue ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isReportIssue ? l10n.reportAnIssue : l10n.suggestion,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: l10n.whatIsYourIssueRelatedTo,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: l10n.shortDescriptionHint,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                l10n.selectCallSlot,
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
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
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
            Icon(Icons.arrow_forward_ios, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
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
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, color: Color(0xFF25D366), size: 20),
          const SizedBox(width: 8),
          Text(l10n.whatsApp, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildForceMigrateSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.forceMigrate, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          l10n.forceMigrateDesc1,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.forceMigrateDesc2,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              l10n.forceMigrate,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomMenu(AppLocalizations l10n) {
    return Column(
      children: [
        _buildSimplifiedMenuRow(l10n.faq),
        _buildSimplifiedMenuRow(l10n.termsConditions),
        _buildSimplifiedMenuRow(l10n.privacyPolicy),
        _buildSimplifiedMenuRow(l10n.changeLog),
      ],
    );
  }

  Widget _buildSimplifiedMenuRow(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
            Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return  Align(
      alignment: Alignment.centerRight,
      child: Text(
        "B3000507.V19.7.1.J406",
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4), fontSize: 12),
      ),
    );
  }
}
