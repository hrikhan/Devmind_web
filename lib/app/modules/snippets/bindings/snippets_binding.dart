import 'package:get/get.dart';
import '../controllers/snippets_controller.dart';

class SnippetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnippetsController>(
      () => SnippetsController(),
    );
  }
}
