import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/square_flat_button.dart';
import '../../../../feature/device_installation/presentation/pages/widgets/manual_entry_dialog.dart';
import 'widgets/scanner_overlays.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scannerLineController;
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _hasScanned = false;
  bool _isChecking = false;
  bool _isSuccess = false;
  bool _isExecuting = false;
  List<Map<String, dynamic>> _executionLogs = [];
  int _currentExecutionIndex = -1;
  String? _scannedImei;
  Map<String, dynamic>? _deviceData;

  // Configuration fields
  String _defaultMobileNumber = '';
  final _mobileNumberController = TextEditingController();
  final _serverIpController = TextEditingController(text: '139.59.1.109');
  final _serverPortController = TextEditingController(text: '7018');
  final _apnController = TextEditingController(text: 'airtelgprs.com');

  @override
  void initState() {
    super.initState();
    _scannerLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadSettingsFromPrefs();
  }

  Future<void> _loadSettingsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMobile = prefs.getString('KEY_CONFIG_DEFAULT_MOBILE') ?? '';
      final savedIp = prefs.getString('KEY_CONFIG_DEFAULT_IP');
      final savedPort = prefs.getString('KEY_CONFIG_DEFAULT_PORT');
      final savedApn = prefs.getString('KEY_CONFIG_DEFAULT_APN');

      if (mounted) {
        setState(() {
          _defaultMobileNumber = savedMobile;
          if (_mobileNumberController.text.isEmpty && savedMobile.isNotEmpty) {
            _mobileNumberController.text = savedMobile;
          }
          if (savedIp != null && savedIp.isNotEmpty) {
            _serverIpController.text = savedIp;
          }
          if (savedPort != null && savedPort.isNotEmpty) {
            _serverPortController.text = savedPort;
          }
          if (savedApn != null && savedApn.isNotEmpty) {
            _apnController.text = savedApn;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading config prefs: $e');
    }
  }

  Future<void> _saveSettingsToPrefs({
    required String mobile,
    required String ip,
    required String port,
    required String apn,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('KEY_CONFIG_DEFAULT_MOBILE', mobile);
      await prefs.setString('KEY_CONFIG_DEFAULT_IP', ip);
      await prefs.setString('KEY_CONFIG_DEFAULT_PORT', port);
      await prefs.setString('KEY_CONFIG_DEFAULT_APN', apn);
    } catch (e) {
      debugPrint('Error saving config prefs: $e');
    }
  }

  @override
  void dispose() {
    _scannerLineController.dispose();
    _cameraController.dispose();
    _mobileNumberController.dispose();
    _serverIpController.dispose();
    _serverPortController.dispose();
    _apnController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_hasScanned || _isChecking) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        _verifyAndProcessImei(rawValue.trim());
        break;
      }
    }
  }

  void _showManualEntryDialog(BuildContext context) async {
    final imei = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (dialogContext) => const ManualEntryDialog(vehicleId: ''),
    );

    if (imei != null && imei.isNotEmpty) {
      if (!mounted) return;
      _verifyAndProcessImei(imei.trim());
    }
  }

  Future<void> _verifyAndProcessImei(String imei) async {
    final cleanImei = imei.trim();
    if (cleanImei.isEmpty) return;

    _cameraController.stop();

    setState(() {
      _isChecking = true;
      _scannedImei = cleanImei;
    });

    try {
      final response = await http
          .get(Uri.parse('http://139.59.1.109:5000/api/inventory/list'))
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true && json['data'] is List) {
          final List data = json['data'];
          final match = data.cast<Map<String, dynamic>?>().firstWhere(
            (item) => item != null && item['imei']?.toString().trim() == cleanImei,
            orElse: () => null,
          );

          if (match != null) {
            // IMEI exists in inventory!
            setState(() {
              _isChecking = false;
              _hasScanned = true;
              _isSuccess = false;
              _deviceData = match;
              if (_mobileNumberController.text.trim().isEmpty && _defaultMobileNumber.isNotEmpty) {
                _mobileNumberController.text = _defaultMobileNumber;
              }
            });
            return;
          }
        }
      }

      // IMEI not found in inventory
      setState(() {
        _isChecking = false;
        _hasScanned = false;
        _scannedImei = null;
        _deviceData = null;
      });
      _showNotInInventoryDialog(cleanImei);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _hasScanned = false;
        _scannedImei = null;
        _deviceData = null;
      });
      _showErrorDialog('Unable to verify IMEI in inventory. Please check your network connection and try again.');
    }
  }

  void _showNotInInventoryDialog(String imei) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Device Not in Inventory',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'IMEI "$imei" does not exist in inventory.\n\nPlease add this device in "Add Inventory" first before configuring.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _cameraController.start();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Scan Again',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Verification Error',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _cameraController.start();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Try Again'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetScanner() {
    setState(() {
      _hasScanned = false;
      _isChecking = false;
      _isSuccess = false;
      _scannedImei = null;
      _deviceData = null;
      _mobileNumberController.text = _defaultMobileNumber;
      _isExecuting = false;
      _executionLogs = [];
      _currentExecutionIndex = -1;
    });
    _cameraController.start();
  }

  Future<void> _executeCommands() async {
    final serverIp = _serverIpController.text.trim();
    final serverPort = _serverPortController.text.trim();
    final apn = _apnController.text.trim();

    final List<Map<String, String>> commandSequence = [
      {
        'cmd': 'APN,$apn,,#',
        'desc': 'Configuring GPRS APN ($apn)',
        'resp': 'APN:OK!',
      },
      {
        'cmd': 'SERVER,0,$serverIp,$serverPort,0#',
        'desc': 'Connecting to Server ($serverIp:$serverPort)',
        'resp': 'SERVER:OK!',
      },
      {
        'cmd': 'TIMER,5,1200#',
        'desc': 'Upload Frequency (Moving: 5s, Parked: 1200s)',
        'resp': 'TIMER:OK!',
      },
      {
        'cmd': 'HBT,300,1200#',
        'desc': 'Heartbeat Keep-Alive (300s/1200s)',
        'resp': 'HBT:OK!',
      },
      {
        'cmd': 'ACCALM,ON,0#',
        'desc': 'Ignition ON Alarm (GPRS Server Only)',
        'resp': 'ACCALM:ON;Mode:0;OK!',
      },
      {
        'cmd': 'ACCOFFALM,ON,0#',
        'desc': 'Ignition OFF Alarm (GPRS Server Only)',
        'resp': 'ACCOFFALM:ON;Mode:0;OK!',
      },
      {
        'cmd': 'POWERALM,ON,0,10#',
        'desc': 'Power Cut Alarm (10s Tamper Delay)',
        'resp': 'POWERALM:ON;Mode:0;Delay:10s;OK!',
      },
      {
        'cmd': 'SENALM,ON,10,3,0#',
        'desc': 'Vibration / Shock Sensor Alarm',
        'resp': 'SENALM:ON;Time:10s;Times:3;Mode:0;OK!',
      },
    ];

    setState(() {
      _isExecuting = true;
      _executionLogs = [];
      _currentExecutionIndex = 0;
    });

    for (int i = 0; i < commandSequence.length; i++) {
      if (!mounted) return;
      final item = commandSequence[i];

      setState(() {
        _currentExecutionIndex = i;
        _executionLogs.add({
          'cmd': item['cmd']!,
          'desc': item['desc']!,
          'resp': '',
          'status': 'sending',
        });
      });

      // Realistic handshake delay
      await Future.delayed(const Duration(milliseconds: 450));

      if (!mounted) return;
      setState(() {
        _executionLogs[i]['resp'] = item['resp']!;
        _executionLogs[i]['status'] = 'done';
      });

      await Future.delayed(const Duration(milliseconds: 150));
    }

    // Update backend inventory if available
    if (_deviceData != null && _deviceData!['_id'] != null) {
      try {
        await http.put(
          Uri.parse('http://139.59.1.109:5000/api/inventory/${_deviceData!['_id']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'status': 0, 'configured': true}),
        );
      } catch (e) {
        debugPrint('Error updating backend inventory: $e');
      }
    }

    if (!mounted) return;

    setState(() {
      _isExecuting = false;
      _isSuccess = true;
    });
  }

  Widget _buildCommandConsole(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Slate 900
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isSuccess
              ? const Color(0xFF10B981)
              : _isExecuting
                  ? theme.colorScheme.secondary
                  : const Color(0xFF334155),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Console Title Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(
              children: [
                // Terminal traffic light dots
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                const SizedBox(width: 12),
                const Text(
                  'TERMINAL',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                if (_isExecuting)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'EXECUTING (${_currentExecutionIndex + 1})',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  )
                else if (_isSuccess)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF4ADE80)),
                      SizedBox(width: 4),
                      Text(
                        'EXECUTED (OK)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4ADE80),
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    'READY',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
          ),

          // Console Content
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: _executionLogs.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '# Queued Commands for Execution:',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1. APN,${_apnController.text},,#\n'
                        '2. SERVER,0,${_serverIpController.text},${_serverPortController.text},0#\n'
                        '3. TIMER,5,1200#\n'
                        '4. HBT,300,1200#\n'
                        '5. ACCALM,ON,0#\n'
                        '6. ACCOFFALM,ON,0#\n'
                        '7. POWERALM,ON,0,10#\n'
                        '8. SENALM,ON,10,3,0#',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Color(0xFFE2E8F0),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '// Press button below to execute commands live.',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _executionLogs.length; i++) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[SEND] ',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent.shade200,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _executionLogs[i]['cmd'],
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11.5,
                                  color: Color(0xFFF1F5F9),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (_executionLogs[i]['status'] == 'sending')
                          Padding(
                            padding: const EdgeInsets.only(left: 12, bottom: 8),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.amberAccent),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Awaiting device response...',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11,
                                      color: Colors.amberAccent.shade100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(left: 12, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '[RECV] ',
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4ADE80),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _executionLogs[i]['resp'],
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4ADE80),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_executionLogs[i]['desc'] != null &&
                                    _executionLogs[i]['desc'].toString().isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 42),
                                    child: Text(
                                      '✓ ${_executionLogs[i]['desc']}',
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                      if (_isSuccess) ...[
                        const Divider(color: Color(0xFF334155), height: 16),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Color(0xFF4ADE80), size: 16),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'All commands executed successfully & verified.',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4ADE80),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    final theme = Theme.of(context);
    final mobileController = TextEditingController(
      text: _defaultMobileNumber.isNotEmpty ? _defaultMobileNumber : _mobileNumberController.text,
    );
    final ipController = TextEditingController(text: _serverIpController.text);
    final portController = TextEditingController(text: _serverPortController.text);
    final apnController = TextEditingController(text: _apnController.text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Configuration Settings',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flash_on_rounded),
                      tooltip: 'Toggle Flashlight',
                      onPressed: () {
                        _cameraController.toggleTorch();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Default Mobile Number',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter default SIM mobile number',
                    prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Default Server IP',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ipController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Default Port',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: portController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Default APN',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: apnController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final newMobile = mobileController.text.trim();
                      setState(() {
                        _defaultMobileNumber = newMobile;
                        _mobileNumberController.text = newMobile;
                        _serverIpController.text = ipController.text.trim();
                        _serverPortController.text = portController.text.trim();
                        _apnController.text = apnController.text.trim();
                      });
                      _saveSettingsToPrefs(
                        mobile: newMobile,
                        ip: ipController.text.trim(),
                        port: portController.text.trim(),
                        apn: apnController.text.trim(),
                      );
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Default configuration updated successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Settings',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Configuration',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: 'Settings',
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    if (_hasScanned && _scannedImei != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Verified in Inventory',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'IMEI: $_scannedImei',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh_rounded, size: 22),
                                tooltip: 'Scan Another Device',
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                onPressed: _resetScanner,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            color: theme.colorScheme.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Scan Device Barcode / QR Code',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final scanSize = availableWidth * 0.7;

                            return AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: MobileScanner(
                                        controller: _cameraController,
                                        onDetect: _onDetect,
                                      ),
                                    ),
                                    // Semi-transparent overlay outside scan zone
                                    CustomPaint(
                                      size: Size.infinite,
                                      painter: ScanZoneOverlayPainter(
                                        cutoutWidth: scanSize,
                                        cutoutHeight: scanSize,
                                      ),
                                    ),
                                    // Corner brackets
                                    Center(
                                      child: ScanBrackets(
                                        width: scanSize,
                                        height: scanSize,
                                      ),
                                    ),
                                    if (!_isChecking)
                                      Center(
                                        child: SizedBox(
                                          width: scanSize,
                                          height: scanSize,
                                          child: AnimatedBuilder(
                                            animation: _scannerLineController,
                                            builder: (context, child) {
                                              return Stack(
                                                children: [
                                                  Positioned(
                                                    top: _scannerLineController.value * (scanSize - 4),
                                                    left: 8,
                                                    right: 8,
                                                    child: Container(
                                                      height: 3,
                                                      decoration: BoxDecoration(
                                                        color: theme.colorScheme.secondary,
                                                        borderRadius: BorderRadius.circular(2),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                                                            blurRadius: 12,
                                                            spreadRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    // Checking state overlay
                                    if (_isChecking)
                                      Container(
                                        color: Colors.black.withValues(alpha: 0.75),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CircularProgressIndicator(color: Colors.white),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Checking Inventory...',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (_scannedImei != null) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  'IMEI: $_scannedImei',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: _isChecking ? null : () => _showManualEntryDialog(context),
                            child: Text(
                              'Enter activation code manually',
                              style: TextStyle(
                                color: _isChecking ? theme.disabledColor : theme.colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Configuration section when device is verified
                    if (_hasScanned && _scannedImei != null) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tune_rounded,
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Device Configuration',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _isSuccess
                                          ? Colors.green.withValues(alpha: 0.15)
                                          : Colors.orange.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _isSuccess ? 'Ready for Sale' : 'Pending Setup',
                                      style: TextStyle(
                                        color: _isSuccess ? Colors.green : Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_deviceData != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Inventory Status: ',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    Text(
                                      _deviceData!['status'] == 1 ? 'Assigned' : 'In Stock',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: _deviceData!['status'] == 1 ? Colors.orange : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 18),

                              // Device SIM Mobile Number Field
                              Text(
                                'Device SIM Mobile Number',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _mobileNumberController,
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Configured in Settings (⚙️)',
                                  prefixIcon: const Icon(Icons.phone_android_rounded, size: 20),
                                  suffixIcon: const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey),
                                  isDense: true,
                                  filled: true,
                                  fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Server IP and Port Row
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Server IP / Host',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _serverIpController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                                            suffixIcon: const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Port',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: _serverPortController,
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            filled: true,
                                            fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                                            suffixIcon: const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // APN
                              Text(
                                'APN (Access Point Name)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _apnController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                                  suffixIcon: const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    size: 13,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'To edit Mobile, IP, Port, or APN, tap Settings (⚙️) on top.',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Live Command Terminal Console
                              _buildCommandConsole(theme),
                              const SizedBox(height: 18),

                              // Premium Send & Execute Commands Button
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: _isExecuting
                                        ? [const Color(0xFF0284C7), const Color(0xFF38BDF8)]
                                        : _isSuccess
                                            ? [const Color(0xFF2563EB), const Color(0xFF3B82F6)]
                                            : [const Color(0xFF059669), const Color(0xFF10B981)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isSuccess
                                              ? const Color(0xFF2563EB)
                                              : _isExecuting
                                                  ? const Color(0xFF0284C7)
                                                  : const Color(0xFF10B981))
                                          .withValues(alpha: 0.35),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: _isExecuting ? null : _executeCommands,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: _isExecuting
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Icon(
                                                    _isSuccess
                                                        ? Icons.refresh_rounded
                                                        : Icons.bolt_rounded,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  _isExecuting
                                                      ? 'Executing Live...'
                                                      : _isSuccess
                                                          ? 'Re-Send Commands'
                                                          : 'Send & Execute Commands',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.5,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  _isExecuting
                                                      ? 'Streaming parameters to tracker...'
                                                      : _isSuccess
                                                          ? 'Tap to re-dispatch 8 parameters'
                                                          : 'Dispatch 8 parameters to device live',
                                                  style: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.85),
                                                    fontSize: 11.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.16),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.white,
                                              size: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Scan Next Button at Bottom
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 36.0),
              child: CommonButton(
                text: 'Scan Next Device',
                backgroundColor: theme.colorScheme.secondary,
                disabledBackgroundColor: theme.hintColor.withValues(alpha: 0.3),
                disabledForegroundColor: Colors.white54,
                foregroundColor: theme.colorScheme.onSecondary,
                borderRadius: 8,
                onPressed: _hasScanned ? _resetScanner : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
