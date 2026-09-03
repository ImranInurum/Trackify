import 'package:flutter/material.dart';
import 'package:trackify/core/utils/flutter_compat_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/widgets/square_flat_button.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_state.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:trackify/feature/auth/presentation/cubit/auth_state.dart';
import 'package:intl/intl.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:trackify/core/widgets/searchable_dropdown.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Unsaved Changes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You have unsaved changes. Are you sure you want to go back without saving?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              "Keep Editing",
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Discard"),
          ),
        ],
      ),
    );
    return result ?? false;
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

  void _showEditMobileDialog() {
    String tempPhoneCode = '+91';
    String rawMobile = _mobile.trim();

    // Extract country code and clean 10-digit number
    if (rawMobile.startsWith('+')) {
      for (final c in _countries) {
        if (c.phoneCode.isNotEmpty) {
          final code = c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}';
          if (rawMobile.startsWith(code)) {
            tempPhoneCode = code;
            rawMobile = rawMobile.substring(code.length);
            break;
          }
        }
      }
      if (rawMobile.startsWith('+91')) {
        tempPhoneCode = '+91';
        rawMobile = rawMobile.substring(3);
      }
    } else if (rawMobile.startsWith('91') && rawMobile.length > 10) {
      tempPhoneCode = '+91';
      rawMobile = rawMobile.substring(2);
    }

    String tempPhoneNumber = rawMobile.replaceAll(RegExp(r'\D'), '');
    if (tempPhoneCode == '+91' && tempPhoneNumber.length > 10) {
      tempPhoneNumber = tempPhoneNumber.substring(tempPhoneNumber.length - 10);
    }

    final dialogFormKey = GlobalKey<FormState>();
    final ctrl = TextEditingController(text: tempPhoneNumber);
    final searchCtrl = TextEditingController();
    final phoneCodeNotifier = ValueNotifier<String>(tempPhoneCode);

    final codeToCountryMap = <String, csc.Country>{};
    final seenCodes = <String>{};
    final uniqueCodes = <String>[];

    final countriesSource = _countries.isNotEmpty
        ? _countries
        : [
            csc.Country(name: 'India', isoCode: 'IN', phoneCode: '91', flag: '🇮🇳', currency: 'INR', latitude: '', longitude: ''),
            csc.Country(name: 'United States', isoCode: 'US', phoneCode: '1', flag: '🇺🇸', currency: 'USD', latitude: '', longitude: ''),
            csc.Country(name: 'United Kingdom', isoCode: 'GB', phoneCode: '44', flag: '🇬🇧', currency: 'GBP', latitude: '', longitude: ''),
          ];

    for (final c in countriesSource) {
      if (c.phoneCode.isEmpty) continue;
      final code = c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}';
      if (!seenCodes.contains(code)) {
        seenCodes.add(code);
        uniqueCodes.add(code);
        codeToCountryMap[code] = c;
      }
    }

    if (!seenCodes.contains(tempPhoneCode)) {
      uniqueCodes.insert(0, tempPhoneCode);
      seenCodes.add(tempPhoneCode);
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            title: Text(l10n.editMobileNumber),
            content: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  FormField<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      final val = ctrl.text;
                      if (val.trim().isEmpty) return l10n.required;
                      final cleanValue = val.trim();
                      if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) return l10n.invalidMobileNumber;
                      if (tempPhoneCode == '+91') {
                        if (cleanValue.length != 10) return l10n.invalidMobileNumber;
                        if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleanValue)) return l10n.invalidMobileNumber;
                      } else {
                        if (cleanValue.length < 7 || cleanValue.length > 15) return l10n.invalidMobileNumber;
                      }
                      return null;
                    },
                    builder: (fieldState) {
                      final hasError = fieldState.hasError;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: hasError
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).dividerColor,
                                width: hasError ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Searchable Country Code Dropdown
                                SizedBox(
                                  width: 85,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      value: phoneCodeNotifier.value,
                                      items: uniqueCodes.map((code) {
                                        final country = codeToCountryMap[code];
                                        final flag = country?.flag ?? '';
                                        final name = country?.name ?? '';
                                        final displayText = name.isNotEmpty
                                            ? "$flag $name ($code)".trim()
                                            : code;
                                        return DropdownMenuItem<String>(
                                          value: code,
                                          child: Text(
                                            displayText,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        );
                                      }).toList(),
                                      selectedItemBuilder: (context) {
                                        return uniqueCodes.map((code) {
                                          final country = codeToCountryMap[code];
                                          final flag = country?.flag ?? '';
                                          final displayText = flag.isNotEmpty ? "$flag $code" : code;
                                          return Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              displayText,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      onChanged: (val) {
                                        if (val != null) {
                                          phoneCodeNotifier.value = val;
                                          setDialogState(() {
                                            tempPhoneCode = val;
                                          });
                                          fieldState.validate();
                                          try {
                                            final country = codeToCountryMap[val];
                                            if (country != null) {
                                              setState(() {
                                                _selectedCountry = country.name;
                                              });
                                              _loadStates(country.isoCode);
                                            }
                                          } catch (_) {}
                                        }
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.zero,
                                        height: 50,
                                        width: double.infinity,
                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary, size: 20),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 300,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        elevation: 4,
                                      ),
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: searchCtrl,
                                        searchInnerWidgetHeight: 48,
                                        searchInnerWidget: Container(
                                          height: 48,
                                          padding: const EdgeInsets.only(top: 6, bottom: 4, right: 8, left: 8),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: searchCtrl,
                                            style: const TextStyle(fontSize: 13),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                              hintText: l10n.searchForItem,
                                              hintStyle: const TextStyle(fontSize: 12),
                                              prefixIcon: const Icon(Icons.search, size: 18),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          final code = item.value ?? '';
                                          final country = codeToCountryMap[code];
                                          final name = country?.name ?? '';
                                          final q = searchValue.toLowerCase();
                                          return name.toLowerCase().contains(q) || code.toLowerCase().contains(q);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Inner Vertical Divider
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: Theme.of(context).dividerColor,
                                ),
                                const SizedBox(width: 4),
                                // Mobile Input Field
                                Expanded(
                                  child: TextFormField(
                                    controller: ctrl,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (val) {
                                      fieldState.didChange(val);
                                      fieldState.validate();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(tempPhoneCode == '+91' ? 10 : 15),
                                    ],
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: l10n.mobileNumber,
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.4),
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, left: 4),
                              child: Text(
                                fieldState.errorText ?? '',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.5),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (dialogFormKey.currentState?.validate() ?? false) {
                    setState(() => _mobile = '$tempPhoneCode${ctrl.text.trim()}');
                    Navigator.pop(dialogCtx);
                  }
                },
                child: Text(
                  l10n.save,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Show a simple dialog to edit read-only field
  void _showEditEmailDialog() {
    final dialogFormKey = GlobalKey<FormState>();
    final ctrl = TextEditingController(text: _email);
    final otpCtrl = TextEditingController();
    bool isOtpSent = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ForgotPasswordOtpSent) {
                setDialogState(() {
                  isOtpSent = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.otpSent)),
                );
              } else if (state is ForgotPasswordOtpVerified) {
                setState(() => _email = ctrl.text.trim());
                Navigator.pop(dialogCtx);
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  }
                });
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.message ?? "")),
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                title: Text(l10n.editEmailAddress),
                content: Form(
                  key: dialogFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: ctrl,
                        enabled: !isOtpSent,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: l10n.emailAddress,
                          labelStyle: TextStyle(
                            fontSize: 12.5,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
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
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return l10n.required;
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(val.trim())) {
                            return l10n.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      if (isOtpSent) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: otpCtrl,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            labelText: l10n.otp,
                            labelStyle: TextStyle(
                              fontSize: 12.5,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6),
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
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.otpRequired;
                            }
                            return null;
                          },
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.emailNotVerified,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: state is AuthLoading ? null : () => Navigator.pop(dialogCtx),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.5),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (dialogFormKey.currentState?.validate() ?? false) {
                              if (!isOtpSent) {
                                context.read<AuthCubit>().sendOtp({"email": ctrl.text.trim()});
                              } else {
                                context.read<AuthCubit>().verifyOtp({
                                  "email": ctrl.text.trim(),
                                  "otp": otpCtrl.text.trim()
                                });
                              }
                            }
                          },
                    child: Text(
                      isOtpSent ? "Verify OTP" : "Send OTP",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
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
        _dob = DateFormat('yyyy-MM-dd').format(picked);
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
      color: onSurface.withOpacity( 0.55),
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
        return WillPopScope(
          onWillPop: () async {
            return await _showUnsavedChangesDialog();
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: onSurface),
                onPressed: () async {
                  final shouldPop = await _showUnsavedChangesDialog();
                  if (shouldPop && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                l10n.personalDetails,
              ),
              centerTitle: false,
            ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
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
                      color: onSurface.withOpacity( 0.45),
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
                  SearchableDropdown<String>(
                    label: l10n.country,
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
                      setState(() {
                        _selectedCountry = val;
                        _selectedState = null;
                        _selectedCity = null;
                        _states = [];
                        _cities = [];
                      });
                      if (val != null) {
                        final country = _countries.firstWhere((c) => c.name == val);
                        if (country.phoneCode.isNotEmpty) {
                          final code = country.phoneCode.startsWith('+') ? country.phoneCode : '+${country.phoneCode}';
                          String baseNumber = _mobile;
                          for (final c in _countries) {
                            if (c.phoneCode.isNotEmpty) {
                              final currentCode = c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}';
                              if (_mobile.startsWith(currentCode)) {
                                baseNumber = _mobile.substring(currentCode.length);
                                break;
                              }
                            }
                          }
                          setState(() {
                            _mobile = '$code$baseNumber';
                          });
                        }
                        _loadStates(country.isoCode);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── State dropdown ─────────────────────────────────────
                  SearchableDropdown<String>(
                    label: l10n.state,
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
                      setState(() {
                        _selectedState = val;
                        _selectedCity = null;
                        _cities = [];
                      });
                      if (val != null && _selectedCountry != null) {
                        final country = _countries.firstWhere((c) => c.name == _selectedCountry);
                        final state = _states.firstWhere((s) => s.name == val);
                        _loadCities(country.isoCode, state.isoCode);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── City dropdown ──────────────────────────────────────
                  SearchableDropdown<String>(
                    label: l10n.city,
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
                        color: onSurface.withOpacity( 0.4),
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
                color: onSurface.withOpacity( 0.55),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.optional,
              style: TextStyle(
                fontSize: 13,
                color: onSurface.withOpacity( 0.45),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Divider(color: dividerColor, thickness: 1, height: 1),
      ],
    );
  }

}