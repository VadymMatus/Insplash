import 'package:insplash/feature/domain/entities/photo_entity.dart';

abstract class PhotosState {}

class PhotosEmptyState extends PhotosState {}

class PhotosLoadingState extends PhotosState {}

class PhotosLoadedState extends PhotosState {
  final List<PhotoEntity> photos;
  final bool preload;

  PhotosLoadedState({required this.photos, this.preload = false});

  PhotosLoadedState copyWith(
      {List<PhotoEntity>? photos, bool preload = false}) {
    return PhotosLoadedState(photos: photos ?? this.photos, preload: preload);
  }
}

class PhotosErrorState extends PhotosState {
  final String message;

  PhotosErrorState({required this.message});
}
