import 'dart:convert';
import 'dart:io';

void main() async {
  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  final additions = {
    'app_en.arb': {
      "hoursLink": "{hours} hours link",
      "@hoursLink": {
        "placeholders": {
          "hours": {
            "type": "String"
          }
        }
      },
      "activeSharingCount": "{count} active sharing",
      "@activeSharingCount": {
        "placeholders": {
          "count": {
            "type": "int"
          }
        }
      },
      "sharingStoppedSuccessfully": "Sharing stopped successfully.",
      "failedToCreateShareLink": "Failed to create share link"
    },
    'app_hi.arb': {
      "hoursLink": "{hours} घंटे का लिंक",
      "@hoursLink": {
        "placeholders": {
          "hours": {
            "type": "String"
          }
        }
      },
      "activeSharingCount": "{count} सक्रिय शेयरिंग",
      "@activeSharingCount": {
        "placeholders": {
          "count": {
            "type": "int"
          }
        }
      },
      "sharingStoppedSuccessfully": "शेयरिंग सफलतापूर्वक रोक दी गई।",
      "failedToCreateShareLink": "शेयर लिंक बनाने में विफल"
    },
    'app_mr.arb': {
      "hoursLink": "{hours} तासांची लिंक",
      "@hoursLink": {
        "placeholders": {
          "hours": {
            "type": "String"
          }
        }
      },
      "activeSharingCount": "{count} सक्रिय शेअरिंग",
      "@activeSharingCount": {
        "placeholders": {
          "count": {
            "type": "int"
          }
        }
      },
      "sharingStoppedSuccessfully": "शेअरिंग यशस्वीरित्या थांबवली.",
      "failedToCreateShareLink": "शेअर लिंक तयार करण्यात अयशस्वी"
    },
    'app_ar.arb': {
      "hoursLink": "رابط لمدة {hours} ساعات",
      "@hoursLink": {
        "placeholders": {
          "hours": {
            "type": "String"
          }
        }
      },
      "activeSharingCount": "{count} مشاركة نشطة",
      "@activeSharingCount": {
        "placeholders": {
          "count": {
            "type": "int"
          }
        }
      },
      "sharingStoppedSuccessfully": "تم إيقاف المشاركة بنجاح.",
      "failedToCreateShareLink": "فشل في إنشاء رابط المشاركة"
    },
    'app_kn.arb': {
      "hoursLink": "{hours} ಗಂಟೆಗಳ ಲಿಂಕ್",
      "@hoursLink": {
        "placeholders": {
          "hours": {
            "type": "String"
          }
        }
      },
      "activeSharingCount": "{count} ಸಕ್ರಿಯ ಹಂಚಿಕೆ",
      "@activeSharingCount": {
        "placeholders": {
          "count": {
            "type": "int"
          }
        }
      },
      "sharingStoppedSuccessfully": "ಹಂಚಿಕೆಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ನಿಲ್ಲಿಸಲಾಗಿದೆ.",
      "failedToCreateShareLink": "ಹಂಚಿಕೆ ಲಿಂಕ್ ರಚಿಸಲು ವಿಫಲವಾಗಿದೆ"
    },
    'app_ta.arb': {
      "hoursLink": "{hours} மணிநேர இணைப்பு",
      "@hoursLink": {
        "placeholders": {
          "hours": {
            "type": "String"
          }
        }
      },
      "activeSharingCount": "{count} செயலில் உள்ள பகிர்வு",
      "@activeSharingCount": {
        "placeholders": {
          "count": {
            "type": "int"
          }
        }
      },
      "sharingStoppedSuccessfully": "பகிர்வு வெற்றிகரமாக நிறுத்தப்பட்டது.",
      "failedToCreateShareLink": "பகிர்வு இணைப்பை உருவாக்குவதில் தோல்வி"
    }
  };

  for (var file in files) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final Map<String, dynamic>? data = additions[fileName];
    if (data != null) {
      final content = await file.readAsString();
      Map<String, dynamic> json;
      try {
        json = jsonDecode(content);
      } catch (e) {
        print('Error parsing $fileName');
        continue;
      }
      
      // Add new keys if not present
      for (var entry in data.entries) {
        if (!json.containsKey(entry.key)) {
          json[entry.key] = entry.value;
        }
      }
      
      final encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(json));
      print('Updated $fileName');
    }
  }
}
