import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/square_flat_button.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final l10n = AppLocalizations.of(context)!;

  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // Read-only fields (editable via dialog)
  String _mobile = '';
  String _email = '';
  late String _dob = l10n.notAvailable;

  // Dropdowns
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  bool _isSaving = false;

  // --- Static lists (replace with API data as needed) ---
  late final List<Map<String, String>> _countries = [
    {'name': l10n.india, 'flag': '🇮🇳'},
    {'name': l10n.usa, 'flag': '🇺🇸'},
    {'name': l10n.uk, 'flag': '🇬🇧'},
    {'name': l10n.uae, 'flag': '🇦🇪'},
  ];

  late final List<String> _states = [
    l10n.madhyaPradesh,
    l10n.maharashtra,
    l10n.rajasthan,
    l10n.gujarat,
    l10n.karnataka,
    l10n.tamilNadu,
    l10n.uttarPradesh,
    l10n.delhi,
  ];

  late final List<String> _cities = [
    l10n.indoreDistrict,
    l10n.bhopal,
    l10n.gwalior,
    l10n.jabalpur,
    l10n.ujjain,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AppCubit>().state.userData;
      if (user != null) {
        final fullName = user.name ?? '';
        final parts = fullName.trim().split(' ');
        _firstNameCtrl.text = parts.isNotEmpty ? parts[0] : '';
        _lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        _mobile = user.mobileNumber ?? '';
        _email = user.email ?? '';
        _selectedCountry = user.country;
        _selectedState = user.state;
        _selectedCity = user.city;
      } else {
        _firstNameCtrl.text = 'Kk';
        _mobile = '+918602945222';
        _email = 'sonukushwah221@gmail.com';
        _selectedCountry = 'India';
        _selectedState = 'Madhya Pradesh';
        _selectedCity = 'Indore district';
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdatedSuccessfully),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      Navigator.pop(context);
    }
  }

  /// Show a simple dialog to edit read-only field
  void _showEditEmailDialog() {
    final ctrl = TextEditingController(text: _email);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        title: Text(
          l10n.editEmailAddress,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: ctrl,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: l10n.emailAddress,
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                isDense: true,
                contentPadding: const EdgeInsets.only(bottom: 8),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emailNotVerified,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _email = ctrl.text.trim());
              Navigator.pop(context);
            },
            child: Text(
              l10n.saveAndVerify,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditMobileDialog() {
    final ctrl = TextEditingController(text: _mobile.replaceAll('+91', ''));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        title: Text(
          l10n.editMobileNumber,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Text('🇮🇳', style: TextStyle(fontSize: 18)),
                      Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: ctrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: l10n.tenDigitMobileNumber,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      isDense: true,
                      contentPadding: const EdgeInsets.only(bottom: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _mobile = '+91${ctrl.text.trim()}');
              Navigator.pop(context);
            },
            child: Text(
              l10n.saveAndVerify,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pick date of birth
  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: Theme.of(ctx).colorScheme),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _dob =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onSurface = cs.onSurface;
    final dividerColor = theme.dividerColor;

    // Label style (small, dimmed)
    final labelStyle = TextStyle(
      fontSize: 12.5,
      color: onSurface.withValues(alpha: 0.55),
      fontWeight: FontWeight.w400,
    );

    // Value style (white/onSurface, normal)
    final valueStyle = TextStyle(
      fontSize: 15,
      color: onSurface,
      fontWeight: FontWeight.w400,
    );

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              l10n.personalDetails,
              style: TextStyle(
                color: onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── First name ─────────────────────────────────────────
                  _buildUnderlineField(
                    label: l10n.firstName,
                    controller: _firstNameCtrl,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                    dividerColor: dividerColor,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.required : null,
                  ),
                  const SizedBox(height: 24),

                  // ── Middle name (Optional) ─────────────────────────────
                  _buildUnderlineFieldOptional(
                    label: l10n.middleName,
                    controller: _middleNameCtrl,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                    dividerColor: dividerColor,
                    optionalStyle: TextStyle(
                      fontSize: 13,
                      color: onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Last name ──────────────────────────────────────────
                  _buildUnderlineField(
                    label: l10n.lastName,
                    controller: _lastNameCtrl,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                    dividerColor: dividerColor,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 24),

                  // ── Mobile Number (read-only + edit icon) ──────────────
                  _buildReadOnlyRow(
                    label: l10n.mobileNumber,
                    value: _mobile.isEmpty ? l10n.notAvailable : _mobile,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                    dividerColor: dividerColor,
                    primaryColor: cs.primary,
                    onEdit: () => _showEditMobileDialog(),
                  ),
                  const SizedBox(height: 24),

                  // ── Email address (read-only + edit icon) ──────────────
                  _buildReadOnlyRow(
                    label: l10n.emailAddress,
                    value: _email.isEmpty ? l10n.notAvailable : _email,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                    dividerColor: dividerColor,
                    primaryColor: cs.primary,
                    onEdit: () => _showEditEmailDialog(),
                  ),
                  const SizedBox(height: 24),

                  // ── Date of birth ──────────────────────────────────────
                  _buildDobRow(
                    dob: _dob,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                    onTap: _pickDob,
                  ),
                  const SizedBox(height: 32),

                  // ── Country dropdown ───────────────────────────────────
                  _buildBorderedDropdown<String>(
                    value: _selectedCountry,
                    hint: l10n.selectCountry,
                    items: _countries.map((c) {
                      return DropdownMenuItem<String>(
                        value: c['name'],
                        child: Row(
                          children: [
                            Text(
                              c['flag']!,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              c['name']!,
                              style: TextStyle(color: onSurface, fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCountry = v),
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                  ),
                  const SizedBox(height: 24),

                  // ── State dropdown ─────────────────────────────────────
                  _buildBorderedDropdown<String>(
                    value: _selectedState,
                    hint: l10n.selectState,
                    items: _states.map((s) {
                      return DropdownMenuItem<String>(
                        value: s,
                        child: Text(
                          s,
                          style: TextStyle(color: onSurface, fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedState = v),
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                  ),
                  const SizedBox(height: 24),

                  // ── City dropdown ──────────────────────────────────────
                  _buildBorderedDropdown<String>(
                    value: _selectedCity,
                    hint: l10n.selectCity,
                    items: _cities.map((c) {
                      return DropdownMenuItem<String>(
                        value: c,
                        child: Text(
                          c,
                          style: TextStyle(color: onSurface, fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCity = v),
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                  ),
                  const SizedBox(height: 24),

                  // ── Address ────────────────────────────────────────────
                  TextFormField(
                    controller: _addressCtrl,
                    maxLength: 100,
                    maxLines: 2,
                    keyboardType: TextInputType.streetAddress,
                    style: valueStyle,
                    decoration: InputDecoration(
                      hintText: l10n.enterAddress,
                      hintStyle: TextStyle(
                        color: onSurface.withValues(alpha: 0.4),
                        fontSize: 15,
                      ),
                      counterText: '',
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: cs.primary),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: dividerColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── Save button ────────────────────────────────────────
                  CommonButton(
                    onPressed: _isSaving ? null : _onSave,
                    text: l10n.save,
                    isLoading: _isSaving,
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Underline Field (editable) ─────────────────────────────────────────────
  Widget _buildUnderlineField({
    required String label,
    required TextEditingController controller,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
    required Color dividerColor,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: valueStyle,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: labelStyle,
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 8),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: dividerColor),
        ),
      ),
    );
  }

  // ─── Underline Field with "(Optional)" on the right ─────────────────────────
  Widget _buildUnderlineFieldOptional({
    required String label,
    required TextEditingController controller,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
    required Color dividerColor,
    required TextStyle optionalStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                style: valueStyle,
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: labelStyle,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 8),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dividerColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: dividerColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(l10n.optional, style: optionalStyle),
          ],
        ),
      ],
    );
  }

  // ─── Read-only row with yellow edit circle icon ──────────────────────────────
  Widget _buildReadOnlyRow({
    required String label,
    required String value,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
    required Color dividerColor,
    required Color primaryColor,
    required VoidCallback onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: Text(value, style: valueStyle)),
            GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  color: _getIconColor(primaryColor),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Divider(color: dividerColor, thickness: 1, height: 1),
      ],
    );
  }

  // Determine icon color based on primary color brightness
  Color _getIconColor(Color bg) {
    return bg.computeLuminance() > 0.4 ? Colors.black : Colors.white;
  }

  // ─── Date of birth row ───────────────────────────────────────────────────────
  Widget _buildDobRow({
    required String dob,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
    required Color dividerColor,
    required Color onSurface,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dateOfBirth, style: labelStyle),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: Text(dob, style: valueStyle)),
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.calendar_month_outlined,
                color: onSurface.withValues(alpha: 0.55),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.optional,
              style: TextStyle(
                fontSize: 13,
                color: onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Divider(color: dividerColor, thickness: 1, height: 1),
      ],
    );
  }

  // ─── Rounded bordered dropdown ───────────────────────────────────────────────
  Widget _buildBorderedDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required Color dividerColor,
    required Color onSurface,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: dividerColor, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: onSurface.withValues(alpha: 0.6),
            size: 22,
          ),
          dropdownColor: Theme.of(context).cardColor,
          hint: Text(
            hint,
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.4),
              fontSize: 15,
            ),
          ),
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: onSurface, fontSize: 15),
        ),
      ),
    );
  }
}