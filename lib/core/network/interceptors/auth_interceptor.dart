import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final _storage = GetStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.read<String>(AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 → clear token (refresh token logic can be added here)
    if (err.response?.statusCode == 401) {
      _storage.remove(AppConstants.accessTokenKey);
      _storage.remove(AppConstants.userKey);
    }
    handler.next(err);
  }
}
