import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insplash/feature/data/datasources/photos_remote_data_source.dart';

import '../../../domain/entities/photo_entity.dart';
import '../../../domain/usecases/search_photos.dart';

part 'photos_search_event.dart';
part 'photos_search_state.dart';

class PhotosSearchBloc extends Bloc<PhotosSearchEvent, PhotosSearchState> {
  final SearchPhotos searchPhotos;

  PhotosSearchBloc({required this.searchPhotos})
      : super(PhotosSearchInitialState()) {
    on<SearchPhotosRefreshEvent>(_onSearchPhotosEvent);
    on<SearchPhotosEvent>(_onSearchPhotosEvent);
    on<SearchPhotosInitialEvent>(
        (event, emit) => emit(PhotosSearchInitialState()));
    on<SearchPhotosPreloadEvent>(_onSearchPhotosPreloadEvent);
  }

  FutureOr<void> _onSearchPhotosPreloadEvent(
      SearchPhotosPreloadEvent event, Emitter<PhotosSearchState> emit) async {
    if (state is! PhotosSearchLoadedState ||
        (state as PhotosSearchLoadedState).preload) {
      return;
    }

    var curState = state as PhotosSearchLoadedState;
    emit(curState.copyWith(preload: true));

    final failureOrPhoto = await searchPhotos(
        SearchPhotosParams(query: curState.query, page: curState.page + 1));
    emit(failureOrPhoto.fold(
        (failure) => PhotosSearchErrorState(message: "Server Failure"),
        (photosList) => curState.copyWith(
            photos: curState.photos + photosList, page: curState.page + 1)));
  }

  FutureOr<void> _onSearchPhotosEvent(
      SearchPhotosEvent event, Emitter<PhotosSearchState> emit) async {
    if (event.query.isEmpty) emit(PhotosSearchInitialState());

    emit(PhotosSearchLoadingState());

    final failureOrPerson = await searchPhotos(SearchPhotosParams(
        query: event.query, page: PhotosRemoteDataSourceImpl.startPage));
    var result = failureOrPerson.fold(
        (failure) => PhotosSearchErrorState(message: 'Server Failure'),
        (photos) =>
            PhotosSearchLoadedState(photos: photos, query: event.query));

    if (result is PhotosSearchLoadedState && result.photos.isEmpty) {
      emit(PhotosSearchEmptyState());
    } else {
      emit(result);
    }
  }
}
