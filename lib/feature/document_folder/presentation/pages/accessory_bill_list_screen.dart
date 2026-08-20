import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/feature/document_folder/presentation/cubit/document_folder_cubit.dart';
import 'package:trackify/feature/document_folder/presentation/cubit/document_folder_state.dart';
import 'package:trackify/feature/document_folder/presentation/pages/accessory_bill_screen.dart';
import 'package:trackify/feature/document_folder/presentation/pages/accessory_bill_details_screen.dart';
import 'package:intl/intl.dart';

class AccessoryBillListScreen extends StatelessWidget {
  final String vehicleId;
  final List<DocumentEntity> bills;

  const AccessoryBillListScreen({
    super.key,
    required this.vehicleId,
    required this.bills,
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
          'View Bills',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: BlocBuilder<DocumentFolderCubit, DocumentFolderState>(
        builder: (context, state) {
          List<DocumentEntity> currentBills = bills;
          if (state is DocumentFolderLoaded) {
            currentBills = state.documents.where((d) => d.subtype == 'accessory_bill').toList();
          }

          if (state is DocumentFolderLoading && currentBills.isEmpty) {
            return const Center(child: TrackifyLoader());
          }

          if (currentBills.isEmpty) {
            return Center(
              child: Text(
                'No bills available',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentBills.length,
            itemBuilder: (context, index) {
              final bill = currentBills[index];
              final imageUrl = _getImageUrl(bill.fontpath ?? bill.backpath);

              return GestureDetector(
                onTap: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AccessoryBillDetailsScreen(
                        bill: bill,
                        vehicleId: vehicleId,
                      ),
                    ),
                  );
                  if (res == true && context.mounted) {
                    context.read<DocumentFolderCubit>().fetchDocuments(vehicleId);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                ),
                              )
                            : Icon(Icons.receipt_long, color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill.title ?? 'Accessory Bill',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.edit_calendar,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Bill Date: ${_formatDate(bill.billingDate)}',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Trailing icon
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AccessoryBillScreen(
                vehicleId: vehicleId,
              ),
            ),
          );
          if (res == true && context.mounted) {
            context.read<DocumentFolderCubit>().fetchDocuments(vehicleId);
          }
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }
}
