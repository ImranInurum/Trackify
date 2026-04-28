import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/feature/map/domain/repository/promo_video_repository.dart';
import 'package:trackify/feature/map/presentation/cubit/promo_video_state.dart';

class PromoVideoCubit extends Cubit<PromoVideoState> {
  final PromoVideoRepository _repository;

  PromoVideoCubit(this._repository) : super(PromoVideoInitial());

  Future<void> fetchPromoVideos() async {
    emit(PromoVideoLoading());
    final result = await _repository.getPromoVideos();
    
    result.fold(
      (exception) => emit(PromoVideoError(exception.message)),
      (videos) => emit(PromoVideoLoaded(videos)),
    );
  }
}
