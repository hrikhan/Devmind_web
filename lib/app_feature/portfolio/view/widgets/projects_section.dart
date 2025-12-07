import 'package:devmind/app_common/widgets/project_card.dart';
import 'package:devmind/app_common/widgets/responsive.dart';
import 'package:devmind/app_feature/portfolio/controller/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PortfolioProjectsSection extends StatelessWidget {
  const PortfolioProjectsSection({super.key, required this.controller});

  final PortfolioController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projects',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 16.h),
        Responsive(
          builder: (context, size) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final spacing = 18.w;
                final runSpacing = 18.h;
                final maxWidth = constraints.maxWidth;
                final itemWidth = switch (size) {
                  DeviceSize.desktop =>
                      (maxWidth - (spacing * 2)).clamp(0, double.infinity) / 3,
                  DeviceSize.tablet =>
                      (maxWidth - spacing).clamp(0, double.infinity) / 2,
                  DeviceSize.mobile => maxWidth,
                };

                return Wrap(
                  spacing: spacing,
                  runSpacing: runSpacing,
                  children: controller.projects
                      .map(
                        (project) => SizedBox(
                          width: itemWidth,
                          child: ProjectCard(
                            title: project.title,
                            description: project.description,
                            tags: project.tags,
                            imageUrl: project.imageUrl,
                            onOpenGithub: () =>
                                controller.openProjectLink(project.githubUrl),
                            onOpenLive: () => controller.openProjectLink(
                              project.liveUrl,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
