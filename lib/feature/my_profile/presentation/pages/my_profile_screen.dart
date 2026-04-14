import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/cubit/app_cubit.dart';
import 'package:trackify/app/cubit/app_state.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/l10n/app_localizations.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My profile",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final user = state.userData;
          final userName = user?.name ?? "Kk";
          final userEmail = user?.email ?? "sonukushwah221@gmail.com";
          final userMobile = user?.mobileNumber ?? "+918602945222";
          final userCountry = user?.country ?? "India";
          final userState = user?.state ?? "Madhya Pradesh";
          final userCity = user?.city ?? "Indore district";
          final userInitials = userName.isNotEmpty ? userName[0].toUpperCase() : "K";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                /// 🔹 PROFILE HEADER
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1DA1C9),
                        ),
                        child: Center(
                          child: Text(
                            userInitials,
                            style: const TextStyle(fontSize: 36, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userName.toLowerCase().replaceAll(' ', ''),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                /// 🔹 PROFILE COMPLETENESS CARD
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile completeness",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.36,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.check_circle_outline, size: 24, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text(
                            "36%",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Last updated on 23 Feb 2026",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1DA1C9)),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 20,
                              color: Color(0xFF1DA1C9),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Add your profile picture",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1DA1C9),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Add your profile picture"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 PERSONAL DETAILS CARD
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Personal details",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF1DA1C9),
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _detailRow("Name", userName),
                      _detailRow("Email address", userEmail),
                      _detailRow("Mobile Number", userMobile),
                      _detailRow("Country", userCountry),
                      _detailRow("State", userState),
                      _detailRow("City", userCity),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 MEDICAL INSURANCE CARD
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Medical insurance information",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF1DA1C9), width: 1),
                              ),
                              child: const Icon(Icons.add, color: Color(0xFF1DA1C9), size: 30),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Add Medical insurance information",
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 VEHICLE INSURANCE CARD (Informational)
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vehicle insurance information",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Edit and view vehicle insurance details in vehicle settings.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const Text(
                        "My Garage > Vehicle",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 EMERGENCY CONTACTS CARD (Informational)
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Emergency Contacts",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add and edit emergency contact list in vehicle settings.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const Text(
                        "My Garage > Vehicle",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
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
