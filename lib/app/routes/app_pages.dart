import 'package:devmind/app/views/login_view.dart';
import 'package:devmind/app/views/portfolio_view.dart';
import 'package:devmind/app/views/task_management_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.portfolio;

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.portfolio,
      page: () => const PortfolioView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.tasks,
      page: () => const TaskManagementView(),
      transition: Transition.fadeIn,
    ),
  ];
}
