import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/document_folder/domain/entities/doucment_entity.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_request.dart';
import 'package:trackify/feature/document_folder/data/repository/document_repository_impl.dart';
import 'package:trackify/feature/document_folder/data/data_sources/document_local_datasources.dart';

/// Generic single-document upload screen — reused for Insurance, PUC, etc.
/// Pass the [title] that should appear in the header.
class DocumentSubScreen extends StatefulWidget {
  final String title;
  final String vehicleId;
  final String subtype;
  final DocumentEntity? initialDocument;

  const DocumentSubScreen({
    super.key,
    required this.title,
    required this.vehicleId,
    required this.subtype,
    this.initialDocument,
  });

  @override
  State<DocumentSubScreen> createState() => _DocumentSubScreenState();
}

class _DocumentSubScreenState extends State<DocumentSubScreen> {
  File? _frontFile;
  File? _backFile;
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _error;
  bool _isPickerActive = false;

  static const int _maxBytes = 5 * 1024 * 1024;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialDocument?.expiryDate != null &&
        widget.initialDocument!.expiryDate!.isNotEmpty) {
      try {
        _selectedDate = DateTime.tryParse(widget.initialDocument!.expiryDate!);
      } catch (_) {}
    }
  }

  bool _isPdf(File f) => f.path.toLowerCase().endsWith('.pdf');
  bool _isValidSize(File f) => f.lengthSync() <= _maxBytes;

  void _setLoading(bool v) => setState(() => _isLoading = v);

  void _setError(String msg) => setState(() {
    _error = msg;
    _isLoading = false;
  });

  // ── DATE PICKER ──────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstAllowedDate = DateTime(now.year, now.month, now.day);
    
    DateTime initDate = _selectedDate ?? firstAllowedDate;
    if (initDate.isBefore(firstAllowedDate)) {
      initDate = firstAllowedDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: firstAllowedDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ── IMAGE PICK ───────────────────────────────────────────────

  Future<void> _pickImage(bool isFront, ImageSource source) async {
    if (_isPickerActive) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isPickerActive = true;
      _isLoading = true;
      _error = null;
    });

    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 50);
      if (picked == null) {
        _setLoading(false);
        return;
      }
      final file = File(picked.path);
      final croppedFile = await _cropImage(file);
      if (croppedFile == null) {
        _setLoading(false);
        return;
      }
      if (!_isValidSize(croppedFile)) {
        _setError(l10n.fileTooLarge);
        return;
      }
      setState(() {
        if (isFront) {
          _frontFile = croppedFile;
        } else {
          _backFile = croppedFile;
        }
        _isLoading = false;
      });
    } catch (_) {
      _setError(l10n.pickImageError);
    } finally {
      if (mounted) setState(() => _isPickerActive = false);
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final l10n = AppLocalizations.of(context)!;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cropDocument,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: l10n.cropDocument),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  // ── PDF PICK ─────────────────────────────────────────────────

  Future<void> _pickPDF(bool isFront) async {
    if (_isPickerActive) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isPickerActive = true;
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null || result.files.single.path == null) {
        _setLoading(false);
        return;
      }
      final file = File(result.files.single.path!);
      if (!_isValidSize(file)) {
        _setError(l10n.pdfTooLarge);
        return;
      }
      setState(() {
        if (isFront) {
          _frontFile = file;
        } else {
          _backFile = file;
        }
        _isLoading = false;
      });
    } catch (_) {
      _setError(l10n.pickPdfError);
    } finally {
      if (mounted) setState(() => _isPickerActive = false);
    }
  }

  // ── BOTTOM SHEET ─────────────────────────────────────────────

  void _showPicker(bool isFront) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              // Title
              Text(
                l10n.uploadImage,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 28),
              // Circular buttons row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _circleOption(
                    icon: Icons.camera_alt_outlined,
                    label: l10n.camera,
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _pickImage(isFront, ImageSource.camera);
                    },
                  ),
                  SizedBox(width: 10),
                  _circleOption(
                    icon: Icons.photo_library_outlined,
                    label: l10n.gallery,
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _pickImage(isFront, ImageSource.gallery);
                    },
                  ),
                  SizedBox(width: 10),
                  _circleOption(
                    icon: Icons.picture_as_pdf_outlined,
                    label: l10n.pdf,
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));
                      _pickPDF(isFront);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.outlineVariant, width: 1),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final hasFront = widget.initialDocument != null;
    if (_frontFile == null && !hasFront) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.frontRequired)),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<int>? frontBytes;
      String? frontName;
      if (_frontFile != null) {
        frontBytes = await _frontFile!.readAsBytes();
        frontName = _frontFile!.path.split('/').last;
      }

      List<int>? backBytes;
      String? backName;
      if (_backFile != null) {
        backBytes = await _backFile!.readAsBytes();
        backName = _backFile!.path.split('/').last;
      }

      final request = DocumentUploadRequest(
        vehicleId: widget.vehicleId,
        type: 'personal',
        subtype: widget.subtype,
        expiryDate: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
      );

      final repo = DocumentRepositoryImpl(DocumentLocalDataSource(ImagePicker()));
      final isEdit = widget.initialDocument != null && widget.initialDocument!.id.isNotEmpty;

      final result = isEdit
          ? await repo.updateDocument(
              documentId: widget.initialDocument!.id,
              request: request,
              frontImageBytes: frontBytes,
              frontImageName: frontName,
              backImageBytes: backBytes,
              backImageName: backName,
            )
          : await repo.uploadDocument(
              request: request,
              frontImageBytes: frontBytes,
              frontImageName: frontName,
              backImageBytes: backBytes,
              backImageName: backName,
            );

      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        },
        (response) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? l10n.successMessage)),
          );
          Navigator.pop(context, true);
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── BUILD ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final dateLabel = _selectedDate == null
        ? l10n.selectExpiryDate
        : DateFormat('dd MMM yyyy').format(_selectedDate!);

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
          widget.title,
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
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 24),

                    if (_isLoading) const LinearProgressIndicator(),
                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),

                    const SizedBox(height: 20),

                    // ── Expiry Date ────────────────────────────
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        height: screenHeight * 0.055,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                     
                          ),
                        
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dateLabel,
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      l10n.uploadDocuments,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _uploadBox(true, _frontFile, l10n.frontSide),
                        const SizedBox(width: 12),
                        _uploadBox(false, _backFile, l10n.backSide),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      l10n.commitmentText,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(Icons.shield, color: Colors.green, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          l10n.documentsSafe,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Sticky Save Button ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Builder(
                builder: (context) {
                  final hasFront = _frontFile != null ||
                      (widget.initialDocument?.fontpath != null &&
                          widget.initialDocument!.fontpath!.isNotEmpty);
                  return GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            if (!hasFront) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.frontRequired,
                                  ),
                                ),
                              );
                              return;
                            }
                            _submit();
                          },
                    child: Container(
                      height: screenHeight * 0.055,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: (!hasFront || _isLoading)
                            ? colorScheme.outline
                            : colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.initialDocument != null
                              ? l10n.update
                              : l10n.addDocument,
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
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

  // ── UPLOAD BOX ───────────────────────────────────────────────

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path.startsWith('http') ? path : '${ApiURL.baseURL}/$path';
  }

  Widget _uploadBox(bool isFront, File? file, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final existingPath = isFront
        ? widget.initialDocument?.fontpath
        : widget.initialDocument?.backpath;
    final existingUrl = _getImageUrl(existingPath);

    return GestureDetector(
      onTap: () => _showPicker(isFront),
      child: Container(
        width: size.width * 0.42,
        height: size.width * 0.42,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
          borderRadius: BorderRadius.circular(12),
          
          ),
        
        child: file == null
            ? (existingUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      existingUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            label,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: colorScheme.onSurfaceVariant,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isPdf(file)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 32,
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              file.path.split('/').last,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : Image.file(
                        file,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
      ),
    );
  }
}
