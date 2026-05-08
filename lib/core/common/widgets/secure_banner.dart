import 'package:flutter/material.dart';
import 'package:trackify/feature/my_garage/presentation/view/products_screen.dart';
import '../../../core/constants/app_images.dart';
import '../../../l10n/app_localizations.dart';

class SecureBanner extends StatelessWidget {
  const SecureBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen()));
      },
        child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              colorScheme.secondary.withOpacity(0.7),
              colorScheme.surfaceBright.withOpacity(0.5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(
            color: colorScheme.secondary.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.secondary.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  AppImages.deviceImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.secureYourVehicle,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.secureYourVehicleDesc,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
            ),
      );
  }
}