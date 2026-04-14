import 'package:flutter/material.dart';

import '../../../core/constants/app_images.dart';
import '../../../l10n/app_localizations.dart';
import '../models/vehicle_list_model.dart';
import 'interactive_swipe_button.dart';
import 'secure_banner.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final bool hasDevice;
  final VoidCallback onLock;
  final VoidCallback onRecharge;
  final VoidCallback onRenew;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.hasDevice,
    required this.onLock,
    required this.onRecharge,
    required this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      // margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 0.5,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(AppImages.bikeImage, fit: BoxFit.contain),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${vehicle.vehicleMaker} ${vehicle.vehicleModel}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            vehicle.vehicleNumber?.toUpperCase() ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (hasDevice)
                            Text(
                              l10n.lite4G,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1CA5D4),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  color: Color(0xFFD48A1C),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.buyAjjasDevice,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFD48A1C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (hasDevice) ...[
            InteractiveSwipeButton(onSwipe: onLock),
            const SizedBox(height: 20),
            _buildActionRow(
              l10n,
              l10n.dataPlan,
              l10n.expiresInDays("319"),
              l10n.rechargeNow,
              onRecharge,
            ),
            _buildActionRow(
              l10n,
              l10n.warranty,
              l10n.expiresInDays("319"),
              l10n.renewNow,
              onRenew,
            ),
          ] else ...[
            const SecureBanner(),
            const SizedBox(height: 16),
            _buildInstallLink(l10n),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    AppLocalizations l10n,
    String title,
    String subtitle,
    String btnText,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            ],
          ),
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF333333)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: const Size(0, 34),
              ),
              child: Text(
                btnText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.boughtDeviceInstallNow,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          l10n.installNow,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1CA5D4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
