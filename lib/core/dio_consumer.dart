import 'package:dio/dio.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api_interceptor.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/end_points.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/errors/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseurl;
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));
  }

  @override
  Future delete(String? path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await dio.delete(path!,
          data: isFormData ? FormData.fromMap(data) : data,
          queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handlingMethodExceptions(e);
    }
  }

  @override
  Future get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await dio.get(path, data: data, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handlingMethodExceptions(e);
    }
  }

  @override
  Future patch(String? path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool? isFormData = false}) async {
    try {
      final response = await dio.patch(
        path!,
        data: isFormData! ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handlingMethodExceptions(e);
    }
  }

  @override
  Future post(String? path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final response = await dio.post(path!,
          data: isFormData ? FormData.fromMap(data) : data,
          queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handlingMethodExceptions(e);
    }
  }
}
