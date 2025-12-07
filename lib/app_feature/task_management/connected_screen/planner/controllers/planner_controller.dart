import 'package:get/get.dart';

class PlannerController extends GetxController {
  final plans = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  void loadPlans() {
    // TODO: Load plans from Hive
    isLoading.value = true;
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  void addPlan(String title, String description, DateTime? dueDate) {
    plans.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'completed': false,
      'createdAt': DateTime.now(),
    });
    // TODO: Save to Hive
  }

  void deletePlan(String id) {
    plans.removeWhere((plan) => plan['id'] == id);
    // TODO: Delete from Hive
  }

  void togglePlanStatus(String id) {
    final index = plans.indexWhere((plan) => plan['id'] == id);
    if (index != -1) {
      plans[index]['completed'] = !plans[index]['completed'];
      plans.refresh();
      // TODO: Update in Hive
    }
  }

  void updatePlan(String id, String title, String description, DateTime? dueDate) {
    final index = plans.indexWhere((plan) => plan['id'] == id);
    if (index != -1) {
      plans[index] = {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'completed': plans[index]['completed'],
        'createdAt': plans[index]['createdAt'],
        'updatedAt': DateTime.now(),
      };
      // TODO: Update in Hive
    }
  }
}
