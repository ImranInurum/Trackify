import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:trackify/feature/my_profile/presentation/cubit/my_profile_state.dart';
import 'package:trackify/feature/my_profile/data/models/update_profile_request.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/feature/auth/data/entity/login_response_model.dart';

import 'edit_profile_screen.dart';
import 'package:trackify/feature/settings/presentation/pages/delete_account_screen.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/document_folder/presentation/pages/document_screen.dart';
import 'package:trackify/feature/Vehicle_control/presentation/pages/vehicle_control_screen.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:trackify/feature/profile/presentation/cubit/profile_state.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/common/models/vehicle_list_model.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isUploading = false;

  String _getProfileImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    path = path.replaceAll('\\', '/');
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final base = ApiURL.baseURL;
    if (path.startsWith('/')) {
      return '$base$path';
    }
    return '$base/$path';
  }

  Future<void> _pickAndUploadImage(User? user) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      final fileName = pickedFile.name;

      final userName = user?.name ?? "";
      final userEmail = user?.email ?? "";
      final userMobile = user?.mobileNumber ?? "";
      final userCountry = user?.country ?? "";
      final userState = user?.state ?? "";
      final userCity = user?.city ?? "";

      final request = UpdateProfileRequest(
        name: user?.name ?? userName,
        middleName: user?.middleName,
        lastName: user?.lastName,
        mobileNumber: user?.mobileNumber ?? userMobile,
        email: user?.email ?? userEmail,
        dateOfBirth: user?.dateOfBirth,
        country: user?.country ?? userCountry,
        state: user?.state ?? userState,
        city: user?.city ?? userCity,
        address: user?.address,
      );

      if (mounted) {
        context.read<MyProfileCubit>().updateProfile(
          userId: user?.id ?? '',
          request: request,
          profileImageBytes: fileBytes,
          profileImageName: fileName,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.myProfile, ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      body: BlocListener<MyProfileCubit, MyProfileState>(
        listener: (context, state) {
          if (state is MyProfileLoading) {
            setState(() => _isUploading = true);
          } else if (state is MyProfileSuccess) {
            setState(() => _isUploading = false);
            context.read<AppCubit>().updateUserSession(state.user);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message.isNotEmpty
                      ? state.message
                      : 'Profile picture updated successfully',
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is MyProfileError) {
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            final user = state.userData;
            int completeness = 0;
            if (user != null) {
              if (user.userProfile != null && user.userProfile!.trim().isNotEmpty) {
                completeness += 20;
              }
              if (user.name != null && user.name!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.email != null && user.email!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.mobileNumber != null && user.mobileNumber!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.dateOfBirth != null && user.dateOfBirth!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.country != null && user.country!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.state != null && user.state!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.city != null && user.city!.trim().isNotEmpty) {
                completeness += 10;
              }
              if (user.address != null && user.address!.trim().isNotEmpty) {
                completeness += 10;
              }
            }
            completeness = completeness.clamp(0, 100);

            final progressColor = completeness == 100
                ? Colors.green
                : (completeness >= 50 ? Colors.orange : Theme.of(context).colorScheme.error);

            final userName = user?.name ?? "";
            final userEmail = user?.email ?? "";
            final userMobile = user?.mobileNumber ?? "";
            final userCountry = user?.country ?? "";
            final userState = user?.state ?? "";
            final userCity = user?.city ?? "";
            final userInitials = userName.isNotEmpty
                ? userName[0].toUpperCase()
                : "";
            final profileImageUrl = _getProfileImageUrl(user?.userProfile);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  /// 🔹 PROFILE HEADER
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipOval(
                                      child: profileImageUrl.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: profileImageUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(child: TrackifyLoader()),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Center(
                                                    child: Text(
                                                      userInitials,
                                                      style: TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                      ),
                                                    ),
                                                  ),
                                            )
                                          : Center(
                                              child: Text(
                                                userInitials,
                                                style: TextStyle(
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  if (_isUploading)
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: const Center(child: TrackifyLoader()),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploading
                                    ? null
                                    : () => _pickAndUploadImage(user),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).colorScheme.primary,
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userName.toLowerCase().replaceAll(' ', ''),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 🔹 PROFILE COMPLETENESS CARD
                  _buildCard(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.profileCompleteness,
                          style: TextStyle(color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: completeness / 100.0,
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: progressColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              completeness == 100
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              size: 24,
                              color: completeness == 100
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.onSurface.withOpacity( 0.3),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$completeness%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (completeness < 100) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                child: Icon(
                                  (user?.userProfile == null || user!.userProfile!.trim().isEmpty)
                                      ? Icons.person_outline
                                      : Icons.edit_note_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (user?.userProfile == null || user!.userProfile!.trim().isEmpty)
                                          ? l10n.addProfilePicture
                                          : l10n.completePersonalDetails,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: (user?.userProfile == null || user!.userProfile!.trim().isEmpty)
                                            ? (_isUploading ? null : () => _pickAndUploadImage(user))
                                            : () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const EditProfileScreen(),
                                                  ),
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                        ),
                                        child: _isUploading && (user?.userProfile == null || user!.userProfile!.trim().isEmpty)
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                (user?.userProfile == null || user!.userProfile!.trim().isEmpty)
                                                    ? l10n.addProfilePicture
                                                    : l10n.personalDetails,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 20,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.profile100PercentComplete,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 PERSONAL DETAILS CARD
                  _buildCard(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.personalDetails,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(),
                                  ),
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _detailRow(l10n.userNameLabel, userName, context),
                        _detailRow(l10n.emailAddressLabel, userEmail, context),
                        _detailRow(l10n.mobileNumberLabel, userMobile, context),
                        _detailRow(l10n.countryLabel, userCountry, context),
                        _detailRow(l10n.stateLabel, userState, context),
                        _detailRow(l10n.cityLabel, userCity, context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),



                  /// 🔹 VEHICLE INSURANCE CARD
                  _buildCard(
                    context: context,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DocumentFolderScreen(),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.vehicleInsuranceInfo,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.editViewVehicleInsuranceDesc,
                          style: TextStyle(color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          l10n.myGarageVehiclePath,
                          style: TextStyle(color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 EMERGENCY CONTACTS CARD
                  _buildCard(
                    context: context,
                    onTap: () {
                      final profileState = context.read<ProfileCubit>().state;
                      Vehicle? selectedVehicle;
                      if (profileState is VehiclesLoaded && profileState.vehicles.isNotEmpty) {
                        final selectedImei = AppPreference.instance.getSync(
                          key: AppPreference.IMEI,
                        );
                        final selectedUid = AppPreference.instance.getSync(
                          key: AppPreference.KEY_SELECTED_UID,
                        );
                        selectedVehicle = profileState.vehicles.firstWhere(
                          (v) =>
                              (selectedUid.isNotEmpty && v.id == selectedUid) ||
                              (selectedImei.isNotEmpty && v.imei == selectedImei),
                          orElse: () => profileState.vehicles.first,
                        );
                      }
                      final bool isDeviceInstalled = selectedVehicle?.imei != null && selectedVehicle!.imei!.isNotEmpty;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleControlScreen(
                            isFromGarage: isDeviceInstalled ? false : true,
                            passedVehicle: selectedVehicle,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.emergencyContacts,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.4),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.addEditEmergencyContactDesc,
                          style: TextStyle(color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          l10n.myGarageVehiclePath,
                          style: TextStyle(color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity( 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // =========================================================================
                  // [NEW CODE - Delete Account option in Profile Screen (Guideline 5.1.1)]
                  // =========================================================================
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeleteAccountScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_remove_outlined, color: Colors.redAccent, size: 18),
                      label: Text(
                        l10n.deleteAccountTitle,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required Widget child,
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity( 0.5),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity( 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _detailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity( 0.5),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
