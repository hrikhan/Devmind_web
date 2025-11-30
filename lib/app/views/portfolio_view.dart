import 'package:devmind/app/controllers/auth_controller.dart';
import 'package:devmind/app/controllers/portfolio_controller.dart';
import 'package:devmind/app/routes/app_pages.dart';
import 'package:devmind/app/theme/app_theme.dart';
import 'package:devmind/app/widgets/custom_button.dart';
import 'package:devmind/app/widgets/custom_card.dart';
import 'package:devmind/app/widgets/glass_container.dart';
import 'package:devmind/app/widgets/project_card.dart';
import 'package:devmind/app/widgets/responsive.dart';
import 'package:devmind/app/widgets/sound_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBar(context),
                          const SizedBox(height: 32),
                          _buildProfileHeader(context),
                          const SizedBox(height: 28),
                          _buildExperience(context),
                          const SizedBox(height: 28),
                          _buildProjects(context),
                          const SizedBox(height: 28),
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

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Text(
          'Devmind',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const Spacer(),
        Obx(() {
          final loggedIn = _auth.user.value != null;
          return CustomButton(
            label: loggedIn ? 'Tasks' : 'Tasks',
            icon: Icons.check_circle,
            onTap: () => Get.toNamed(loggedIn ? Routes.tasks : Routes.login),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          );
        }),
        const SizedBox(width: 12),
        Obx(
          () => CustomButton(
            label: _auth.user.value != null ? 'Logout' : 'Login',
            icon: _auth.user.value != null ? Icons.logout : Icons.login,
            onTap: _auth.user.value != null ? _auth.logout : () => Get.toNamed(Routes.login),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final photoUrl = _auth.user.value?.photoUrl;
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Responsive(
        builder: (context, size) {
          final isMobile = size == DeviceSize.mobile;
          return Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment:
                isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: isMobile ? 160 : 190,
                    height: isMobile ? 160 : 190,
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
                      width: isMobile ? 120 : 140,
                      height: isMobile ? 120 : 140,
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
                          ? const Icon(Icons.person, color: Colors.white, size: 48)
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(width: isMobile ? 0 : 28, height: isMobile ? 18 : 0),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _auth.user.value?.name ?? 'Bilal Dawood',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Flutter Developer | Software Engineer',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'I build expressive Flutter experiences with motion, system thinking, and realtime collaboration in mind.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70, height: 1.6),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
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
      ),
    );
  }

  Widget _buildExperience(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Experience',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        Responsive(
          builder: (context, size) {
            final isMobile = size == DeviceSize.mobile;
            final spacing = isMobile ? 14.0 : 18.0;
            final children = controller.experience
                .map(
                  (exp) => CustomCard(
                    title: exp.company,
                    subtitle: '${exp.role} · ${exp.timeline}',
                    icon: Icons.work_outline,
                  ),
                )
                .toList();

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: children
                  .map(
                    (widget) => SizedBox(
                      width: _experienceCardWidth(size, MediaQuery.of(context).size.width),
                      child: widget,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  double _experienceCardWidth(DeviceSize size, double maxWidth) {
    if (size == DeviceSize.desktop) return (maxWidth - 100) / 3;
    if (size == DeviceSize.tablet) return (maxWidth - 70) / 2;
    return maxWidth;
  }

  Widget _buildProjects(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projects',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        Responsive(
          builder: (context, size) {
            final isMobile = size == DeviceSize.mobile;
            final crossAxisCount = size == DeviceSize.desktop
                ? 3
                : size == DeviceSize.tablet
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: isMobile ? 0.9 : 1.1,
              ),
              itemCount: controller.projects.length,
              itemBuilder: (context, index) {
                final project = controller.projects[index];
                return ProjectCard(
                  title: project.title,
                  description: project.description,
                  tags: project.tags,
                  onOpenGithub: () => controller.openProjectLink(project.githubUrl),
                  onOpenLive: () => controller.openProjectLink(project.liveUrl),
                );
              },
            );
          },
        ),
      ],
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: social
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      SoundPlayer.playClick();
                      controller.openProjectLink(item.$2);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
        const SizedBox(height: 24),
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
