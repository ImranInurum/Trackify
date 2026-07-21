import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/l10n/app_localizations.dart';

class VehiclePinDialog extends StatefulWidget {
  final bool isLocked;
  final String vehicleName;
  final String imei;
  const VehiclePinDialog({super.key, required this.isLocked, required this.vehicleName, required this.imei});

  static Future<bool> show(BuildContext context, bool isLocked, String vehicleName, String imei) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => VehiclePinDialog(isLocked: isLocked, vehicleName: vehicleName, imei: imei),
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
  
  String _newPin = "";
  
  bool _isInitialLoading = true;
  bool _isSubmitting = false;
  bool _isResettingPin = false;
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
    try {
      final apiService = NetworkApiService();
      final result = await apiService.getGetApiResponse(ApiURL.devicePinStatus(widget.imei));
      
      bool isSetOnServer = false;
      result.fold(
        (failure) {},
        (data) {
          if (data['success'] == true) {
            isSetOnServer = data['isSet'] == true || data['status'] == 1;
          }
        },
      );

      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          if (isSetOnServer) {
            _currentState = PinDialogState.enterPin;
          } else {
            _currentState = PinDialogState.setNewPin;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _errorText = "Failed to load PIN status";
        });
      }
    }
  }

  void _onPinChanged(String value) {
    if (_errorText.isNotEmpty) {
      setState(() {
        _errorText = "";
      });
    }
    // Update state to toggle Submit button visibility
    setState(() {});
  }

  Future<void> _processPin(String pin) async {
    switch (_currentState) {
      case PinDialogState.enterPin:
        await _verifyPinAndProceed(pin);
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
          await _savePinAndProceed(pin);
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

  Future<void> _verifyPinAndProceed(String pin) async {
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final apiService = NetworkApiService();
      final response = await apiService.getPostApiResponse(
        ApiURL.verifyDevicePin,
        {"imei": widget.imei, "pin": pin},
      );
      
      response.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _isSubmitting = false;
              _errorText = failure.message;
              _pinController.clear();
            });
          }
        },
        (data) async {
          if (data['success'] == true) {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          } else {
            if (mounted) {
              setState(() {
                _isSubmitting = false;
                _errorText = data['message']?.toString() ?? AppLocalizations.of(context)!.incorrectPin;
                _pinController.clear();
              });
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorText = AppLocalizations.of(context)!.incorrectPin;
          _pinController.clear();
        });
      }
    }
  }

  Future<void> _savePinAndProceed(String pin) async {
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final apiService = NetworkApiService();
      final apiUrl = _isResettingPin ? ApiURL.resetDevicePin : ApiURL.setDevicePin;
      final payload = _isResettingPin 
          ? {"imei": widget.imei, "newPin": pin}
          : {"imei": widget.imei, "pin": pin};
          
      final response = await apiService.getPostApiResponse(apiUrl, payload);
      
      response.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _isSubmitting = false;
              _errorText = failure.message;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
            );
          }
        },
        (data) async {
          if (data['success'] == true) {
            await AppPreference.instance.set(key: "vehicle_lock_pin", value: pin);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(data['message']?.toString() ?? "PIN updated successfully"), 
                  backgroundColor: Colors.green
                ),
              );
              Navigator.of(context).pop(true);
            }
          } else {
            if (mounted) {
              final errorMsg = data['message']?.toString() ?? "Failed to update PIN";
              setState(() {
                _isSubmitting = false;
                _errorText = errorMsg;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorText = "An error occurred";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _onForgotPin() {
    showDialog(
      context: context,
      builder: (ctx) {
        bool sendingOtp = false;
        String localError = "";
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.resetPinTitle,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "An OTP will be sent to your registered email to reset the PIN.",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                  ),
                  if (localError.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      localError,
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: sendingOtp ? null : () => Navigator.pop(ctx),
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: sendingOtp ? null : () async {
                    setDialogState(() {
                      sendingOtp = true;
                      localError = "";
                    });
                    
                    try {
                      final apiService = NetworkApiService();
                      final response = await apiService.getPostApiResponse(
                        ApiURL.changePinOtp,
                        {"imei": widget.imei},
                      );
                      
                      response.fold(
                        (failure) {
                          setDialogState(() {
                            sendingOtp = false;
                            localError = failure.message;
                          });
                        },
                        (data) {
                          if (data['success'] == true) {
                            Navigator.pop(ctx);
                            _showOtpVerificationDialog();
                          } else {
                            setDialogState(() {
                              sendingOtp = false;
                              localError = data['message']?.toString() ?? "Failed to send OTP";
                            });
                          }
                        },
                      );
                    } catch (e) {
                      setDialogState(() {
                        sendingOtp = false;
                        localError = "An error occurred";
                      });
                    }
                  },
                  child: sendingOtp 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Send OTP"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showOtpVerificationDialog() {
    final otpController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool verifying = false;
        String localError = "";
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                "Verify OTP",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Please enter the OTP sent to your registered email address.",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: "OTP",
                      border: const OutlineInputBorder(),
                      errorText: localError.isNotEmpty ? localError : null,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: verifying ? null : () => Navigator.pop(ctx),
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: verifying ? null : () async {
                    final otp = otpController.text.trim();
                    if (otp.isEmpty) {
                      setDialogState(() => localError = "Please enter OTP");
                      return;
                    }
                    
                    setDialogState(() {
                      verifying = true;
                      localError = "";
                    });
                    
                    try {
                      final apiService = NetworkApiService();
                      final response = await apiService.getPostApiResponse(
                        ApiURL.verifyChangePinOtp,
                        {"imei": widget.imei, "otp": otp},
                      );
                      
                      response.fold(
                        (failure) {
                          setDialogState(() {
                            verifying = false;
                            localError = failure.message;
                          });
                        },
                        (data) async {
                          if (data['success'] == true) {
                            await AppPreference.instance.clearByKey(key: "vehicle_lock_pin");
                            if (mounted) {
                              Navigator.pop(ctx);
                              setState(() {
                                _newPin = "";
                                _currentState = PinDialogState.setNewPin;
                                _pinController.clear();
                                _errorText = "";
                                _isResettingPin = true;
                              });
                            }
                          } else {
                            setDialogState(() {
                              verifying = false;
                              localError = data['message']?.toString() ?? "Invalid OTP";
                            });
                          }
                        },
                      );
                    } catch (e) {
                      setDialogState(() {
                        verifying = false;
                        localError = "An error occurred";
                      });
                    }
                  },
                  child: verifying 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Verify & Reset PIN"),
                ),
              ],
            );
          }
        );
      },
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
      child: _isInitialLoading 
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                    const SizedBox(height: 4),
                    Text(
                      widget.vehicleName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
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
                        enabled: !_isSubmitting,
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
                    
                    if (_pinController.text.length == 4)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : () => _processPin(_pinController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.onPrimary,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                        ),
                      ),
                    
                    if (_currentState == PinDialogState.enterPin)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          onPressed: _isSubmitting ? null : _onForgotPin,
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                          child: Text(AppLocalizations.of(context)!.forgotPin),
                        ),
                      ),
                  ],
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
