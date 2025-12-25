import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../../../../app/cubit/app_state.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  bool _followUser = true;
  String? _lightMapStyle;
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  Future<void> _loadMapStyles() async {
    _lightMapStyle = await rootBundle.loadString('assets/map_styles/light_map.json');
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark_map.json');
  }

  Future<void> _applyMapTheme(GoogleMapController controller, ThemeMode themeMode) async {
    if (themeMode == ThemeMode.dark) {
      await controller.setMapStyle(_darkMapStyle);
    } else if (themeMode == ThemeMode.light) {
      await controller.setMapStyle(_lightMapStyle);
    } else {
      // Follow system theme
      final brightness = MediaQuery.of(context).platformBrightness;
      await controller.setMapStyle(
        brightness == Brightness.dark ? _darkMapStyle : _lightMapStyle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text("Record via Phone"),centerTitle: false,          bottom: const TabBar(
          tabs: [
            Tab(text: "Ride Records"),
            Tab(text: "Past Rides"),
            Tab(text: "Statistics"),
          ],
        ),),
        body: TabBarView(children: [
          _body(),
          Center(child: Text("Placeholder for History")),
          Center(child: Text("Placeholder for Settings")),
        ]),
      ),
    );
  }

  Widget _body() {
    return Stack(children:[
      _mapWidget(),
      _detailsSheet()
    ]);
  }

  Widget _mapWidget() {
    return BlocConsumer<AppCubit, AppState>(
      listenWhen: (prev, curr) =>
      prev.currentLocation != curr.currentLocation && curr.currentLocation != null,

      listener: (BuildContext context, AppState state) async {
        if (!_followUser) return;

        final pos = state.currentLocation!;
        final controller = await _controller.future;

        controller.animateCamera(CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));
      },
      buildWhen: (previous, current) => previous.currentLocation != current.currentLocation,
      builder: (context, state) {
        final currentPos = state.currentLocation;

        if (currentPos == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final cameraPosition = CameraPosition(
          target: LatLng(currentPos.latitude, currentPos.longitude),
          zoom: 16,
        );

        return GoogleMap(
          initialCameraPosition: cameraPosition,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            await _applyMapTheme(controller, state.themeMode);
          },
        );
      },
    );
  }

  Widget _detailsSheet(){
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.2,
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              SliverList.list(children: const [
                ListTile(title: Text('Jane Doe')),
                ListTile(title: Text('Jack Reacher')),
              ])
            ],
          ),
        );
      },
    );
  }
}
