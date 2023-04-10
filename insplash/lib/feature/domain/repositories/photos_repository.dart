import 'package:dartz/dartz.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';

import 'package:insplash/core/error/failure.dart';

abstract class PhotosRepository {
  Future<Either<Failure, List<PhotoEntity>>> getAllPhotos(int page);

  Future<Either<Failure, List<PhotoEntity>>> searchPhotos(String query, int page);
}
