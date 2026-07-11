import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class SharedRidesScreen extends StatefulWidget {
  const SharedRidesScreen({super.key});

  @override
  State<SharedRidesScreen> createState() => _SharedRidesScreenState();
}

class _SharedRidesScreenState extends State<SharedRidesScreen> {
  int _selectedIndex = 1; // "Shared with me" selected by default as in screenshot

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    // Premium styling colors matching theme
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final bubbleColor = isDark ? const Color(0xFF454F5F) : const Color(0xFFD1D5DB);
    final pinColor = scaffoldBg;
    final bottomBarColor = isDark ? const Color(0xFF131924) : const Color(0xFFF3F4F6);
    final selectedTabColor = isDark ? const Color(0xFFFCD34D) : const Color(0xFFD97706); // Premium Amber/Yellow
    final unselectedTabColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.sharedRides,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Speech Bubble with Location Pin inside
                    CustomPaint(
                      size: const Size(120, 100),
                      painter: SpeechBubblePainter(color: bubbleColor),
                      child: SizedBox(
                        width: 120,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Center(
                            child: Icon(
                              Icons.location_on,
                              size: 44,
                              color: pinColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Centered description text
                    Text(
                      _selectedIndex == 1
                          ? "All live location and rides shared with you will show up here"
                          : "All live location and rides shared by you will show up here",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Custom Bottom Navigation Bar
          Container(
            decoration: BoxDecoration(
              color: bottomBarColor,
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tab: Shared by me
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share_location,
                          color: _selectedIndex == 0 ? selectedTabColor : unselectedTabColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Shared by me",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _selectedIndex == 0 ? selectedTabColor : unselectedTabColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tab: Shared with me
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom Speech Bubble Icon
                        CustomPaint(
                          size: const Size(26, 22),
                          painter: SpeechBubblePainter(
                            color: _selectedIndex == 1 ? selectedTabColor : unselectedTabColor,
                            tipHeight: 4,
                            tipWidth: 6,
                            borderRadius: 4,
                          ),
                          child: SizedBox(
                            width: 26,
                            height: 22,
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 4.0),
                              child: Center(
                                child: Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Shared with me",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _selectedIndex == 1 ? selectedTabColor : unselectedTabColor,
                            fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color color;
  final double? tipHeight;
  final double? tipWidth;
  final double? borderRadius;

  SpeechBubblePainter({
    required this.color,
    this.tipHeight,
    this.tipWidth,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double actualTipHeight = tipHeight ?? 15;
    final double actualTipWidth = tipWidth ?? 18;
    final double actualRadius = borderRadius ?? 16;
    final double bottomY = size.height - actualTipHeight;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, bottomY),
      Radius.circular(actualRadius),
    );
    path.addRRect(rrect);

    // Bottom tip triangle
    final double centerX = size.width / 2;

    path.moveTo(centerX - actualTipWidth / 2, bottomY);
    path.lineTo(centerX, size.height);
    path.lineTo(centerX + actualTipWidth / 2, bottomY);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
