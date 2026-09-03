import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import '../../../../core/config/network/network_api_service.dart';
import '../../../../core/config/network/api_host.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/cubit/app_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0; // 0 = Address, 1 = Summary
  bool _isHomeSelected = true;
  String _selectedPaymentMethod = 'ONLINE';
  String _selectedCountryCode = '+91';
  String _selectedFlag = '🇮🇳';

  csc.Country? _selectedCountry;
  csc.State? _selectedState;
  csc.City? _selectedCity;

  List<csc.Country> _countries = [];
  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  bool _isLoadingCountries = true;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();

  String? _fullNameError;
  String? _mobileError;
  String? _addressError;
  String? _countryError;
  String? _stateError;
  String? _cityError;
  String? _pincodeError;

  @override
  void initState() {
    super.initState();
    _loadCountriesAndPrefill();
  }

  /// Loads countries first, then auto-fills address fields from the user's profile.
  Future<void> _loadCountriesAndPrefill() async {
    await _loadCountries();
    if (mounted) await _prefillFromProfile();
  }

  /// Reads saved profile data from AppCubit and pre-populates
  /// the address form (name, mobile, country, state, city, address).
  Future<void> _prefillFromProfile() async {
    final user = context.read<AppCubit>().state.userData;
    if (user == null) return;

    // Text fields
    if ((user.name ?? '').isNotEmpty) {
      final fullName = [
        user.name ?? '',
        user.middleName ?? '',
        user.lastName ?? '',
      ].where((s) => s.isNotEmpty).join(' ');
      _fullNameController.text = fullName.trim();
    }
    if ((user.mobileNumber ?? '').isNotEmpty) {
      _mobileController.text = user.mobileNumber!.trim();
    }
    if ((user.address ?? '').isNotEmpty) {
      _addressController.text = user.address!.trim();
    }

    // Country match (by name, case-insensitive)
    final profileCountry = (user.country ?? '').trim().toLowerCase();
    if (profileCountry.isNotEmpty && _countries.isNotEmpty) {
      csc.Country? matchedCountry;
      try {
        matchedCountry = _countries.firstWhere(
          (c) => c.name.toLowerCase() == profileCountry,
        );
      } catch (_) {
        // try partial match
        try {
          matchedCountry = _countries.firstWhere(
            (c) => c.name.toLowerCase().contains(profileCountry) ||
                profileCountry.contains(c.name.toLowerCase()),
          );
        } catch (_) {}
      }

      if (matchedCountry != null && mounted) {
        setState(() {
          _selectedCountry = matchedCountry;
          final code = matchedCountry!.phoneCode.startsWith('+')
              ? matchedCountry.phoneCode
              : '+${matchedCountry.phoneCode}';
          _selectedCountryCode = code;
          _selectedFlag = matchedCountry.flag.isNotEmpty
              ? matchedCountry.flag
              : _selectedFlag;
        });

        // Load states for matched country
        final states = await csc.getStatesOfCountry(matchedCountry.isoCode);
        if (!mounted) return;
        setState(() {
          _states = states;
          _selectedState = null;
          _selectedCity = null;
          _cities = [];
        });

        // State match
        final profileState = (user.state ?? '').trim().toLowerCase();
        if (profileState.isNotEmpty && states.isNotEmpty) {
          csc.State? matchedState;
          try {
            matchedState = states.firstWhere(
              (s) => s.name.toLowerCase() == profileState,
            );
          } catch (_) {
            try {
              matchedState = states.firstWhere(
                (s) => s.name.toLowerCase().contains(profileState) ||
                    profileState.contains(s.name.toLowerCase()),
              );
            } catch (_) {}
          }

          if (matchedState != null && mounted) {
            setState(() => _selectedState = matchedState);

            // Load cities for matched state
            final cities = await csc.getStateCities(
              matchedCountry.isoCode,
              matchedState.isoCode,
            );
            if (!mounted) return;
            setState(() {
              _cities = cities;
              _selectedCity = null;
            });

            // City match
            final profileCity = (user.city ?? '').trim().toLowerCase();
            if (profileCity.isNotEmpty && cities.isNotEmpty) {
              csc.City? matchedCity;
              try {
                matchedCity = cities.firstWhere(
                  (c) => c.name.toLowerCase() == profileCity,
                );
              } catch (_) {
                try {
                  matchedCity = cities.firstWhere(
                    (c) => c.name.toLowerCase().contains(profileCity) ||
                        profileCity.contains(c.name.toLowerCase()),
                  );
                } catch (_) {}
              }
              if (matchedCity != null && mounted) {
                setState(() => _selectedCity = matchedCity);
              }
            }
          }
        }
      }
    }
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await csc.getAllCountries();
      if (mounted) {
        csc.Country? defaultCountry;
        try {
          defaultCountry = countries.firstWhere((c) => c.isoCode == 'IN');
        } catch (_) {
          if (countries.isNotEmpty) defaultCountry = countries.first;
        }
        setState(() {
          _countries = countries;
          _isLoadingCountries = false;
          if (defaultCountry != null) {
            _selectedCountry = defaultCountry;
            final code = defaultCountry.phoneCode.startsWith('+')
                ? defaultCountry.phoneCode
                : '+${defaultCountry.phoneCode}';
            _selectedCountryCode = code;
            _selectedFlag = defaultCountry.flag.isNotEmpty
                ? defaultCountry.flag
                : '🇮🇳';
          }
        });
        if (defaultCountry != null) {
          _loadStates(defaultCountry.isoCode);
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingCountries = false);
      }
    }
  }

  Future<void> _loadStates(String countryIsoCode) async {
    if (mounted) setState(() => _isLoadingStates = true);
    try {
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
    } catch (_) {
      if (mounted) setState(() => _isLoadingStates = false);
    }
  }

  Future<void> _loadCities(String countryIsoCode, String stateIsoCode) async {
    if (mounted) setState(() => _isLoadingCities = true);
    try {
      final cities = await csc.getStateCities(countryIsoCode, stateIsoCode);
      if (mounted) {
        setState(() {
          _cities = cities;
          _isLoadingCities = false;
          _selectedCity = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingCities = false);
    }
  }

  void _showSearchablePicker<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) itemLabel,
    String Function(T)? itemSubLabel,
    String Function(T)? itemLeading,
    required ValueChanged<T> onSelected,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    String searchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredList = items.where((item) {
              final label = itemLabel(item).toLowerCase();
              final sub = itemSubLabel?.call(item).toLowerCase() ?? "";
              final query = searchQuery.toLowerCase().trim();
              return label.contains(query) || sub.contains(query);
            }).toList();

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// SEARCH BAR
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? colorScheme.surfaceVariant.withOpacity( 
                                  0.4,
                                )
                              : colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity( 0.5),
                          ),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setModalState(() {
                              searchQuery = val;
                            });
                          },
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search $title...",
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant.withOpacity( 
                                0.6,
                              ),
                              fontSize: 13.5,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      /// LIST OF ITEMS
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: colorScheme.primary,
                                ),
                              )
                            : filteredList.isEmpty
                            ? Center(
                                child: Text(
                                  "No items found",
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                itemCount: filteredList.length,
                                separatorBuilder: (_, __) => Divider(
                                  color: colorScheme.outlineVariant.withOpacity( 
                                    0.3,
                                  ),
                                  height: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final item = filteredList[index];
                                  final leading = itemLeading?.call(item);
                                  final sub = itemSubLabel?.call(item);

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    leading:
                                        leading != null && leading.isNotEmpty
                                        ? Text(
                                            leading,
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          )
                                        : null,
                                    title: Text(
                                      itemLabel(item),
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: sub != null && sub.isNotEmpty
                                        ? Text(
                                            sub,
                                            style: TextStyle(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showCountryCodePicker(BuildContext context) {
    _showSearchablePicker<csc.Country>(
      context: context,
      title: "Select Country Code",
      items: _countries,
      isLoading: _isLoadingCountries,
      itemLabel: (c) => c.name,
      itemSubLabel: (c) =>
          c.phoneCode.startsWith('+') ? c.phoneCode : '+${c.phoneCode}',
      itemLeading: (c) => c.flag.isNotEmpty ? c.flag : '🌐',
      onSelected: (country) {
        setState(() {
          _selectedCountry = country;
          _countryError = null;
          final code = country.phoneCode.startsWith('+')
              ? country.phoneCode
              : '+${country.phoneCode}';
          _selectedCountryCode = code;
          _selectedFlag = country.flag.isNotEmpty ? country.flag : '🌐';
        });
        _loadStates(country.isoCode);
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  bool _validateAddressForm() {
    bool isValid = true;
    final fullName = _fullNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final address = _addressController.text.trim();
    final pincode = _pincodeController.text.trim();

    setState(() {
      // Full Name Validation
      if (fullName.isEmpty) {
        _fullNameError = "Please enter your full name";
        isValid = false;
      } else {
        _fullNameError = null;
      }

      // Mobile Number Validation
      if (mobile.isEmpty) {
        _mobileError = "Please enter mobile number";
        isValid = false;
      } else if (mobile.length != 10 ||
          !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
        _mobileError = "Please enter a valid 10-digit mobile number";
        isValid = false;
      } else {
        _mobileError = null;
      }

      // Address Validation
      if (address.isEmpty) {
        _addressError = "Please enter house/street address";
        isValid = false;
      } else {
        _addressError = null;
      }

      // Country Validation
      if (_selectedCountry == null) {
        _countryError = "Please select country";
        isValid = false;
      } else {
        _countryError = null;
      }

      // State Validation
      if (_selectedState == null && _states.isNotEmpty) {
        _stateError = "Please select state";
        isValid = false;
      } else {
        _stateError = null;
      }

      // City Validation
      if (_selectedCity == null && _cities.isNotEmpty) {
        _cityError = "Please select city";
        isValid = false;
      } else {
        _cityError = null;
      }

      // Pin Code Validation
      if (pincode.isNotEmpty && pincode.length != 6) {
        _pincodeError = "Please enter a valid 6-digit pin code";
        isValid = false;
      } else {
        _pincodeError = null;
      }
    });

    return isValid;
  }

  Widget _buildCustomField(
    BuildContext context, {
    required String hint,
    IconData? prefixIcon,
    Widget? customPrefix,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? errorText,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    Widget? suffix,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final hasError = errorText != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surfaceVariant.withOpacity( 0.35)
                  : colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasError
                    ? Colors.red.shade400
                    : (isDark
                          ? colorScheme.outline.withOpacity( 0.2)
                          : colorScheme.outlineVariant.withOpacity( 0.6)),
                width: hasError ? 1.5 : 1,
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                counterText: "",
                prefixIcon:
                    customPrefix ??
                    (prefixIcon != null
                        ? Icon(
                            prefixIcon,
                            color: hasError
                                ? Colors.red.shade400
                                : colorScheme.primary.withOpacity( 0.8),
                            size: 20,
                          )
                        : null),
                suffixIcon: suffix,
                hintText: hint,
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant.withOpacity( 0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 13,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    errorText,
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPickerField(
    BuildContext context, {
    required String hint,
    required String? value,
    required IconData prefixIcon,
    required VoidCallback onTap,
    bool isLoading = false,
    String? errorText,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final hasError = errorText != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.surfaceVariant.withOpacity( 0.35)
                      : colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasError
                        ? Colors.red.shade400
                        : (isDark
                              ? colorScheme.outline.withOpacity( 0.2)
                              : colorScheme.outlineVariant.withOpacity( 0.6)),
                    width: hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      prefixIcon,
                      color: hasError
                          ? Colors.red.shade400
                          : colorScheme.primary.withOpacity( 0.8),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        value ?? hint,
                        style: TextStyle(
                          color: value != null
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant.withOpacity( 0.6),
                          fontSize: 14.5,
                          fontWeight: value != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isLoading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                    else
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 13,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    errorText,
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity( 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: colorScheme.onSurface,
                ),
                onPressed: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep = 0);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
          title: Text(
            l10n.checkout,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            const SizedBox(height: 4),

            /// STEPPER PROGRESS HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Row(
                children: [
                  _buildStepPill(
                    index: 0,
                    title: l10n.address,
                    icon: Icons.location_on_rounded,
                    colorScheme: colorScheme,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: _currentStep >= 1
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withOpacity( 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  _buildStepPill(
                    index: 1,
                    title: l10n.summary,
                    icon: Icons.receipt_long_rounded,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// BODY VIEW
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _currentStep == 0
                      ? _buildAddressForm(context, l10n, colorScheme, isDark)
                      : _buildOrderSummary(context, l10n, colorScheme, isDark),
                ),
              ),
            ),

            /// BOTTOM ACTION BUTTON
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity( isDark ? 0.2 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity( 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        if (_currentStep == 0) {
                          if (_validateAddressForm()) {
                            setState(() => _currentStep = 1);
                          }
                        } else {
                          try {
                            final body = {
                              "userName": _fullNameController.text.trim(),
                              "userPhone": "$_selectedCountryCode${_mobileController.text.trim()}",
                              "productTitle": "Trackify Pro",
                              "price": 2690,
                              "notes": "Address: ${_addressController.text.trim()}, ${_landmarkController.text.trim()}, ${_selectedCity?.name ?? ''}, ${_selectedState?.name ?? ''}, Pincode: ${_pincodeController.text.trim()}. Payment Method: $_selectedPaymentMethod",
                            };

                            await NetworkApiService().getPostApiResponse(
                              "${ApiURL.baseURL}/api/product-catalog/order",
                              body,
                            );
                          } catch (e) {
                            debugPrint("Error submitting order inquiry: $e");
                          }

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: const [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(child: Text("Order Inquiry Submitted! Trackify team will contact you.")),
                                ],
                              ),
                              backgroundColor: Colors.green.shade700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 0
                                  ? l10n.proceed
                                  : "Confirm & Place Order",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              _currentStep == 0
                                  ? Icons.arrow_forward_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepPill({
    required int index,
    required String title,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    final isActive = _currentStep >= index;
    final isCurrent = _currentStep == index;

    return GestureDetector(
      onTap: () {
        if (index == 1 && _currentStep == 0) {
          if (!_validateAddressForm()) return;
        }
        setState(() => _currentStep = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withOpacity( 0.12)
              : colorScheme.surfaceVariant.withOpacity( 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? colorScheme.primary
                : colorScheme.outlineVariant.withOpacity( 0.4),
            width: isCurrent ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: isActive
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              child: Icon(
                isActive ? Icons.check : icon,
                size: 11,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 12.5,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          l10n.pleaseEnterDetails,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Enter your shipping details for fast delivery",
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
        ),

        const SizedBox(height: 20),

        _buildCustomField(
          context,
          hint: l10n.fullName,
          prefixIcon: Icons.person_outline_rounded,
          controller: _fullNameController,
          errorText: _fullNameError,
          onChanged: (_) {
            if (_fullNameError != null) {
              setState(() => _fullNameError = null);
            }
          },
        ),
        _buildCustomField(
          context,
          hint: l10n.mobileNumber,
          customPrefix: GestureDetector(
            onTap: () => _showCountryCodePicker(context),
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_android_rounded,
                    color: _mobileError != null
                        ? Colors.red.shade400
                        : colorScheme.primary.withOpacity( 0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity( 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedFlag,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _selectedCountryCode,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 18,
                    color: colorScheme.outlineVariant.withOpacity( 0.6),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          keyboardType: TextInputType.phone,
          controller: _mobileController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
          errorText: _mobileError,
          onChanged: (_) {
            if (_mobileError != null) {
              setState(() => _mobileError = null);
            }
          },
        ),
        _buildCustomField(
          context,
          hint: l10n.houseFloorLine,
          prefixIcon: Icons.home_outlined,
          controller: _addressController,
          errorText: _addressError,
          onChanged: (_) {
            if (_addressError != null) {
              setState(() => _addressError = null);
            }
          },
        ),
        _buildCustomField(
          context,
          hint: l10n.landmark,
          prefixIcon: Icons.place_outlined,
          controller: _landmarkController,
        ),
        _buildPickerField(
          context,
          hint: "Select Country",
          value: _selectedCountry != null
              ? "${_selectedCountry!.flag.isNotEmpty ? _selectedCountry!.flag : '🌐'} ${_selectedCountry!.name}"
              : null,
          prefixIcon: Icons.public_rounded,
          isLoading: _isLoadingCountries,
          errorText: _countryError,
          onTap: () => _showCountryCodePicker(context),
        ),
        _buildPickerField(
          context,
          hint: l10n.state,
          value: _selectedState?.name,
          prefixIcon: Icons.map_outlined,
          isLoading: _isLoadingStates,
          errorText: _stateError,
          onTap: () {
            if (_selectedCountry == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a country first")),
              );
              return;
            }
            _showSearchablePicker<csc.State>(
              context: context,
              title: "Select State",
              items: _states,
              isLoading: _isLoadingStates,
              itemLabel: (s) => s.name,
              onSelected: (state) {
                setState(() {
                  _selectedState = state;
                  _stateError = null;
                });
                _loadCities(_selectedCountry!.isoCode, state.isoCode);
              },
            );
          },
        ),
        _buildPickerField(
          context,
          hint: "Select City",
          value: _selectedCity?.name,
          prefixIcon: Icons.location_city_outlined,
          isLoading: _isLoadingCities,
          errorText: _cityError,
          onTap: () {
            if (_selectedState == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a state first")),
              );
              return;
            }
            _showSearchablePicker<csc.City>(
              context: context,
              title: "Select City",
              items: _cities,
              isLoading: _isLoadingCities,
              itemLabel: (c) => c.name,
              onSelected: (city) {
                setState(() {
                  _selectedCity = city;
                  _cityError = null;
                });
              },
            );
          },
        ),
        _buildCustomField(
          context,
          hint: l10n.pinCode,
          prefixIcon: Icons.pin_drop_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          controller: _pincodeController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 6,
          errorText: _pincodeError,
          onChanged: (_) {
            if (_pincodeError != null) {
              setState(() => _pincodeError = null);
            }
          },
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
        ),

        const SizedBox(height: 10),

        Text(
          "Address Type",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        /// ADDRESS TYPE CARDS
        Row(
          children: [
            Expanded(
              child: _buildAddressTypeCard(
                title: l10n.homeAddress,
                icon: Icons.home_rounded,
                isSelected: _isHomeSelected,
                onTap: () => setState(() => _isHomeSelected = true),
                colorScheme: colorScheme,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAddressTypeCard(
                title: l10n.officeAddress,
                icon: Icons.business_rounded,
                isSelected: !_isHomeSelected,
                onTap: () => setState(() => _isHomeSelected = false),
                colorScheme: colorScheme,
                isDark: isDark,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAddressTypeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity( 0.1)
              : (isDark
                    ? colorScheme.surfaceVariant.withOpacity( 0.3)
                    : colorScheme.surfaceVariant),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withOpacity( 0.5),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          "Order Summary",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Review your items and shipping details",
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
        ),

        const SizedBox(height: 16),

        /// SHIPPING ADDRESS CONFIRMATION CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceVariant.withOpacity( 0.3)
                : colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity( 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity( 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isHomeSelected ? Icons.home_rounded : Icons.business_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fullNameController.text.isNotEmpty
                          ? _fullNameController.text
                          : "Customer Address",
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _addressController.text.isNotEmpty
                          ? "${_addressController.text}${_landmarkController.text.isNotEmpty ? ', ${_landmarkController.text}' : ''}${_selectedCity != null ? ', ${_selectedCity!.name}' : ''}${_selectedState != null ? ', ${_selectedState!.name}' : ''}${_selectedCountry != null ? ', ${_selectedCountry!.name}' : ''}${_pincodeController.text.isNotEmpty ? ' - ${_pincodeController.text}' : ''}"
                          : "123 Main Street, Sector 4, New Delhi",
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12.5,
                      ),
                    ),
                    if (_mobileController.text.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        "Phone: $_selectedCountryCode ${_mobileController.text}",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// PRICE BREAKDOWN CARD
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceVariant.withOpacity( 0.6)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity( 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity( isDark ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price Details",
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _buildPriceRow("Product Price", "₹2,499", colorScheme),
              const SizedBox(height: 10),
              _buildPriceRow(
                "Discount",
                "-₹500",
                colorScheme,
                valueColor: Colors.green.shade600,
              ),
              const SizedBox(height: 10),
              _buildPriceRow(
                "Delivery Charge",
                "FREE",
                colorScheme,
                valueColor: Colors.green.shade600,
              ),
              const SizedBox(height: 14),
              Divider(color: colorScheme.outlineVariant.withOpacity( 0.6)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "₹1,999",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// PAYMENT METHOD SELECTION
        Text(
          "Payment Option",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        _buildPaymentOption(
          id: 'ONLINE',
          title: 'Online Payment (UPI / Cards)',
          subtitle: 'Instant secure payment via Google Pay, PhonePe or Cards',
          icon: Icons.account_balance_wallet_outlined,
          colorScheme: colorScheme,
          isDark: isDark,
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    ColorScheme colorScheme, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13.5),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity( 0.08)
              : (isDark
                    ? colorScheme.surfaceVariant.withOpacity( 0.3)
                    : colorScheme.surfaceVariant),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withOpacity( 0.5),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedPaymentMethod,
              onChanged: (val) {
                if (val != null) setState(() => _selectedPaymentMethod = val);
              },
              activeColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
