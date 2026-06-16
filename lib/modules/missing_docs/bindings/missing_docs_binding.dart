import 'package:get/get.dart';
import '../controller/missing_docs_controller.dart';
import '../../../data/repositories/missing_document_repository.dart';

class MissingDocsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MissingDocumentRepository>(() => MissingDocumentRepository());
    Get.lazyPut<MissingDocsController>(
        () => MissingDocsController(repo: Get.find<MissingDocumentRepository>()));
  }
}
