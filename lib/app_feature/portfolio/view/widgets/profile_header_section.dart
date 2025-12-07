import 'package:devmind/app_common/routes/app_pages.dart';
import 'package:devmind/app_common/theme/app_theme.dart';
import 'package:devmind/app_common/widgets/custom_button.dart';
import 'package:devmind/app_common/widgets/glass_container.dart';
import 'package:devmind/app_common/widgets/responsive.dart';
import 'package:devmind/app_feature/auth_system/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PortfolioProfileHeader extends StatelessWidget {
  const PortfolioProfileHeader({super.key, required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final photoUrl =
        "https://res.cloudinary.com/dtyyorbhn/image/upload/v1764580952/WhatsApp_Image_2025-12-01_at_15.18.36_784462c1_gawl27.jpg";
    return GlassContainer(
      padding: EdgeInsets.all(24.w),
      child: Responsive(
        builder: (context, size) {
          final isMobile = size == DeviceSize.mobile;
          final isTablet = size == DeviceSize.tablet;
          return LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final baseAvatar = isMobile
                  ? maxW * 0.72
                  : isTablet
                  ? 230.w
                  : 300.w;
              final avatarSize = baseAvatar.clamp(170.w, 340.w);
              final glowSize = (avatarSize * 1.24).clamp(200.w, 400.w);
              final titleAlign = isMobile ? TextAlign.center : TextAlign.start;

              return Flex(
                mainAxisSize: MainAxisSize.min,
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: avatarSize,
                    height: avatarSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: glowSize,
                          height: glowSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [AppColors.primary, Colors.transparent],
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'profile-avatar',
                          child: Container(
                            width: avatarSize,
                            height: avatarSize,
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
                                  spreadRadius: 6,
                                ),
                              ],
                              image: photoUrl == null || photoUrl.isEmpty
                                  ? null
                                  : DecorationImage(
                                      image: NetworkImage(photoUrl),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: photoUrl == null || photoUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 48,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: isMobile ? 0 : 28.w,
                    height: isMobile ? 18.h : 0,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hridoy Khan",
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                          textAlign: titleAlign,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'hrilindev',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppColors.primary.withOpacity(0.9),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                          textAlign: titleAlign,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Flutter Developer | Software Engineer',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white70),
                          textAlign: titleAlign,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'I build expressive Flutter experiences with motion, system thinking, and realtime collaboration in mind. Obsessed with clean architecture, GetX state, and making mobile-first UIs feel premium on every screen size.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70, height: 1.6),
                          textAlign: titleAlign,
                        ),
                        SizedBox(height: 8.h),

                        SizedBox(height: 18.h),
                        Wrap(
                          alignment: isMobile
                              ? WrapAlignment.center
                              : WrapAlignment.start,
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: [
                            CustomButton(
                              label: 'Download CV',
                              icon: Icons.cloud_download,
                              onTap: () {
                                Get.snackbar(
                                  'Coming soon',
                                  'Attach your CV link after uploading it.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                            ),
                            CustomButton(
                              label: 'View Tasks',
                              icon: Icons.task_alt,
                              onTap: () => Get.toNamed(Routes.tasks),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
