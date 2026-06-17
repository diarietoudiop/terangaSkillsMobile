import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final isConnected = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _checkInitialConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (_) {}
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    // connectivity_plus v6/v7 returns a list. If it has only 'none', then there's no connection.
    final hasNet = !result.contains(ConnectivityResult.none);
    
    if (hasNet != isConnected.value) {
      isConnected.value = hasNet;
      if (!hasNet) {
        _showNoInternetSnackbar();
      } else {
        _showBackOnlineSnackbar();
      }
    }
  }

  void _showNoInternetSnackbar() {
    Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      titleText: const Text(
        'Connexion perdue',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      messageText: const Text(
        'Veuillez vérifier votre connexion internet.',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      backgroundColor: AppColors.error,
      icon: const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 28),
      duration: const Duration(days: 365), // Persist until resolved
      isDismissible: false,
      dismissDirection: DismissDirection.none,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  void _showBackOnlineSnackbar() {
    Get.closeCurrentSnackbar();
    Get.rawSnackbar(
      titleText: const Text(
        'Connexion rétablie',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      messageText: const Text(
        'Vous êtes à nouveau en ligne.',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      backgroundColor: AppColors.success,
      icon: const Icon(Icons.wifi_rounded, color: Colors.white, size: 28),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
