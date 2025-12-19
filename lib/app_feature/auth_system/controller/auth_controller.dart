import 'dart:async';

import 'package:devmind/app_common/routes/app_pages.dart';
import 'package:devmind/app_feature/firebase_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthUser {
  AuthUser({required this.name, required this.email, required this.photoUrl});

  final String name;
  final String email;
  final String photoUrl;
}

class AuthController extends GetxController {
  final Rx<AuthUser?> user = Rx<AuthUser?>(null);
  final isLoading = false.obs;
  final FirebaseAuthService _authService = FirebaseAuthService();
  StreamSubscription<User?>? _authSub;

  @override
  void onInit() {
    super.onInit();
    _authSub = _authService.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        user.value = null;
      } else {
        user.value = AuthUser(
          name: firebaseUser.displayName ?? 'Portfolio Guest',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL ?? '',
        );
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    checkLogin();
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  Future<void> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final firebaseUser = await _authService.signIn(email.trim(), password);
      user.value = AuthUser(
        name: firebaseUser.displayName ?? 'Portfolio Guest',
        email: firebaseUser.email ?? email.trim(),
        photoUrl: firebaseUser.photoURL ?? '',
      );
      Get.offAllNamed(Routes.tasks);
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthError(e);
      Get.snackbar(
        'Login failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Login failed',
        'Unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    user.value = null;
    Get.offAllNamed(Routes.portfolio);
  }

  void checkLogin() {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      user.value = AuthUser(
        name: firebaseUser.displayName ?? 'Portfolio Guest',
        email: firebaseUser.email ?? '',
        photoUrl: firebaseUser.photoURL ?? '',
      );
      Get.offAllNamed(Routes.tasks);
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication error. Please try again.';
    }
  }
}
