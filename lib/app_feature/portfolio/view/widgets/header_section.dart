import 'package:devmind/app_common/routes/app_pages.dart';
import 'package:devmind/app_common/widgets/custom_button.dart';
import 'package:devmind/app_common/widgets/responsive.dart';
import 'package:devmind/app_feature/auth_system/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PortfolioTopBar extends StatelessWidget {
  const PortfolioTopBar({super.key, required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: Responsive(
        builder: (context, size) {
          final isMobile = size == DeviceSize.mobile;
          final actions = [
            Obx(() {
              final loggedIn = auth.user.value != null;
              return CustomButton(
                label: loggedIn ? 'Tasks' : 'Tasks',
                icon: Icons.check_circle,
                onTap: () =>
                    Get.toNamed(loggedIn ? Routes.tasks : Routes.login),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              );
            }),
            SizedBox(width: isMobile ? 0 : 12.w, height: isMobile ? 10.h : 0),
            Obx(
              () => CustomButton(
                label: auth.user.value != null ? 'Logout' : 'Login',
                icon: auth.user.value != null ? Icons.logout : Icons.login,
                onTap: auth.user.value != null
                    ? auth.logout
                    : () => Get.toNamed(Routes.login),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ];

          if (isMobile) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'HrilinDev',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 12.w,
                      runSpacing: 10.h,
                      alignment: WrapAlignment.end,
                      children: actions,
                    ),
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              Text(
                'Devmind',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              ...actions,
            ],
          );
        },
      ),
    );
  }
}
