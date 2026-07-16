import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';
import 'package:trackify/feature/map/domain/repository/promo_video_repository.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_state.dart';

class PromoVideoCubit extends Cubit<PromoVideoState> {
  final PromoVideoRepository _repository;

  PromoVideoCubit(this._repository) : super(PromoVideoInitial());

  List<PromoVideoModel> _allVideos = [];
  int _displayedCount = 5;

  Future<void> fetchPromoVideos(String imei) async {
    final box = Hive.box('map_cache');
    final cachedData = box.get('promo_videos_data_$imei');

    List<PromoVideoModel> cachedList = [];
    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData.toString()) as List<dynamic>;
        cachedList = decoded
            .map((e) => PromoVideoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Cache parsing failed, ignore
      }
    }

    if (cachedList.isNotEmpty) {
      _allVideos = cachedList;
      _displayedCount = 5;
      _emitLoadedState();
    } else {
      emit(PromoVideoLoading());
    }

    final result = await _repository.getPromoVideos(imei);

    if (isClosed) return;

    result.fold(
      (exception) {
        if (cachedList.isEmpty) {
          emit(PromoVideoError(exception.message));
        }
      },
      (videos) {
        _allVideos = videos;
        _displayedCount = 5;
        try {
          box.put(
            'promo_videos_data_$imei',
            jsonEncode(videos.map((e) => e.toJson()).toList()),
          );
        } catch (_) {
          // Cache saving failed, ignore
        }
        _emitLoadedState();
      },
    );
  }

  void loadMoreVideos() {
    if (_displayedCount < _allVideos.length) {
      _displayedCount += 5;
      _emitLoadedState();
    }
  }

  void _emitLoadedState() {
    final displayed = _allVideos.take(_displayedCount).toList();
    emit(
      PromoVideoLoaded(
        videos: displayed,
        hasMore: _displayedCount < _allVideos.length,
      ),
    );
  }
}
