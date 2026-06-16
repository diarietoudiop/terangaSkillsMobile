import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<AuthController>(
      () => AuthController(repo: Get.find<AuthRepository>()),
    );
  }
}
