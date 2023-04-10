import 'package:dartz/dartz.dart';
import 'package:insplash/core/error/exception.dart';
import 'package:insplash/core/error/failure.dart';
import 'package:insplash/core/platform/network_info.dart';
import 'package:insplash/feature/data/models/photo_model.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';
import 'package:insplash/feature/domain/repositories/photos_repository.dart';

import 'package:insplash/feature/data/datasources/photos_remote_data_source.dart';

class PhotosRepositoryImpl implements PhotosRepository {
  final PhotosRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PhotosRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PhotoEntity>>> getAllPhotos(int page) async {
    return await _getPhotos(() {
      return remoteDataSource.getAllPhotos(page);
    });
  }

  @override
  Future<Either<Failure, List<PhotoEntity>>> searchPhotos(String query, int page) async {
    return await _getPhotos(() {
      return remoteDataSource.searchPhotos(query, page);
    });
  }

  Future<Either<Failure, List<PhotoModel>>> _getPhotos(
      Future<List<PhotoModel>> Function() getPhotos) async {
    try {
      final remotePhoto = await getPhotos();
      return Right(remotePhoto);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
