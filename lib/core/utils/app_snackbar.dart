import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Succès',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFFFFFFFF)),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void error(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Erreur',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.error_rounded, color: Color(0xFFFFFFFF)),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void warning(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Attention',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning,
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.warning_rounded, color: Color(0xFFFFFFFF)),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  static void info(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Information',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: const Color(0xFFFFFFFF),
      icon: const Icon(Icons.info_rounded, color: Color(0xFFFFFFFF)),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
