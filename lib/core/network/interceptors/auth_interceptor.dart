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
    final statusCode = err.response?.statusCode;
    final dataString = err.response?.data?.toString().toLowerCase() ?? '';
    
    // Clear token and redirect if unauthorized (401), forbidden (403), or token is missing/invalid
    if (statusCode == 401 || 
        statusCode == 403 || 
        dataString.contains('token is missing') || 
        dataString.contains('token is invalid') ||
        dataString.contains('token is missing or invalid') ||
        dataString.contains('authentication token')) {
      
      _storage.remove(AppConstants.accessTokenKey);
      _storage.remove(AppConstants.userKey);
      
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }
    }
    handler.next(err);
  }
}
