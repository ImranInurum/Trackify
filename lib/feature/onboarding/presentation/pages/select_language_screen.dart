import 'package:flutter/material.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/widgets/square_flat_button.dart';
import 'package:trackify/feature/auth/presentation/pages/signin_screen.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'key': 'English', 'name': 'English'},
    {'key': 'Hindi', 'name': 'हिंदी'},
    {'key': 'Arabic', 'name': 'العربية'},
  ];

  void _saveLanguageAndContinue() async {
    await AppPreference.instance.set(
      key: AppPreference.KEY_SELECTED_LANGUAGE,
      value: _selectedLanguage,
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    var selectedColor = theme.colorScheme.primaryContainer;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.5, // Adjust opacity as needed (0.0 to 1.0)
              child: Image.asset(
                'assets/images/road.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select your language',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: textColor.withOpacity(0.5), width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.1), // Optional blend background
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _languages.map((lang) {
                        final isSelected = _selectedLanguage == lang['key'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLanguage = lang['key']!;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            color: Colors.transparent, // expand tap area
                            child: Text(
                              lang['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected ? selectedColor : textColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CommonButton(
                      text: "Let's Get Started",
                      onPressed: () => _saveLanguageAndContinue()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}