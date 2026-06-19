import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repo;
  final _storage = GetStorage();

  AuthController({AuthRepository? repo}) : _repo = repo ?? AuthRepository();

  // ─── State ────────────────────────────────────────────
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final currentUser = Rxn<UserModel>();

  // ─── Form Fields (Login) ──────────────────────────────
  final loginEmailController = TextEditingController().obs;
  final loginPasswordController = TextEditingController().obs;

  // ─── Form Fields (Register) ───────────────────────────
  final registerEmailController = TextEditingController().obs;
  final registerPasswordController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredUser();
  }

  void _loadStoredUser() {
    final userData = _storage.read<String>(AppConstants.userKey);
    if (userData != null) {
      try {
        currentUser.value = UserModel.fromJson(
          jsonDecode(userData) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
  }

  bool get isLoggedIn {
    final token = _storage.read<String>(AppConstants.accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // ─── LOGIN ────────────────────────────────────────────
  Future<void> login() async {
    if (loginEmailController.value.text.trim().isEmpty ||
        loginPasswordController.value.text.isEmpty) {
      AppSnackbar.warning('Veuillez remplir tous les champs.');
      return;
    }
    try {
      isLoading.value = true;
      final result = await _repo.login(
        email: loginEmailController.value.text.trim(),
        password: loginPasswordController.value.text,
      );

      final role = result.user['role']?.toString() ?? '';
      if (role == 'ADMIN' || role == 'SUPER_ADMIN') {
        AppSnackbar.error("Vous n'avez pas accès à l'application mobile !");
        return;
      }

      _saveSession(result.accessToken, result.user);
      Get.offAllNamed(AppRoutes.home);
    } on DioException catch (e) {
      AppSnackbar.error(_extractErrorMessage(e));
    } catch (e) {
      AppSnackbar.error('Erreur inattendue: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── REGISTER ─────────────────────────────────────────
  Future<void> register() async {
    if (firstNameController.value.text.isEmpty ||
        lastNameController.value.text.isEmpty ||
        registerEmailController.value.text.isEmpty ||
        registerPasswordController.value.text.isEmpty) {
      AppSnackbar.warning('Veuillez remplir tous les champs obligatoires.');
      return;
    }
    if (registerPasswordController.value.text !=
        confirmPasswordController.value.text) {
      AppSnackbar.error('Les mots de passe ne correspondent pas.');
      return;
    }
    if (registerPasswordController.value.text.length < 6) {
      AppSnackbar.warning(
        'Le mot de passe doit contenir au moins 6 caractères.',
      );
      return;
    }
    try {
      isLoading.value = true;
      final result = await _repo.register(
        email: registerEmailController.value.text.trim(),
        password: registerPasswordController.value.text,
        firstName: firstNameController.value.text.trim(),
        lastName: lastNameController.value.text.trim(),
        phone: phoneController.value.text.isEmpty
            ? null
            : phoneController.value.text.trim(),
      );
      _saveSession(result.accessToken, result.user);
      AppSnackbar.success('Compte créé avec succès !');
      Get.offAllNamed(AppRoutes.home);
    } on DioException catch (e) {
      AppSnackbar.error(_extractErrorMessage(e));
    } catch (e) {
      AppSnackbar.error('Erreur inattendue: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── LOGOUT ───────────────────────────────────────────
  Future<void> logout() async {
    _storage.remove(AppConstants.accessTokenKey);
    _storage.remove(AppConstants.userKey);
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  void _saveSession(String token, Map<String, dynamic> userData) {
    _storage.write(AppConstants.accessTokenKey, token);
    _storage.write(AppConstants.userKey, jsonEncode(userData));
    try {
      currentUser.value = UserModel.fromJson(userData);
    } catch (_) {}
  }

  String _extractErrorMessage(DioException e) {
    if (e.error is Exception) {
      return e.error
          .toString()
          .replaceAll('AppException(', '')
          .split(':')
          .last
          .trim()
          .replaceAll(')', '');
    }
    return e.message ?? 'Une erreur est survenue.';
  }
}
