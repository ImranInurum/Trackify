import 'package:flutter/material.dart';
import 'package:trackify/core/config/font_manager.dart';
import 'package:trackify/feature/video_tutorial/presentation/pages/tutorial_screen.dart';
import 'package:trackify/l10n/app_localizations_ar.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/datasource/category_datasource.dart';
import '../../data/model/category_model.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {

    try {

      final data =
      await CategoryRemoteData()
          .fetchCategories();

      setState(() {
        categories = data;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.tutorialVideos, ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
      child:  Column(
        children: [
          isLoading
              ? const Center(child: TrackifyLoader())
              : ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {

              final category =
              categories[index];

              return _card(
                context,
                category.name,
                category.id,
              );
            },
          )

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
            MaterialPageRoute(builder: (context)=>TutorialScreen(title: title, categoryId: type,)
            )
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
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
