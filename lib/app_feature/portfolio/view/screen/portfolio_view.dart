import 'package:devmind/app_feature/auth_system/controller/auth_controller.dart';
import 'package:devmind/app_feature/portfolio/controller/portfolio_controller.dart';
import 'package:devmind/app_common/theme/app_theme.dart';
import 'package:devmind/app_common/widgets/sound_player.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/experience_section.dart'
    show PortfolioExperienceSection;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/header_section.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/profile_header_section.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/projects_section.dart';

class PortfolioView extends GetView<PortfolioController> {
  const PortfolioView({super.key});

  AuthController get _auth => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientDark),
        child: Stack(
          children: [
            Positioned(top: -120, right: -80, child: _glow(320, 0.22)),
            Positioned(bottom: -140, left: -60, child: _glow(300, 0.2)),
            SafeArea(
              child: ScrollConfiguration(
                behavior: _SmoothScrollBehavior(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PortfolioTopBar(auth: _auth),
                          SizedBox(height: 32.h),
                          PortfolioProfileHeader(auth: _auth),
                          SizedBox(height: 28.h),
                          PortfolioExperienceSection(controller: controller),
                          SizedBox(height: 28.h),
                          PortfolioProjectsSection(controller: controller),
                          SizedBox(height: 28.h),
                          _buildSocial(context),
                        ],
                      ),
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

  Widget _buildSocial(BuildContext context) {
    final social = [
      (Icons.code, 'https://github.com'),
      (Icons.work, 'https://www.linkedin.com'),
      (Icons.chat, 'https://t.me'),
      (Icons.email, 'mailto:hello@devmind.app'),
      (Icons.facebook, 'https://facebook.com'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 12.h),
        Row(
          children: social
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: InkWell(
                    onTap: () {
                      SoundPlayer.playClick();
                      controller.openProjectLink(item.$2);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.glow.withOpacity(0.16),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(item.$1, color: Colors.white),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 24.h),
        RichText(
          text: TextSpan(
            text: 'Looking for collaboration? ',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Ping me',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    SoundPlayer.playClick();
                    controller.openProjectLink('mailto:hello@devmind.app');
                  },
                style: const TextStyle(
                  color: AppColors.glow,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _glow(double size, double opacity) {
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

class _SmoothScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.trackpad,
  };
}
