import "package:devmind/app_common/widgets/custom_card.dart";
import "package:devmind/app_common/widgets/responsive.dart";
import "package:devmind/app_feature/portfolio/controller/portfolio_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";

class PortfolioExperienceSection extends StatelessWidget {
  const PortfolioExperienceSection({super.key, required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Experience',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 16.h),
        Responsive(
          builder: (context, size) {
            final isMobile = size == DeviceSize.mobile;
            final spacing = isMobile ? 14.0 : 18.0;

            return Obx(() {
              final experiences = controller.experience;
              if (experiences.isEmpty) return const SizedBox.shrink();

              final children = experiences
                  .map(
                    (exp) => CustomCard(
                      title: exp.company,
                      subtitle: '${exp.role} · ${exp.timeline}\n${exp.detail}',
                      imageUrl: exp.logoUrl,
                      icon: Icons.work_outline,
                    ),
                  )
                  .toList();

              return Wrap(
                spacing: spacing.w,
                runSpacing: spacing.h,
                children: children
                    .map(
                      (widget) => SizedBox(
                        width: _experienceCardWidth(
                          size,
                          MediaQuery.of(context).size.width,
                        ),
                        child: widget,
                      ),
                    )
                    .toList(),
              );
            });
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
}
