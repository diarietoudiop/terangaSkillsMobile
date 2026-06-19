import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    // Wait for 2.5 seconds to show the premium splash screen
    Future.delayed(const Duration(milliseconds: 2500), () {
      final token = _storage.read<String>(AppConstants.accessTokenKey);
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}
