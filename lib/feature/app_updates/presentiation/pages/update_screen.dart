import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/config/font_manager.dart';
import '../cubit/update_cubit.dart';
import '../cubit/update_cubit_state.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    context.read<UpdateCubit>().fetchUpdates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;


    return Scaffold(
      backgroundColor: colorScheme.onPrimaryContainer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "App Updates",
          style: TextStyle(
            fontSize: width * .05,
            fontWeight: FontWeightManager.semibold,
            color:Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocBuilder<UpdateCubit, UpdateState>(
          builder: (context, state) {
            ///  Loading
            if (state is UpdateLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary
                ),
              );
            }
            ///  Loaded
            if (state is UpdateLoaded) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.updates.length,
                itemBuilder: (context, index) {
                  final item = state.updates[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///  HEADER
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * .04,
                          vertical: height * .015,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              colorScheme.onPrimaryContainer.withOpacity(0.7),
                              colorScheme.onSurface.withOpacity(0.3),
                            ]
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.date,
                              style: TextStyle(
                                fontSize: width * .046,
                                fontWeight: FontWeightManager.semibold,
                                color:Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.9)
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Version : ${item.version}",
                              style: TextStyle(
                                fontSize: width * .032,
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///  CONTENT
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * .04,
                          vertical: height * .015,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (() {
                            final count = item.titles.length < item.descriptions.length
                                ? item.titles.length
                                : item.descriptions.length;
                            return List.generate(
                              count,
                                  (i) => Padding(
                                padding: EdgeInsets.only(bottom: height * .02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //  Title
                                    Text(
                                      item.titles[i].toString(),
                                      style: TextStyle(
                                        fontSize: width * .04,
                                        fontWeight: FontWeightManager.semibold,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant
                                      ),
                                    ),
                                    SizedBox(height: height * .006),
                                    ///  Description
                                    Text(
                                      item.descriptions[i].toString(),
                                      style: TextStyle(
                                        fontSize: width * .038,
                                        height: 1.5,
                                        color:Theme.of(context). colorScheme.onSurfaceVariant
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          )(),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            ///  Error
            if (state is UpdateError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color:Theme.of(context). colorScheme.error
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}