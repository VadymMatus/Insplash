part of 'photos_search_bloc.dart';

abstract class PhotosSearchState {}

class PhotosSearchInitialState extends PhotosSearchState {}

class PhotosSearchEmptyState extends PhotosSearchState {}

class PhotosSearchLoadingState extends PhotosSearchState {}

class PhotosSearchErrorState extends PhotosSearchState {
  final String message;

  PhotosSearchErrorState({required this.message});
}

class PhotosSearchLoadedState extends PhotosSearchState {
  final List<PhotoEntity> photos;
  final int page;
  final bool preload;
  final String query;

  PhotosSearchLoadedState(
      {required this.photos,
      required this.query,
      this.page = PhotosRemoteDataSourceImpl.startPage,
      this.preload = false});

  PhotosSearchLoadedState copyWith(
      {List<PhotoEntity>? photos,
      String? query,
      int? page,
      bool preload = false}) {
    return PhotosSearchLoadedState(
        photos: photos ?? this.photos,
        query: query ?? this.query,
        page: page ?? this.page,
        preload: preload);
  }
}
