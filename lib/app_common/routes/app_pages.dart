import 'package:devmind/app_feature/auth_system/view/screen/login_view.dart';
import 'package:devmind/app_feature/portfolio/view/screen/portfolio_view.dart';
import 'package:devmind/app_feature/task_management/connected_screen/task_progres/view/task_management_view.dart';
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
      page: () => PortfolioView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.tasks,
      page: () => const TaskManagementView(),
      transition: Transition.fadeIn,
    ),
  ];
}
