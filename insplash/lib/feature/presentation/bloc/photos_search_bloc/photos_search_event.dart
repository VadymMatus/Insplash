part of 'photos_search_bloc.dart';

abstract class PhotosSearchEvent {}

class SearchPhotosInitialEvent extends PhotosSearchEvent {}

class SearchPhotosPreloadEvent extends PhotosSearchEvent {}

class SearchPhotosEvent extends PhotosSearchEvent {
  final String query;

  SearchPhotosEvent({required this.query});
}

class SearchPhotosRefreshEvent extends SearchPhotosEvent {
  SearchPhotosRefreshEvent({required super.query});
}

class PreloadSearchPhotosEvent extends PhotosSearchEvent {}
