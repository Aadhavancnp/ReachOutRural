import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  static const String _baseUrl =
      'https://ror-django-backend-7pxm.onrender.com/api/';

  DioClient(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    // _dio.options.connectTimeout = const Duration(seconds: 5);
    // _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> get(String path) async => await _dio.get(path);
  Future<Response> post(String path, {dynamic data}) async =>
      await _dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) async =>
      await _dio.put(path, data: data);
  Future<Response> patch(String path, {dynamic data}) async =>
      await _dio.patch(path, data: data);
  Future<Response> delete(String path) async => await _dio.delete(path);
}
