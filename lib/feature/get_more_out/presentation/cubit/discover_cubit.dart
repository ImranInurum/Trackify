import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../data/models/discover_model.dart';
import '../../domain/usecase/disover_usecase.dart';
import 'disocver_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final GetDiscoverUseCase getDiscoverUseCase;

  DiscoverCubit(this.getDiscoverUseCase) : super(DiscoverInitial());

  Future<void> fetchDiscoverFeatures() async {
    final box = Hive.box('map_cache');
    final cachedData = box.get('discover_features');

    List<DiscoverModel> cachedList = [];
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData.toString()) as List;
        cachedList = decoded
            .map((e) => DiscoverModel.fromMap(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    if (cachedList.isNotEmpty) {
      // emit(DiscoverLoaded(cachedList)); // Temporarily disabled cache to debug API
      emit(DiscoverLoading());
    } else {
      emit(DiscoverLoading());
    }

    try {
      final result = await getDiscoverUseCase();
      
      print("Discover API success. Result length: ${result.length}");
      try {
        final mapList = result.map((e) {
          if (e is DiscoverModel) {
            return e.toMap();
          } else {
            return {
              'title': e.title,
              'description': e.subtitle,
              'exploredText': e.exploredText,
              'bannerImage': e.image,
              '_id': e.id,
            };
          }
        }).toList();
        box.put('discover_features', jsonEncode(mapList));
      } catch (e) {
        print("Discover API cache error: $e");
      }

      emit(DiscoverLoaded(result));
    } catch (e) {
      print("Discover API fetch error: $e");
      if (state is! DiscoverLoaded) {
        emit(DiscoverError(e.toString()));
      }
    }
  }
}