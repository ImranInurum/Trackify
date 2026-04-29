import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/map/data/entity/promo_video_model.dart';
import 'package:trackify/feature/map/domain/repository/promo_video_repository.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_state.dart';

class PromoVideoCubit extends Cubit<PromoVideoState> {
  final PromoVideoRepository _repository;

  PromoVideoCubit(this._repository) : super(PromoVideoInitial());

  List<PromoVideoModel> _allVideos = [];
  int _displayedCount = 5;

  Future<void> fetchPromoVideos() async {
    emit(PromoVideoLoading());
    final result = await _repository.getPromoVideos();
    
    result.fold(
      (exception) => emit(PromoVideoError(exception.message)),
      (videos) {
        _allVideos = videos;
        _displayedCount = 5;
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
    emit(PromoVideoLoaded(
      videos: displayed, 
      hasMore: _displayedCount < _allVideos.length,
    ));
  }
}
