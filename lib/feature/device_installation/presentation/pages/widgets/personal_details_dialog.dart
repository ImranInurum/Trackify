import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/custom_form_field.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_state.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:trackify/core/theme/app_theme_extension.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

class PersonalDetailsDialog extends StatefulWidget {
  const PersonalDetailsDialog({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsDialog> createState() => _PersonalDetailsDialogState();
}

class _PersonalDetailsDialogState extends State<PersonalDetailsDialog> {
  final _formKey = GlobalKey<FormState>();

  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();

  String _firstName = '';
  String _email = '';
  String _userId = '';

  String _selectedPhoneCode = '+91';

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  List<csc.Country> _countries = [];
  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  bool _isLoadingCountries = false;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _populateData();
    _loadCountries();
  }

  void _populateData() {
    final appState = context.read<AppCubit>().state;
    final user = appState.userData;

    if (user != null) {
      _firstName = user.name ?? '';
      _email = user.email ?? '';
      _userId = user.id ?? '';
      
      // Fields are kept empty as per user request
      _lastNameController.text = '';
      _mobileController.text = '';
    }
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingCountries = true);
    final countries = await csc.getAllCountries();
    if (mounted) {
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });
    }
  }

  Future<void> _loadStates(String countryIsoCode) async {
    setState(() => _isLoadingStates = true);
    final states = await csc.getStatesOfCountry(countryIsoCode);
    if (mounted) {
      setState(() {
        _states = states;
        _isLoadingStates = false;
        _selectedState = null;
        _selectedCity = null;
        _cities = [];
      });
    }
  }

  Future<void> _loadCities(String countryIsoCode, String stateIsoCode) async {
    setState(() => _isLoadingCities = true);
    final cities = await csc.getStateCities(countryIsoCode, stateIsoCode);
    if (mounted) {
      setState(() {
        _cities = cities;
        _isLoadingCities = false;
        _selectedCity = null;
      });
    }
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdateProfileRequest(
        name: _firstName,
        lastName: _lastNameController.text.trim(),
        mobileNumber: '$_selectedPhoneCode${_mobileController.text.trim()}',
        email: _email,
        country: _selectedCountry,
        state: _selectedState,
        city: _selectedCity,
      );

      context.read<MyProfileCubit>().updateProfile(
            userId: _userId,
            request: request,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>();

    return BlocListener<MyProfileCubit, MyProfileState>(
      listener: (context, state) {
        if (state is MyProfileSuccess) {
          // Update the global AppCubit state with the new user details
          context.read<AppCubit>().updateUserSession(state.user);
          Navigator.of(context).pop(true);
        } else if (state is MyProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.scaffoldBackgroundColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Complete Personal Details",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please provide these details before device installation.",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomFormField(
                            header: "Last Name",
                            hint: "Enter your last name",
                            value: _lastNameController,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            header: "Mobile Number",
                            hint: "Enter your mobile number",
                            value: _mobileController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.only(left: 12, right: 4),
                              decoration: BoxDecoration(
                                border: Border(right: BorderSide(color: Theme.of(context).dividerColor)),
                              ),
                              child: SizedBox(
                                width: 85,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedPhoneCode,
                                    isDense: true,
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                                    menuMaxHeight: 300,
                                    items: _countries.isEmpty 
                                        ? [
                                            const DropdownMenuItem(
                                              value: '+91',
                                              child: Text("🇮🇳 +91", overflow: TextOverflow.ellipsis),
                                            )
                                          ]
                                        : _countries.map((c) {
                                            final code = c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}';
                                            return DropdownMenuItem(
                                              value: code,
                                              child: Text("${c.flag} $code", overflow: TextOverflow.ellipsis),
                                            );
                                          }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedPhoneCode = val);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Country Dropdown
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                              child: Text(
                                "Country",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedCountry,
                            hint: const Text("Select your country"),
                            isExpanded: true,
                            icon: _isLoadingCountries 
                                ? SizedBox(
                                    width: 12, 
                                    height: 12, 
                                    child: CircularProgressIndicator(strokeWidth: 1.5, color: theme.colorScheme.primary),
                                  )
                                : const Icon(Icons.arrow_drop_down),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.cardColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5)),
                            ),
                            items: _countries.map((c) {
                              return DropdownMenuItem<String>(
                                value: c.name,
                                child: Text("${c.flag}  ${c.name}", overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedCountry = val);
                              if (val != null) {
                                final country = _countries.firstWhere((c) => c.name == val);
                                _loadStates(country.isoCode);
                              }
                            },
                            validator: (val) => val == null || val.isEmpty ? "Required field" : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // State Dropdown
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                              child: Text(
                                "State",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedState,
                            hint: const Text("Select your state"),
                            isExpanded: true,
                            icon: _isLoadingStates 
                                ? SizedBox(
                                    width: 12, 
                                    height: 12, 
                                    child: CircularProgressIndicator(strokeWidth: 1.5, color: theme.colorScheme.primary),
                                  )
                                : const Icon(Icons.arrow_drop_down),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.cardColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5)),
                            ),
                            items: _states.map((s) {
                              return DropdownMenuItem<String>(
                                value: s.name,
                                child: Text(s.name, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedState = val);
                              if (val != null && _selectedCountry != null) {
                                final country = _countries.firstWhere((c) => c.name == _selectedCountry);
                                final state = _states.firstWhere((s) => s.name == val);
                                _loadCities(country.isoCode, state.isoCode);
                              }
                            },
                            validator: (val) => val == null || val.isEmpty ? "Required field" : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // City Dropdown
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                              child: Text(
                                "City",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedCity,
                            hint: const Text("Select your city"),
                            isExpanded: true,
                            icon: _isLoadingCities 
                                ? SizedBox(
                                    width: 12, 
                                    height: 12, 
                                    child: CircularProgressIndicator(strokeWidth: 1.5, color: theme.colorScheme.primary),
                                  )
                                : const Icon(Icons.arrow_drop_down),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.cardColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5)),
                            ),
                            items: _cities.map((c) {
                              return DropdownMenuItem<String>(
                                value: c.name,
                                child: Text(c.name, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedCity = val),
                            validator: (val) => val == null || val.isEmpty ? "Required field" : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: BlocBuilder<MyProfileCubit, MyProfileState>(
                      builder: (context, state) {
                        final isLoading = state is MyProfileLoading;
                        return ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Save & Continue",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
