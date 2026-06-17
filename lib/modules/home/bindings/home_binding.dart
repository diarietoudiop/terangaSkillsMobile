import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../../modules/auth/controller/auth_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
