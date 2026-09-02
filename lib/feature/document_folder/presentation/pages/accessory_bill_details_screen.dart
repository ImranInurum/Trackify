import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/feature/document_folder/presentation/cubit/document_folder_cubit.dart';
import 'package:trackify/feature/document_folder/presentation/pages/accessory_bill_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AccessoryBillDetailsScreen extends StatelessWidget {
  final DocumentEntity bill;
  final String vehicleId;

  const AccessoryBillDetailsScreen({
    super.key,
    required this.bill,
    required this.vehicleId,
  });

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path.startsWith('http') ? path : '${ApiURL.baseURL}/$path';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final frontUrl = _getImageUrl(bill.fontpath);
    final backUrl = _getImageUrl(bill.backpath);
    final images = [
      if (frontUrl.isNotEmpty) frontUrl,
      if (backUrl.isNotEmpty) backUrl,
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          bill.title ?? 'Accessory Bill',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: colorScheme.onSurface),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.deleteAlertTitle),
                  content: Text(
                    l10n.deleteAlertDescription,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        if (bill.id.isNotEmpty) {
                          final cubit = context.read<DocumentFolderCubit>();
                          final success = await cubit.deleteDocument(bill.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.successMessage),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context, true);
                          }
                        }
                      },
                      child: Text(
                        l10n.delete,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: colorScheme.onSurface),
            onPressed: () async {
              final res = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => AccessoryBillScreen(
                    vehicleId: vehicleId,
                    initialDocument: bill,
                  ),
                ),
              );
              if (res == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5), width: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    colorScheme,
                    'Accessory Name',
                    bill.title ?? 'N/A',
                    '',
                    '',
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    colorScheme,
                    'Date',
                    _formatDate(bill.billingDate),
                    'Amount',
                    bill.billingAmount != null
                        ? '₹${bill.billingAmount}'
                        : 'N/A',
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    colorScheme,
                    'Shop Name',
                    bill.shopName ?? 'N/A',
                    '',
                    '',
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    colorScheme,
                    'Shop Contact',
                    bill.shopContact ?? 'N/A',
                    '',
                    '',
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    colorScheme,
                    'Warranty',
                    _formatDate(bill.warrantyExpiry),
                    '',
                    '',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Document Images', // Can be localized later
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200, // Fixed height for images section
              child: images.isEmpty
                  ? Center(
                      child: Text(
                        'No images available',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final imageUrl = images[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl.toLowerCase().endsWith('.pdf')
                              ? Container(
                                  color: colorScheme.surfaceVariant,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'PDF Document',
                                        style: TextStyle(
                                          color: colorScheme.onSurface,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          backgroundColor: Colors.black,
                                          appBar: AppBar(
                                            backgroundColor: Colors.black,
                                            iconTheme: const IconThemeData(
                                                color: Colors.white),
                                          ),
                                          body: Center(
                                            child: InteractiveViewer(
                                              minScale: 0.5,
                                              maxScale: 4.0,
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 48,
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
      ),
    );
  }

  Widget _buildDetailRow(
    ColorScheme colorScheme,
    String title1,
    String value1,
    String title2,
    String value2,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title1,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (title2.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value2,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
