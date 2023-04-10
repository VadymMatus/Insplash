import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';
import 'package:insplash/feature/domain/usecases/get_all_photos.dart';
import 'package:insplash/feature/presentation/bloc/photos_bloc/photos_list_event.dart';

import '../../../../core/error/failure.dart';
import 'photos_list_state.dart';

class PhotosListBloc extends Bloc<PhotosEvent, PhotosState> {
  final GetAllPhotos getAllPhotos;
  final List<PhotoEntity> photosList = [];
  int page = 1;

  PhotosListBloc({required this.getAllPhotos}) : super(PhotosEmptyState()) {
    on<PhotosRefreshEvent>(_onPhotosRefreshEvent);
    on<PhotosPreloadEvent>(_onPhotosPreloadEvent);
  }

  FutureOr<void> _onPhotosRefreshEvent(
      PhotosRefreshEvent event, Emitter<PhotosState> emit) async {
    emit(PhotosLoadingState());
    page = 1;
    final failureOrPhoto = await getAllPhotos(PagePhotoParams(page: page));
    emit(failureOrPhoto.fold(
        (failure) => PhotosErrorState(message: _mapFailureToMessage(failure)),
        (photosList) => PhotosLoadedState(photos: photosList)));
  }

  FutureOr<void> _onPhotosPreloadEvent(
      PhotosPreloadEvent event, Emitter<PhotosState> emit) async {
    if (state is! PhotosLoadedState || (state as PhotosLoadedState).preload) {
      return;
    }

    var curState = state as PhotosLoadedState;
    emit(curState.copyWith(preload: true));

    page++;

    final failureOrPhoto = await getAllPhotos(PagePhotoParams(page: page));
    emit(failureOrPhoto.fold(
        (failure) => PhotosErrorState(message: _mapFailureToMessage(failure)),
        (photosList) {
          var newPhotos = (curState.photos + photosList).toSet().toList();
          return curState.copyWith(photos: newPhotos);
        }));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
