import 'package:flutter/material.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/video_tutorial/presentation/pages/tutorial_screen.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        centerTitle: false,
        elevation: 0,
        title: Text(
          l10n.tutorialVideos,
          style: TextStyle(
            fontWeight: FontWeightManager.medium,
            color: colorScheme.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
      child:  Column(
        children: [
          _card(context, l10n.location, "location"),
          _card(context, l10n.amazingFeatures, "features"),
          _card(context, l10n.deviceInstallation, "installation"),
          _card(context, l10n.voiceMonitoring, "voice"),

        ],
      ),

      ),
    );
  }

  Widget _card(BuildContext context, String title, String type ){
    final screenWidth = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>TutorialScreen(type:type, title: title,)
            )
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurfaceVariant.withOpacity(0.2)),
          color: Theme.of(context).cardColor,

        ),
        child: Row(
          children: [
            Text(
              title ,style: TextStyle(color: colorScheme.onSurfaceVariant,fontWeight: FontWeightManager.medium)
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,color: colorScheme.primary,)
          ],
        ),



      ),
    );
  }
}
