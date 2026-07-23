import 'dart:convert';
import 'dart:io';

void main() async {
  final l10nDir = Directory('lib/l10n');
  final arbFiles = l10nDir.listSync().where((f) => f.path.endsWith('.arb')).toList();

  final newKeys = {
    "locationPermissionWarning": "Sharing your phone's location works correctly only if it can access your location \"all the time\"",
    "goToSettingsAndSelectAllowAllTheTime": "Go to settings and select \"Allow all the time\"",
    "trackifyApp": "Trackify",
    "locationText": "Location",
    "tapIntoLocation": "Tap into Location",
    "goToSettingsBtn": "Go to Settings",
    "shareLiveLocationFor": "Share your live location for",
    "twoHours": "2 hours",
    "fourHours": "4 hours",
    "eightHours": "8 hours",
    "untilStopped": "Until Stopped",
    "shareLocationLink": "Share location link"
  };

  for (var file in arbFiles) {
    if (file is File) {
      final content = await file.readAsString();
      final Map<String, dynamic> json = jsonDecode(content);
      
      json.addAll(newKeys);
      
      final encoder = JsonEncoder.withIndent('  ');
      final newContent = encoder.convert(json);
      await file.writeAsString(newContent);
      print('Updated ${file.path}');
    }
  }
}
