import "package:devmind/app_feature/portfolio/model/projeect_model.dart";
import "package:get/get.dart";
import "package:url_launcher/url_launcher.dart";

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
        description:
            'API-powered search that helps you find your match faster.',
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
        timeline: 'Joined Jul 16 � Present',
        logoUrl:
            "https://cdn.prod.website-files.com/63bcf9ab8eb5266da6a0db19/65cdd8d9c5769e2142d26808_65cdc4be0f0cf35e995108b0_Frame%252B8sdfsd.png",
        detail: 'Delivered 20+ client projects end-to-end.',
      ),
      WorkExperience(
        company: 'Spondon IT',
        role: 'Flutter Developer Intern',
        timeline: 'Feb 1 � Jul 16',
        logoUrl:
            'https://media.licdn.com/dms/image/v2/C4D1BAQFDgKhGZlyNZg/company-background_10000/company-background_10000/0/1625026566674/spondonit_cover?e=2147483647&v=beta&t=b8iTmxEP5PG0XIJb9kX9SdVuaGNaU6sGvyEa_aJ2USk',
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
