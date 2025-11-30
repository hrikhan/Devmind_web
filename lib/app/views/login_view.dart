import 'package:devmind/app/controllers/auth_controller.dart';
import 'package:devmind/app/routes/app_pages.dart';
import 'package:devmind/app/theme/app_theme.dart';
import 'package:devmind/app/widgets/custom_button.dart';
import 'package:devmind/app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController controller = Get.find<AuthController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientDark),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -60,
              child: _glowCircle(220, 0.25),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: _glowCircle(260, 0.2),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: 'profile-avatar',
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.glow],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.glow.withOpacity(0.6),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.lock_outline, color: Colors.white, size: 46),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Access Tasks',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tasks are private. Enter the credentials shared by the owner to continue.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => CustomButton(
                            label: controller.isLoading.value ? 'Checking...' : 'Login to Tasks',
                            icon: Icons.login,
                            onTap: controller.isLoading.value
                                ? null
                                : () => controller.loginWithCredentials(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () => Get.offAllNamed(Routes.portfolio),
                          child: const Text(
                            'Back to portfolio',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: const [
                            Text(
                              'Need access? Contact the owner:',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'contact@devmind.app',
                              style: TextStyle(
                                color: AppColors.glow,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: AppColors.glow.withOpacity(opacity),
            blurRadius: size * 0.5,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}
