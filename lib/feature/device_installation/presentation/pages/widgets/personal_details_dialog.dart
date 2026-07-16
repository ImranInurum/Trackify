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
import 'package:trackify/core/widgets/searchable_dropdown.dart';

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

  bool _isLoadingCountries = true;
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
    final countries = await csc.getAllCountries();
    if (mounted) {
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });
    }
  }

  Future<void> _loadStates(String countryIsoCode) async {
    if (mounted) {
      setState(() => _isLoadingStates = true);
    }
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
    if (mounted) {
      setState(() => _isLoadingCities = true);
    }
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
                              l10n.completePersonalDetails,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.personalDetailsDesc,
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
                            header: l10n.lastNameLabel,
                            hint: l10n.enterLastName,
                            value: _lastNameController,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return l10n.requiredField;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            header: l10n.mobileNumberLabel,
                            hint: l10n.enterMobileNumber,
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
                                        : (() {
                                            final seenCodes = <String>{};
                                            final uniqueItems = <DropdownMenuItem<String>>[];
                                            for (final c in _countries) {
                                              if (c.phoneCode.isEmpty) continue;
                                              final code = c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}';
                                              if (!seenCodes.contains(code)) {
                                                seenCodes.add(code);
                                                uniqueItems.add(
                                                  DropdownMenuItem(
                                                    value: code,
                                                    child: Text("${c.flag} $code", overflow: TextOverflow.ellipsis),
                                                  ),
                                                );
                                              }
                                            }
                                            if (!seenCodes.contains(_selectedPhoneCode)) {
                                              uniqueItems.insert(
                                                0,
                                                DropdownMenuItem(
                                                  value: _selectedPhoneCode,
                                                  child: Text(_selectedPhoneCode, overflow: TextOverflow.ellipsis),
                                                ),
                                              );
                                            }
                                            return uniqueItems;
                                          })(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _selectedPhoneCode = val);
                                        try {
                                          final cleanCode = val.replaceAll('+', '');
                                          final matchingCountry = _countries.firstWhere(
                                            (c) => c.phoneCode == cleanCode || c.phoneCode == val,
                                          );
                                          setState(() => _selectedCountry = matchingCountry.name);
                                          _loadStates(matchingCountry.isoCode);
                                        } catch (_) {}
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return l10n.requiredField;
                              }
                              final cleanValue = val.trim();
                              if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
                                return l10n.invalidMobileNumber;
                              }

                              if (_selectedPhoneCode == '+91') {
                                if (cleanValue.length != 10) {
                                  return l10n.invalidMobileNumber;
                                }
                                if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleanValue)) {
                                  return l10n.invalidMobileNumber;
                                }
                              } else {
                                if (cleanValue.length < 7 || cleanValue.length > 15) {
                                  return l10n.invalidMobileNumber;
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Country Dropdown
                          SearchableDropdown<String>(
                            label: l10n.countryLabel,
                            hint: l10n.selectCountry,
                            value: _selectedCountry,
                            items: (() {
                              final seen = <String>{};
                              final uniqueItems = <String>[];
                              for (final c in _countries) {
                                if (c.name.isEmpty) continue;
                                if (!seen.contains(c.name)) {
                                  seen.add(c.name);
                                  uniqueItems.add(c.name);
                                }
                              }
                              if (_selectedCountry != null && !seen.contains(_selectedCountry)) {
                                uniqueItems.insert(0, _selectedCountry!);
                              }
                              return uniqueItems;
                            })(),
                            itemLabel: (item) {
                              try {
                                final c = _countries.firstWhere((element) => element.name == item);
                                return c.flag.isNotEmpty ? "${c.flag}  ${c.name}" : c.name;
                              } catch (e) {
                                return item;
                              }
                            },
                            isLoading: _isLoadingCountries,
                            onChanged: (val) {
                              setState(() => _selectedCountry = val);
                              if (val != null) {
                                final country = _countries.firstWhere((c) => c.name == val);
                                if (country.phoneCode.isNotEmpty) {
                                  final code = country.phoneCode.startsWith('+') ? country.phoneCode : '+${country.phoneCode}';
                                  setState(() => _selectedPhoneCode = code);
                                }
                                _loadStates(country.isoCode);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // State Dropdown
                          SearchableDropdown<String>(
                            label: l10n.stateLabel,
                            hint: l10n.selectState,
                            value: _selectedState,
                            items: (() {
                              final seen = <String>{};
                              final uniqueItems = <String>[];
                              for (final s in _states) {
                                if (s.name.isEmpty) continue;
                                if (!seen.contains(s.name)) {
                                  seen.add(s.name);
                                  uniqueItems.add(s.name);
                                }
                              }
                              if (_selectedState != null && !seen.contains(_selectedState)) {
                                uniqueItems.insert(0, _selectedState!);
                              }
                              return uniqueItems;
                            })(),
                            itemLabel: (item) => item,
                            isLoading: _isLoadingStates,
                            onChanged: (val) {
                              setState(() => _selectedState = val);
                              if (val != null && _selectedCountry != null) {
                                final country = _countries.firstWhere((c) => c.name == _selectedCountry);
                                final state = _states.firstWhere((s) => s.name == val);
                                _loadCities(country.isoCode, state.isoCode);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // City Dropdown
                          SearchableDropdown<String>(
                            label: l10n.cityLabel,
                            hint: l10n.selectCity,
                            value: _selectedCity,
                            items: (() {
                              final seen = <String>{};
                              final uniqueItems = <String>[];
                              for (final c in _cities) {
                                if (c.name.isEmpty) continue;
                                if (!seen.contains(c.name)) {
                                  seen.add(c.name);
                                  uniqueItems.add(c.name);
                                }
                              }
                              if (_selectedCity != null && !seen.contains(_selectedCity)) {
                                uniqueItems.insert(0, _selectedCity!);
                              }
                              return uniqueItems;
                            })(),
                            itemLabel: (item) => item,
                            isLoading: _isLoadingCities,
                            onChanged: (val) => setState(() => _selectedCity = val),
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
                              : Text(
                                  l10n.saveAndContinue,
                                  style: const TextStyle(
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
