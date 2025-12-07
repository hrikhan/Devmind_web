import "package:get/get.dart";
import "package:url_launcher/url_launcher.dart";

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

class PortfolioController extends GetxController {
  final projects = <PortfolioProject>[].obs;
  final experience = <WorkExperience>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
    loadExperience();
  }

  void loadProjects() {
    projects.assignAll([
      PortfolioProject(
        title: 'Kizzy Kobe',
        description: 'API-powered search that helps you find your match faster.',
        tags: ['Flutter', 'Dart', 'GetX', 'AI'],
        imageUrl:
            'https://res.cloudinary.com/dtyyorbhn/image/upload/v1764604704/Screenshot_2025-12-01-21-57-00-366_com.example.sakshamrana123_snptih.jpg',
        githubUrl: 'https://github.com/yourhandle/kizzy-kobe',
        liveUrl:
            'https://res.cloudinary.com/dtyyorbhn/image/upload/v1764604704/Screenshot_2025-12-01-21-57-00-366_com.example.sakshamrana123_snptih.jpg',
      ),
      PortfolioProject(
        title: 'Medix Camp',
        description:
            'Find your nearest medical camp with Google Maps integration.',
        tags: ['Flutter', 'Google Maps', 'GetX', 'Node.js'],
        imageUrl:
            'https://res.cloudinary.com/dtyyorbhn/image/upload/v1764604707/Screenshot_2025-12-01-21-57-10-784_com.example.docmnk_flutter_ybsq1m.jpg',
        githubUrl: 'https://github.com/yourhandle/medix-camp',
        liveUrl:
            'https://res.cloudinary.com/dtyyorbhn/image/upload/v1764604707/Screenshot_2025-12-01-21-57-10-784_com.example.docmnk_flutter_ybsq1m.jpg',
      ),
      PortfolioProject(
        title: 'IoT Health Monitor',
        description:
            'Measure heartbeat with an IoT sensor and surface vitals inside the mobile app.',
        tags: ['Flutter', 'Dart', 'IoT', 'GetX'],
        imageUrl:
            'https://res.cloudinary.com/dtyyorbhn/image/upload/v1764604702/Screenshot_2025-12-01-21-56-45-980_com.example.health_monitoring_doujsc.jpg',
        githubUrl: 'https://github.com/yourhandle/iot-health-monitor',
        liveUrl:
            'https://res.cloudinary.com/dtyyorbhn/image/upload/v1764604702/Screenshot_2025-12-01-21-56-45-980_com.example.health_monitoring_doujsc.jpg',
      ),
    ]);
  }

  void loadExperience() {
    experience.assignAll([
      WorkExperience(
        company: 'Softvence Agency',
        role: 'Junior Flutter Developer',
        timeline: 'Joined Jul 16 – Present',
        logoUrl: 'https://logo.clearbit.com/softvence.com',
        detail: 'Delivered 20+ client projects end-to-end.',
      ),
      WorkExperience(
        company: 'Spondon IT',
        role: 'Flutter Developer Intern',
        timeline: 'Feb 1 – Jul 16',
        logoUrl: 'https://logo.clearbit.com/spondonit.com',
        detail: 'Developed and maintained LMS app redesign.',
      ),
    ]);
  }

  Future<void> openProjectLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Link error', 'Could not open $url');
    }
  }
}
