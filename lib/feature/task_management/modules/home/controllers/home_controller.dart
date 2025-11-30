import 'package:get/get.dart';
import '../../snippets/views/snippets_view.dart';
import '../../planner/views/planner_view.dart';
import '../views/home_view.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final pages = [
    const HomeView(),
    const SnippetsView(),
    const PlannerView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
