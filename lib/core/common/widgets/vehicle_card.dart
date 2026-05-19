import 'package:flutter/material.dart';
import 'package:trackify/feature/device_installation/presentation/pages/device_installation_screen.dart';

import '../../../core/constants/app_images.dart';
import '../../../l10n/app_localizations.dart';
import '../models/vehicle_list_model.dart';
import 'interactive_swipe_button.dart';
import 'secure_banner.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final bool hasDevice;
  final bool isLocked;
  final VoidCallback onLock;
  final VoidCallback onRecharge;
  final VoidCallback onRenew;
  final VoidCallback onVehicleControl;
  final BuildContext context;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.hasDevice,
    this.isLocked = false,
    required this.onLock,
    required this.onRecharge,
    required this.onRenew,
    required this.onVehicleControl,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            child: InkWell(
              onTap: onVehicleControl,
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
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              vehicle.vehicleNumber?.toUpperCase() ?? 'N/A',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (hasDevice)
                              Text(
                                l10n.lite4G,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user_rounded,
                                    color: Colors.orange,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.buyTrackifyDevice,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
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
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (hasDevice) ...[
            InteractiveSwipeButton(
              onSwipe: onLock,
              isLocked: isLocked,
            ),
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
            _buildInstallLink(l10n,(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DeviceInstallationScreen( vehicleId:  vehicle.id,)),
              );
            }),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
            ],
          ),
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: const Size(0, 34),
              ),
              child: Text(
                btnText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallLink(AppLocalizations l10n, Function onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.boughtDeviceInstallNow,
          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
        InkWell(
          onTap: () => onTap(),
          child: Text(
            l10n.installNow,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
