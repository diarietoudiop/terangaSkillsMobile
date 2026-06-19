import 'package:get/get.dart';
import '../controller/qr_controller.dart';
import '../../../data/repositories/document_repository.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentRepository>(() => DocumentRepository());
    Get.lazyPut<QrController>(
      () => QrController(repo: Get.find<DocumentRepository>()),
    );
  }
}
