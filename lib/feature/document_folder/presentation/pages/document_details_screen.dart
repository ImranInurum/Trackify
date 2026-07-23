import 'package:flutter/material.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/config/network/api_host.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final String title;
  final DocumentEntity document;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DocumentDetailsScreen({
    super.key,
    required this.title,
    required this.document,
    required this.onEdit,
    required this.onDelete,
  });

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${ApiURL.baseURL}/$path';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final expiryDateText = (document.expiryDate != null && document.expiryDate!.isNotEmpty) 
        ? document.expiryDate! 
        : 'N/A';

    final frontUrl = _getImageUrl(document.fontpath);
    final backUrl = _getImageUrl(document.backpath);
    final images = [
      if (frontUrl.isNotEmpty) frontUrl,
      if (backUrl.isNotEmpty) backUrl,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Confirm delete
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.deleteAlertTitle),
                  content: Text(l10n.deleteAlertDescription),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onDelete();
                      },
                      child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.documentNameText,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.expiryDateText,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expiryDateText,
                    style: TextStyle(
                      color: expiryDateText == 'N/A' ? Colors.redAccent : colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.documentImagesText,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: images.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noImagesAvailableText,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: images[index].toLowerCase().endsWith('.pdf')
                              ? Container(
                                  color: theme.cardColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.picture_as_pdf, color: Colors.red, size: 48),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.pdfDocumentText,
                                        style: TextStyle(color: colorScheme.onSurface, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              : Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: theme.cardColor,
                                    child: const Center(child: Icon(Icons.error_outline)),
                                  ),
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
