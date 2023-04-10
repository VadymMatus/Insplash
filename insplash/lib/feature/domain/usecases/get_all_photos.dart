import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:insplash/core/error/failure.dart';
import 'package:insplash/core/usecases/usecase.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';
import 'package:insplash/feature/domain/repositories/photos_repository.dart';

class GetAllPhotos extends UseCase<List<PhotoEntity>, PagePhotoParams> {
  final PhotosRepository photoRepository;

  GetAllPhotos(this.photoRepository);

  @override
  Future<Either<Failure, List<PhotoEntity>>> call(PagePhotoParams params) async {
    return await photoRepository.getAllPhotos(params.page);
  }
}

class PagePhotoParams extends Equatable {
  final int page;

  const PagePhotoParams({required this.page});

  @override
  List<Object?> get props => [page];
}
