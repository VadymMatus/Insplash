import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:insplash/core/error/exception.dart';
import 'package:insplash/feature/data/models/photo_model.dart';

var logger = Logger();

abstract class PhotosRemoteDataSource {
  Future<List<PhotoModel>> getAllPhotos(int page);

  Future<List<PhotoModel>> searchPhotos(String query, int page);
}

class PhotosRemoteDataSourceImpl implements PhotosRemoteDataSource {
  final _accessKey = "KztCZGK4F_Nq_pfVGs2GeZb8nMWv69oLjbTQCbmbXPU";
  static const startPage = 1;
  final dio = Dio();

  @override
  Future<List<PhotoModel>> getAllPhotos(int page) async {
    return _getPhotos(
        "https://api.unsplash.com/photos/?client_id=$_accessKey&page=$page",
        (data) => PhotoListResponse.fromJsonArray(data).results);
  }

  @override
  Future<List<PhotoModel>> searchPhotos(String query, int page) async {
    return _getPhotos(
        "https://api.unsplash.com/search/photos/?client_id=$_accessKey&query=$query&page=$page",
        (data) => PhotoListResponse.fromJsonArray(data['results'])
            .results);
  }

  Future<List<PhotoModel>> _getPhotos(
      String url, List<PhotoModel> Function(dynamic) transform) async {
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List<PhotoModel> list = transform(response.data);

        return list;
      } else {
        logger.log(Level.error, "Server error: ${response.statusCode}");
        throw ServerException();
      }
    } catch (error, stacktrace) {
      logger.log(Level.error, "Exception", error, stacktrace);
      throw ServerException();
    }
  }
}
