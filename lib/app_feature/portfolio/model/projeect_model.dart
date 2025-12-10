class PortfolioProject {
  PortfolioProject({
    required this.title,
    required this.description,
    required this.tags,
    required this.imageUrl,
    required this.githubUrl,
    required this.liveUrl,
  });

  final String title;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final String githubUrl;
  final String liveUrl;
}

class WorkExperience {
  WorkExperience({
    required this.company,
    required this.role,
    required this.timeline,
    required this.logoUrl,
    required this.detail,
  });

  final String company;
  final String role;
  final String timeline;
  final String logoUrl;
  final String detail;
}
