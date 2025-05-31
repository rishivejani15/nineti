import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  factory ApiClient() {
    final dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));
    return ApiClient._(dio);
  }

  String _cacheKey(String path, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return path;

    final sortedEntries = params.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final paramString = sortedEntries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    return '$path?$paramString';
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    final key = _cacheKey(path, params);
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await _dio.get(path, queryParameters: params);

      final rawJsonString = jsonEncode(response.data);
      await prefs.setString(key, rawJsonString);

      return response;
    } catch (error) {
      final cachedString = prefs.getString(key);
      if (cachedString != null) {
        final Map<String, dynamic> decoded = jsonDecode(cachedString);
        return Response(
          data: decoded,
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
        );
      }

      throw DioError(
        requestOptions: RequestOptions(path: path),
        error: 'Please connect to network to proceed',
        type: DioErrorType.unknown,
      );
    }
  }
}
