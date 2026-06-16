import 'package:dio/dio.dart';
import '../../errors/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        message = 'Délai de connexion dépassé. Vérifiez votre réseau.';
        break;
      case DioExceptionType.connectionError:
        message = 'Impossible de se connecter au serveur.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        message = _parseServerMessage(data) ?? _statusToMessage(statusCode);
        break;
      default:
        message = 'Une erreur inattendue s\'est produite.';
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: AppException(message: message, statusCode: err.response?.statusCode),
      ),
    );
  }

  String? _parseServerMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString();
    }
    return null;
  }

  String _statusToMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requête invalide.';
      case 401:
        return 'Non autorisé. Veuillez vous reconnecter.';
      case 403:
        return 'Accès refusé.';
      case 404:
        return 'Ressource introuvable.';
      case 409:
        return 'Conflit - cette ressource existe déjà.';
      case 422:
        return 'Données invalides.';
      case 500:
        return 'Erreur interne du serveur.';
      default:
        return 'Erreur ($statusCode).';
    }
  }
}
