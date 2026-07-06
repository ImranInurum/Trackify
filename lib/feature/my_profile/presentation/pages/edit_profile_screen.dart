import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/square_flat_button.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_state.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:intl/intl.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

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
  bool _isLoadingCountries = false;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  // --- Dynamic lists ---
  List<csc.Country> _countries = [];
  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  String? _findMatchingCountry(String? country) {
    if (country == null || country.trim().isEmpty) return null;
    return country.trim();
  }

  String? _findMatchingState(String? state) {
    if (state == null || state.trim().isEmpty) return null;
    return state.trim();
  }

  String? _findMatchingCity(String? city) {
    if (city == null || city.trim().isEmpty) return null;
    return city.trim();
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingCountries = true);
    final countries = await csc.getAllCountries();
    if (mounted) {
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });
      if (_selectedCountry != null) {
        final country = _countries.where((c) => c.name.toLowerCase() == _selectedCountry!.toLowerCase()).firstOrNull;
        if (country != null) {
          _selectedCountry = country.name; // normalize
          await _loadStates(country.isoCode);
        }
      }
    }
  }

  Future<void> _loadStates(String countryIsoCode) async {
    setState(() => _isLoadingStates = true);
    final states = await csc.getStatesOfCountry(countryIsoCode);
    if (mounted) {
      setState(() {
        _states = states;
        _isLoadingStates = false;
        // reset selected state if not found in new list
        if (_selectedState != null && !_states.any((s) => s.name.toLowerCase() == _selectedState!.toLowerCase())) {
          _selectedState = null;
          _selectedCity = null;
          _cities = [];
        }
      });
      if (_selectedState != null) {
        final state = _states.where((s) => s.name.toLowerCase() == _selectedState!.toLowerCase()).firstOrNull;
        if (state != null) {
          _selectedState = state.name; // normalize
          await _loadCities(countryIsoCode, state.isoCode);
        }
      }
    }
  }

  Future<void> _loadCities(String countryIsoCode, String stateIsoCode) async {
    setState(() => _isLoadingCities = true);
    final cities = await csc.getStateCities(countryIsoCode, stateIsoCode);
    if (mounted) {
      setState(() {
        _cities = cities;
        _isLoadingCities = false;
        // reset selected city if not found in new list
        if (_selectedCity != null && !_cities.any((c) => c.name.toLowerCase() == _selectedCity!.toLowerCase())) {
          _selectedCity = null;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AppCubit>().state.userData;
      if (user != null) {
        if (user.middleName != null || user.lastName != null) {
          _firstNameCtrl.text = user.name ?? '';
          _middleNameCtrl.text = user.middleName ?? '';
          _lastNameCtrl.text = user.lastName ?? '';
        } else {
          final fullName = user.name ?? '';
          final parts = fullName.trim().split(' ');
          _firstNameCtrl.text = parts.isNotEmpty ? parts[0] : '';
          _lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
        }
        _mobile = (user.mobileNumber != null && user.mobileNumber!.trim().isNotEmpty)
            ? user.mobileNumber!
            : '';
        _email = (user.email != null && user.email!.trim().isNotEmpty)
            ? user.email!
            : '';
        _selectedCountry = _findMatchingCountry(user.country);
        _selectedState = _findMatchingState(user.state);
        _selectedCity = _findMatchingCity(user.city);
        _addressCtrl.text = user.address ?? '';
        if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
          try {
            final parsedDate = DateTime.parse(user.dateOfBirth!);
            _dob = DateFormat('yyyy-MM-dd').format(parsedDate);
          } catch (_) {
            _dob = user.dateOfBirth!;
          }
        }
      } else {
        _firstNameCtrl.text = '';
        _mobile = '';
        _email = '';
        _selectedCountry = null;
        _selectedState = null;
        _selectedCity = null;
      }
      setState(() {});
      _loadCountries();
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

    final appCubit = context.read<AppCubit>();
    final userId = appCubit.state.userData?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userSessionNotFound),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = UpdateProfileRequest(
      name: _firstNameCtrl.text.trim(),
      middleName: _middleNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      mobileNumber: _mobile,
      email: _email,
      dateOfBirth: _dob == l10n.notAvailable ? null : _dob,
      country: _selectedCountry,
      state: _selectedState,
      city: _selectedCity,
      address: _addressCtrl.text.trim(),
    );

    context.read<MyProfileCubit>().updateProfile(
      userId: userId,
      request: request,
    );
  }

  /// Show a simple dialog to edit read-only field
  void _showEditEmailDialog() {
    final ctrl = TextEditingController(text: _email);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogCtx),
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
              Navigator.pop(dialogCtx);
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
      builder: (dialogCtx) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogCtx),
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
              Navigator.pop(dialogCtx);
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

    return BlocListener<MyProfileCubit, MyProfileState>(
      listener: (context, state) {
        if (state is MyProfileLoading) {
          setState(() => _isSaving = true);
        } else if (state is MyProfileSuccess) {
          setState(() => _isSaving = false);
          context.read<AppCubit>().updateUserSession(state.user);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message.isNotEmpty
                    ? state.message
                    : l10n.profileUpdatedSuccessfully,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(12),
            ),
          );
          Navigator.pop(context);
        } else if (state is MyProfileError) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(12),
            ),
          );
        }
      },
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: onSurface),
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
                        value: c.name,
                        child: Row(
                          children: [
                            Text(
                              c.flag,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                c.name,
                                style: TextStyle(color: onSurface, fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedCountry = v;
                        _selectedState = null;
                        _selectedCity = null;
                        _states = [];
                        _cities = [];
                      });
                      if (v != null) {
                        final country = _countries.firstWhere((c) => c.name == v);
                        _loadStates(country.isoCode);
                      }
                    },
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                    isLoading: _isLoadingCountries,
                  ),
                  const SizedBox(height: 24),

                  // ── State dropdown ─────────────────────────────────────
                  _buildBorderedDropdown<String>(
                    value: _selectedState,
                    hint: l10n.selectState,
                    items: _states.map((s) {
                      return DropdownMenuItem<String>(
                        value: s.name,
                        child: Text(
                          s.name,
                          style: TextStyle(color: onSurface, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedState = v;
                        _selectedCity = null;
                        _cities = [];
                      });
                      if (v != null && _selectedCountry != null) {
                        final country = _countries.firstWhere((c) => c.name == _selectedCountry);
                        final state = _states.firstWhere((s) => s.name == v);
                        _loadCities(country.isoCode, state.isoCode);
                      }
                    },
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                    isLoading: _isLoadingStates,
                  ),
                  const SizedBox(height: 24),

                  // ── City dropdown ──────────────────────────────────────
                  _buildBorderedDropdown<String>(
                    value: _selectedCity,
                    hint: l10n.selectCity,
                    items: _cities.map((c) {
                      return DropdownMenuItem<String>(
                        value: c.name,
                        child: Text(
                          c.name,
                          style: TextStyle(color: onSurface, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCity = v),
                    dividerColor: dividerColor,
                    onSurface: onSurface,
                    isLoading: _isLoadingCities,
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
    ),
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
    bool isLoading = false,
  }) {
    // Safety check to prevent dropdown assertion crashes
    final List<DropdownMenuItem<T>> safeItems = List.from(items);
    if (value != null && !safeItems.any((item) => item.value == value)) {
      safeItems.add(
        DropdownMenuItem<T>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(color: onSurface, fontSize: 15),
          ),
        ),
      );
    }

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
          icon: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
          hint: Text(
            hint,
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.4),
              fontSize: 15,
            ),
          ),
          items: safeItems,
          onChanged: onChanged,
          style: TextStyle(color: onSurface, fontSize: 15),
        ),
      ),
    );
  }
}