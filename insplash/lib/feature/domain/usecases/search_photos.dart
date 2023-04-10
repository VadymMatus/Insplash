import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:insplash/core/error/failure.dart';
import 'package:insplash/core/usecases/usecase.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';
import 'package:insplash/feature/domain/repositories/photos_repository.dart';

class SearchPhotos extends UseCase<List<PhotoEntity>, SearchPhotosParams> {
  final PhotosRepository photoRepository;

  SearchPhotos(this.photoRepository);

  @override
  Future<Either<Failure, List<PhotoEntity>>> call(
      SearchPhotosParams params) async {
    return await photoRepository.searchPhotos(params.query, params.page);
  }
}

class SearchPhotosParams extends Equatable {
  final String query;
  final int page;

  const SearchPhotosParams({required this.query, required this.page});

  @override
  List<Object?> get props => [query, page];
}
