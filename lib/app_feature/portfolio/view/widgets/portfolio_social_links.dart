import 'package:devmind/app_common/theme/app_theme.dart';
import 'package:devmind/app_common/widgets/sound_player.dart';
import 'package:devmind/app_feature/portfolio/controller/portfolio_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PortfolioSocialLinks extends GetView<PortfolioController> {
  const PortfolioSocialLinks({super.key});

  static const _socialLinks = [
    (Icons.code, 'https://github.com'),
    (Icons.work, 'https://www.linkedin.com'),
    (Icons.chat, 'https://t.me'),
    (Icons.email, 'mailto:hello@devmind.app'),
    (Icons.facebook, 'https://facebook.com'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isCompact = width < 600;
    final double buttonSize = isCompact ? 40.0 : 46.w;
    final double spacing = isCompact ? 8.0 : 12.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: spacing),
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _socialLinks
              .map(
                (item) => _SocialButton(
                  icon: item.$1,
                  url: item.$2,
                  controller: controller,
                  size: buttonSize,
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
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.url,
    required this.controller,
    required this.size,
  });

  final IconData icon;
  final String url;
  final PortfolioController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SoundPlayer.playClick();
        controller.openProjectLink(url);
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: size,
        height: size,
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
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
