import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.login({'email': email, 'password': password});
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    final response = await _apiClient.register({
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': ?phone,
    });
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> getProfile() async {
    final response = await _apiClient.getMe();
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
