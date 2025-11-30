import 'package:devmind/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AuthUser {
  AuthUser({
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  final String name;
  final String email;
  final String photoUrl;
}

class AuthController extends GetxController {
  final Rx<AuthUser?> user = Rx<AuthUser?>(null);
  final isLoading = false.obs;

  // Share these with the user you want to give access to tasks.
  static const _allowedEmail = 'access@devmind.app';
  static const _allowedPassword = 'letmein123';

  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  Future<void> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (email.trim() == _allowedEmail && password == _allowedPassword) {
      user.value = AuthUser(
        name: 'Portfolio Guest',
        email: email.trim(),
        photoUrl: '',
      );
      Get.offAllNamed(Routes.tasks);
    } else {
      Get.snackbar(
        'Access denied',
        'Contact the owner to get credentials.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    user.value = null;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    Get.offAllNamed(Routes.portfolio);
  }

  void checkLogin() {
    if (user.value != null) {
      Get.offAllNamed(Routes.tasks);
    }
  }
}
