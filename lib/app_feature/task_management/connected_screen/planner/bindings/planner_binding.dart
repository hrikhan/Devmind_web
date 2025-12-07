import 'package:get/get.dart';
import '../controllers/planner_controller.dart';

class PlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlannerController>(
      () => PlannerController(),
    );
  }
}
