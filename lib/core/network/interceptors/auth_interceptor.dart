import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_routes.dart';
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
    // 401 → clear token and redirect to login
    if (err.response?.statusCode == 401) {
      _storage.remove(AppConstants.accessTokenKey);
      _storage.remove(AppConstants.userKey);
      Get.offAllNamed(AppRoutes.login);
    }
    handler.next(err);
  }
}
