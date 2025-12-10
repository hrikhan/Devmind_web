import 'package:devmind/app_feature/auth_system/controller/auth_controller.dart';
import 'package:devmind/app_common/theme/app_theme.dart';
import 'package:devmind/app_feature/portfolio/controller/portfolio_controller.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/aurora_background.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/background_animation.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/experience_section.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/portfolio_social_links.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/header_section.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/profile_header_section.dart';
import 'package:devmind/app_feature/portfolio/view/widgets/projects_section.dart';

class PortfolioView extends GetView<PortfolioController> {
  PortfolioView({super.key});

  AuthController get _auth => Get.find<AuthController>();
  final List<String> flutterSkills = [
    "https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp", // Flutter
    "https://strapi.dhiwise.com/uploads/618fa90c201104b94458e1fb_65016ca5f278a961b5c69997_OG_Image_dab434168e.jpg", // Dart
    "https://cdn-icons-png.flaticon.com/512/919/919825.png", // Firebase
    "https://bloclibrary.dev/_astro/bloc.DJLDGT9c_A0IIg.svg", // GetX
    "https://cdn-icons-png.flaticon.com/512/919/919828.png", // REST API
    "https://img.icons8.com/color/1200/firebase.jpg", // GraphQL
    "https://cdn-icons-png.flaticon.com/512/5968/5968242.png", // Provider
    "https://cdn-icons-png.flaticon.com/512/5968/5968282.png", // Bloc
    "https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png", // JSON
    "https://cdn-icons-png.flaticon.com/512/919/919833.png", // Git
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(gradient: AppColors.gradientDark),
        color: Colors.black,
        child: Stack(
          children: [
            //  Background Animations
            AuroraBackground(intensity: 0.3),
            //Skill Bubbles
            Positioned.fill(
              child: Align(
                alignment: const Alignment(1, 0.1), // push cloud slightly lower
                child: SkillCloud(skillUrls: flutterSkills),
              ),
            ),
            // Background Glows
            Positioned(top: -140, right: -80, child: _glow(320, 0.1)),
            Positioned(bottom: -140, left: -60, child: _glow(300, 0.1)),
            SafeArea(
              child: ScrollConfiguration(
                behavior: _SmoothScrollBehavior(),

                //main  Portfolio content
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
                          const PortfolioSocialLinks(),
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
