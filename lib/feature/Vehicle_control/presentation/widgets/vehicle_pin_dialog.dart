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
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.8)),
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
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6))),
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
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.8), fontSize: 13),
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
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.6))),
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

  Widget _build4DigitPinInput(ThemeData theme) {
    final text = _pinController.text;
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hidden TextField to receive native keyboard inputs
          Opacity(
            opacity: 0.0,
            child: SizedBox(
              width: 240,
              height: 56,
              child: TextField(
                enabled: !_isSubmitting,
                controller: _pinController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  _onPinChanged(val);
                  if (val.length == 4 && !_isSubmitting) {
                    _processPin(val);
                  }
                },
              ),
            ),
          ),

          // 4 Premium Animated OTP-Style PIN Digit Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isFilled = index < text.length;
              final isFocusedSlot = index == text.length && _focusNode.hasFocus;

              return Container(
                width: 48,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: isFilled
                      ? theme.colorScheme.primary.withOpacity(0.12)
                      : isFocusedSlot
                          ? theme.colorScheme.primary.withOpacity(0.06)
                          : theme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isFilled || isFocusedSlot
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withOpacity(0.5),
                    width: isFocusedSlot || isFilled ? 2 : 1,
                  ),
                  boxShadow: [
                    if (isFilled || isFocusedSlot)
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: isFilled
                        ? Container(
                            key: ValueKey('filled_$index'),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : isFocusedSlot
                            ? Container(
                                key: ValueKey('cursor_$index'),
                                width: 2,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              )
                            : const SizedBox.shrink(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocking = widget.isLocked && _currentState == PinDialogState.enterPin;

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 16,
      child: _isInitialLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Glowing Header Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isUnlocking
                                ? Colors.green.withOpacity(0.12)
                                : theme.colorScheme.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnlocking
                                  ? Colors.green.withOpacity(0.3)
                                  : theme.colorScheme.primary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isUnlocking ? Icons.lock_open_rounded : Icons.lock_rounded,
                            size: 36,
                            color: isUnlocking ? Colors.green : theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getTitle(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.vehicleName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getSubtitle(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 4 Individual OTP Box Inputs
                        _build4DigitPinInput(theme),

                        if (_errorText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              _errorText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),

                        const SizedBox(height: 24),

                        if (_pinController.text.length == 4)
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : () => _processPin(_pinController.text),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),

                        if (_currentState == PinDialogState.enterPin)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: TextButton(
                              onPressed: _isSubmitting ? null : _onForgotPin,
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.forgotPin,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
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
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
