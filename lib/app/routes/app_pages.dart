import 'package:devmind/app/modules/home/bindings/home_binding.dart';
import 'package:devmind/app/modules/home/views/home_view.dart';
import 'package:devmind/app/modules/snippets/bindings/snippets_binding.dart';
import 'package:devmind/app/modules/snippets/views/snippets_view.dart';
import 'package:devmind/app/modules/planner/bindings/planner_binding.dart';
import 'package:devmind/app/modules/planner/views/planner_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.snippets,
      page: () => const SnippetsView(),
      binding: SnippetsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.planner,
      page: () => const PlannerView(),
      binding: PlannerBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
