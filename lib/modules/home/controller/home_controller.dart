import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../modules/auth/controller/auth_controller.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  AuthController get authController => Get.find<AuthController>();
}
