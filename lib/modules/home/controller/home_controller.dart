import 'package:get/get.dart';
import '../../../modules/auth/controller/auth_controller.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  AuthController get authController => Get.find<AuthController>();
}
