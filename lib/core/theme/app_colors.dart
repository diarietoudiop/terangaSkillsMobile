import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  AppColors._();

  // Primary - Orange
  static const Color primary = Color(0xFFF97316);
  static const Color primaryLight = Color(0xFFFB923C);
  static const Color primaryDark = Color(0xFFEA6C10);
  static const Color primaryContainer = Color(0xFFFFF7ED);

  // Secondary - Amber
  static const Color secondary = Color(0xFFF59E0B);
  static const Color secondaryLight = Color(0xFFFBBF24);

  // Success
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);

  // Warning
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  // Error
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // Info
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Neutrals / Greys
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Dark Theme Backgrounds (Dynamic getters to adapt to ThemeMode instantly)
  static Color get darkBackground =>
      Get.isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  static Color get darkSurface =>
      Get.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  static Color get darkCard =>
      Get.isDarkMode ? const Color(0xFF243044) : const Color(0xFFFFFFFF);
  static Color get darkBorder =>
      Get.isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // Dynamic Text colors
  static Color get text =>
      Get.isDarkMode ? Colors.white : const Color(0xFF111827);

  // Light Theme Backgrounds
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Status Colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInReview = Color(0xFF3B82F6);
  static const Color statusApproved = Color(0xFF10B981);
  static const Color statusRejected = Color(0xFFEF4444);
  static const Color statusCompleted = Color(0xFF059669);
  static const Color statusOpen = Color(0xFFF97316);
  static const Color statusResolved = Color(0xFF10B981);
  static const Color statusClosed = Color(0xFF6B7280);
  static const Color statusMissing = Color(0xFFEF4444);
  static const Color statusFound = Color(0xFF10B981);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF243044)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
