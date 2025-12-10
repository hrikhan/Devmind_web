import 'package:devmind/app_common/theme/app_theme.dart';
import 'package:devmind/app_common/widgets/custom_button.dart';
import 'package:devmind/app_common/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.imageUrl,
    required this.onOpenGithub,
    required this.onOpenLive,
  });

  final String title;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final VoidCallback onOpenGithub;
  final VoidCallback onOpenLive;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1,
        duration: const Duration(milliseconds: 160),
        child: GlassContainer(
          padding: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 360;
              final cardPadding = EdgeInsets.all(
                (isCompact ? 14 : 18).w.clamp(10.0, 22.0),
              );
              final buttonPadding = EdgeInsets.symmetric(
                horizontal: (isCompact ? 14 : 16).w,
                vertical: (isCompact ? 10 : 12).h,
              );
              final avatarSize = (isCompact ? 42 : 48).r;
              final gap = (isCompact ? 10 : 12).h;
              final tagSpacing = 8.w;

              return Padding(
                padding: cardPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
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
                                color: AppColors.glow.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.1,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.description,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.white70),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: gap),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 20 / 16,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.02),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: widget.imageUrl.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Screenshot not available',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                )
                              : Image.network(
                                  widget.imageUrl,
                                  fit: BoxFit.cover,
                                  height: 100.w,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Text(
                                      'Image failed to load',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: gap),
                    Wrap(
                      spacing: tagSpacing,
                      runSpacing: isCompact ? 6.h : 8.h,
                      children: widget.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: gap),
                    if (isCompact)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              label: 'GitHub',
                              icon: Icons.code,
                              onTap: widget.onOpenGithub,
                              padding: buttonPadding,
                            ),
                          ),
                          SizedBox(height: gap),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              label: 'View Live',
                              icon: Icons.open_in_new,
                              onTap: widget.onOpenLive,
                              padding: buttonPadding,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          CustomButton(
                            label: 'GitHub',
                            icon: Icons.code,
                            onTap: widget.onOpenGithub,
                            padding: buttonPadding,
                          ),
                          SizedBox(width: 12.w),
                          CustomButton(
                            label: 'View Live',
                            icon: Icons.open_in_new,
                            onTap: widget.onOpenLive,
                            padding: buttonPadding,
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
