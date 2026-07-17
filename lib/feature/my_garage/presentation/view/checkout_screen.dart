import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isHomeSelected = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget customField(
    BuildContext context,
    String hint, {
    Widget? suffix,
  }) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    late final l10n = AppLocalizations.of(context)!;



    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.012),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 15,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.016,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    late final l10n = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.checkout, ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          /// TAB BAR
          Container(
            height: size.height * 0.065,
            margin: EdgeInsets.only(bottom: size.height * 0.02),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              labelPadding: EdgeInsets.zero,
              tabs: [
                /// ADDRESS TAB
                Container(
                  color: colorScheme.primary,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.04,
                          backgroundColor: colorScheme.onPrimary,
                          child: Icon(
                            Icons.check,
                            color: colorScheme.primary,
                            size: size.width * 0.05,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Text(
                          l10n.address,
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// SUMMARY TAB
                Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Text(
                      l10n.summary,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pleaseEnterDetails,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: size.height * 0.018),

                  customField(context, l10n.fullName),
                  customField(context, l10n.mobileNumber),
                  customField(context, l10n.houseFloorLine),
                  customField(context, l10n.landmark),

                  customField(
                    context,
                    l10n.state,
                    suffix: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.primary,
                      size: 34,
                    ),
                  ),

                  customField(context, l10n.pinCode),

                  SizedBox(height: size.height * 0.01),

                  /// ADDRESS TYPE
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isHomeSelected = true;
                            });
                          },
                          child: Container(
                            height: size.height * 0.055,
                            decoration: BoxDecoration(
                              color: isHomeSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                l10n.homeAddress,
                                style: TextStyle(
                                  color: isHomeSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.045),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isHomeSelected = false;
                            });
                          },
                          child: Container(
                            height: size.height * 0.055,
                            decoration: BoxDecoration(
                              color: !isHomeSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                l10n.officeAddress,
                                style: TextStyle(
                                  color: !isHomeSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.025),

                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.055,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child:  Text(
                        l10n.proceed,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
