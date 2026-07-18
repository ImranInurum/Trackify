import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/document_folder/presentation/widegt/text_field_widgets.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/feature/document_folder/data/models/document_upload_request.dart';
import 'package:trackify/feature/document_folder/data/repository/document_repository_impl.dart';
import 'package:trackify/feature/document_folder/data/data_sources/document_local_datasources.dart';

class AccessoryBillScreen extends StatefulWidget {
  final String imei;

  const AccessoryBillScreen({super.key, required this.imei});

  @override
  State<AccessoryBillScreen> createState() => _AccessoryBillScreenState();
}

class _AccessoryBillScreenState extends State<AccessoryBillScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopContactController = TextEditingController();
  File? _frontFile;
  File? _backFile;
  DateTime? _billingDate;
  DateTime? _warrantyExpiryDate;
  bool _isLoading = false;
  String? _error = null;
  bool _isPickerActive = false;

  static const int _maxBytes = 5 * 1024 * 1024;
  final ImagePicker _picker = ImagePicker();

  bool _isPdf(File f) => f.path.toLowerCase().endsWith('.pdf');
  bool _isValidSize(File f) => f.lengthSync() <= _maxBytes;

  void _setLoading(bool v) => setState(() => _isLoading = v);

  void _setError(String msg) => setState(() {
    _error = msg;
    _isLoading = false;
  });

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _shopNameController.dispose();
    _shopContactController.dispose();
    super.dispose();
  }

  // ── DATE PICKER ─────────────────────────────────────────────

  Future<void> _pickBillingDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _billingDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (picked != null) setState(() => _billingDate = picked);
  }

  Future<void> _pickWarrantyExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _warrantyExpiryDate ?? now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (picked != null) setState(() => _warrantyExpiryDate = picked);
  }

  Future<void> _pickImage(bool isFront, ImageSource source) async {
    if (_isPickerActive) return;


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

      // ✅ CLOSE bottom sheet HERE (correct timing)
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      final file = File(picked.path);
      final croppedFile = await _cropImage(file);

      if (croppedFile == null) {
        _setLoading(false);
        return;
      }

      if (!_isValidSize(croppedFile)) {
        _setError(AppLocalizations.of(context)!.fileTooLarge);
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
    } catch (e) {
      debugPrint("Pick error: $e");
      _setError(AppLocalizations.of(context)!.errorPickingImage);
    } finally {
      if (mounted) {
        setState(() => _isPickerActive = false);
      }
    }
  }

  Future<File?> _cropImage(File imageFile) async {

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context)!.cropDocument,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
          ),
          IOSUiSettings(title: AppLocalizations.of(context)!.cropDocument),
        ],
      );

      if (croppedFile == null) return null;

      return File(croppedFile.path);
    } catch (e) {
      debugPrint("Crop error: $e");
      return null;
    }
  }


  // ── BOTTOM SHEET ─────────────────────────────────────────────

  void _showPicker(bool isFront) {

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
                AppLocalizations.of(context)!.uploadImage,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _circleOption(
                    icon: Icons.camera_alt_outlined,
                    label: AppLocalizations.of(context)!.camera,
                    onTap: () {
                      _pickImage(isFront, ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: 10),
                  _circleOption(
                    icon: Icons.photo_library_outlined,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () {
                      _pickImage(isFront, ImageSource.gallery);
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
    if (_frontFile == null) {
      setState(() => _error = l10n.frontDocumentRequired);
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = l10n.accessoryName + " is required");
      return;
    }

    if (_billingDate == null) {
      setState(() => _error = l10n.billingDate + " is required");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final frontBytes = await _frontFile!.readAsBytes();
      final frontName = _frontFile!.path.split('/').last;

      List<int>? backBytes;
      String? backName;
      if (_backFile != null) {
        backBytes = await _backFile!.readAsBytes();
        backName = _backFile!.path.split('/').last;
      }

      final request = DocumentUploadRequest(
        imei: widget.imei,
        type: 'personal',
        subtype: 'accessory_bill',
        title: _nameController.text.trim(),
        billingDate: DateFormat('yyyy-MM-dd').format(_billingDate!),
        billingAmount: double.tryParse(_amountController.text.trim()),
        shopName: _shopNameController.text.trim(),
        shopContact: _shopContactController.text.trim(),
        warrantyExpiry: _warrantyExpiryDate != null
            ? DateFormat('yyyy-MM-dd').format(_warrantyExpiryDate!)
            : null,
      );

      final repo = DocumentRepositoryImpl(DocumentLocalDataSource(ImagePicker()));
      final result = await repo.uploadDocument(
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
            SnackBar(content: Text(response.message ?? l10n.documentUploadedSuccessfully)),
          );
          Navigator.pop(context);
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── UI ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final billingDateLabel = _billingDate == null
        ? null
        : DateFormat('dd / MM / yyyy').format(_billingDate!);
    final warrantyExpiryLabel = _warrantyExpiryDate == null
        ? AppLocalizations.of(context)!.selectExpiryDate
        : DateFormat('dd / MM / yyyy').format(_warrantyExpiryDate!);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context)!.addAccessoryBill),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    if (_isLoading) const LinearProgressIndicator(),

                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),

                    SizedBox(height: screenHeight * 0.02),

                    // ── Document Name ────────────────────────────────
                    TextFieldWidgets(
                      controller: _nameController,
                      hintText: AppLocalizations.of(context)!.accessoryName,
                      isRequired: true,
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child:          GestureDetector(
                            onTap: _pickBillingDate,
                            child: Container(
                              height: screenHeight * 0.055,
                              width: screenWidth * 0.42,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: billingDateLabel != null
                                        ? Text(
                                            billingDateLabel,
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text.rich(
                                            TextSpan(
                                              text: AppLocalizations.of(context)!.billingDate,
                                              children: const [
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ],
                                            ),
                                            style: TextStyle(
                                              color: colorScheme.onSurfaceVariant,
                                              fontSize: 14,
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
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFieldWidgets(
                            controller: _amountController,
                            hintText: AppLocalizations.of(context)!.billingAmount,
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(Icons.currency_rupee, size: 18, color: colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidgets(
                      controller: _shopNameController,
                      hintText: AppLocalizations.of(context)!.shopName,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidgets(
                      controller: _shopContactController,
                      hintText: AppLocalizations.of(context)!.shopContact,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickWarrantyExpiryDate,
                      child: Container(
                        height: screenHeight * 0.055,
                        width: screenWidth * 0.42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                warrantyExpiryLabel,
                                style: TextStyle(
                                  color: _warrantyExpiryDate == null
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.onSurface,
                                  fontSize: 14,
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

                    Text(AppLocalizations.of(context)!.uploadBill),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _uploadBox(true, _frontFile, AppLocalizations.of(context)!.addImage),
                        const SizedBox(width: 12),
                        _uploadBox(false, _backFile, AppLocalizations.of(context)!.addImage),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    Text(
                      AppLocalizations.of(context)!.maxFileSizeNote,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeightManager.medium,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (_frontFile == null || _isLoading) ? null : _submit,
              child: Container(
                height: screenHeight * 0.055,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (_frontFile == null || _isLoading)
                      ? colorScheme.outline
                      : colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.addDocument,
                    style: TextStyle(color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  // ── UPLOAD BOX ─────────────────────────────────────────────

  Widget _uploadBox(bool isFront, File? file, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _showPicker(isFront),
      child: Container(
        width: size.width * 0.42,
        height: size.width * 0.32,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: file == null
            ? Column(
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
        )
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