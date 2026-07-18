import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/l10n/app_localizations.dart';

class VehiclePinDialog extends StatefulWidget {
  final bool isLocked;
  const VehiclePinDialog({super.key, required this.isLocked});

  static Future<bool> show(BuildContext context, bool isLocked) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => VehiclePinDialog(isLocked: isLocked),
    );
    return result ?? false;
  }

  @override
  State<VehiclePinDialog> createState() => _VehiclePinDialogState();
}

enum PinDialogState {
  enterPin,
  setNewPin,
  confirmNewPin,
}

class _VehiclePinDialogState extends State<VehiclePinDialog> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  
  String _storedPin = "";
  String _newPin = "";
  
  bool _isLoading = true;
  String _errorText = "";
  PinDialogState _currentState = PinDialogState.enterPin;

  @override
  void initState() {
    super.initState();
    _checkStoredPin();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkStoredPin() async {
    final pin = await AppPreference.instance.get(key: "vehicle_lock_pin");
    if (mounted) {
      setState(() {
        _storedPin = pin;
        _isLoading = false;
        if (_storedPin.isEmpty) {
          _currentState = PinDialogState.setNewPin;
        } else {
          _currentState = PinDialogState.enterPin;
        }
      });
    }
  }

  void _onPinChanged(String value) {
    if (_errorText.isNotEmpty) {
      setState(() {
        _errorText = "";
      });
    }
    if (value.length == 4) {
      _processPin(value);
    }
  }

  void _processPin(String pin) {
    switch (_currentState) {
      case PinDialogState.enterPin:
        if (pin == _storedPin) {
          Navigator.of(context).pop(true);
        } else {
          setState(() {
            _errorText = AppLocalizations.of(context)!.incorrectPin;
            _pinController.clear();
          });
        }
        break;
      case PinDialogState.setNewPin:
        setState(() {
          _newPin = pin;
          _currentState = PinDialogState.confirmNewPin;
          _pinController.clear();
        });
        break;
      case PinDialogState.confirmNewPin:
        if (pin == _newPin) {
          _savePinAndProceed(pin);
        } else {
          setState(() {
            _errorText = AppLocalizations.of(context)!.pinsDoNotMatch;
            _currentState = PinDialogState.setNewPin;
            _newPin = "";
            _pinController.clear();
          });
        }
        break;
    }
  }

  Future<void> _savePinAndProceed(String pin) async {
    await AppPreference.instance.set(key: "vehicle_lock_pin", value: pin);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _onForgotPin() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          AppLocalizations.of(context)!.resetPinTitle,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          AppLocalizations.of(context)!.resetPinDescription,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              await AppPreference.instance.clearByKey(key: "vehicle_lock_pin");
              if (mounted) {
                Navigator.pop(ctx);
                setState(() {
                  _storedPin = "";
                  _newPin = "";
                  _currentState = PinDialogState.setNewPin;
                  _pinController.clear();
                  _errorText = "";
                });
              }
            },
            child: Text(AppLocalizations.of(context)!.resetBtn),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentState) {
      case PinDialogState.enterPin:
        return widget.isLocked ? AppLocalizations.of(context)!.unlockVehiclePinTitle : AppLocalizations.of(context)!.lockVehiclePinTitle;
      case PinDialogState.setNewPin:
        return AppLocalizations.of(context)!.setNewPinTitle;
      case PinDialogState.confirmNewPin:
        return AppLocalizations.of(context)!.confirmNewPinTitle;
    }
  }

  String _getSubtitle() {
    switch (_currentState) {
      case PinDialogState.enterPin:
        return AppLocalizations.of(context)!.enterPinSubtitle;
      case PinDialogState.setNewPin:
        return AppLocalizations.of(context)!.createNewPinSubtitle;
      case PinDialogState.confirmNewPin:
        return AppLocalizations.of(context)!.confirmNewPinSubtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: _isLoading 
        ? const Padding(
            padding: EdgeInsets.all(32.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isLocked && _currentState == PinDialogState.enterPin ? Icons.lock_open : Icons.lock,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _getTitle(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSubtitle(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                
                // PIN Input Field
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pinController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    obscuringCharacter: '●',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: theme.textTheme.headlineMedium?.copyWith(
                      letterSpacing: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onChanged: _onPinChanged,
                  ),
                ),
                
                if (_errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _errorText,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    if (_currentState == PinDialogState.enterPin)
                      TextButton(
                        onPressed: _onForgotPin,
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                        ),
                        child: Text(AppLocalizations.of(context)!.forgotPin),
                      ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
