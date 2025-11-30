import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioProject {
  PortfolioProject({
    required this.title,
    required this.description,
    required this.tags,
    required this.githubUrl,
    required this.liveUrl,
  });

  final String title;
  final String description;
  final List<String> tags;
  final String githubUrl;
  final String liveUrl;
}

class WorkExperience {
  WorkExperience({
    required this.company,
    required this.role,
    required this.timeline,
  });

  final String company;
  final String role;
  final String timeline;
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
        title: 'TaskFlow',
        description:
            'A smooth, purple-inspired task dashboard with realtime syncing and focus timers.',
        tags: ['Flutter', 'Firebase', 'GetX'],
        githubUrl: 'https://github.com/example/taskflow',
        liveUrl: 'https://taskflow.dev',
      ),
      PortfolioProject(
        title: 'Pulse UI Kit',
        description:
            'Component library with glassmorphism and motion presets built for cross-platform apps.',
        tags: ['Design', 'Flutter', 'Motion'],
        githubUrl: 'https://github.com/example/pulse-ui',
        liveUrl: 'https://pulse.dev',
      ),
      PortfolioProject(
        title: 'Insight Boards',
        description:
            'Analytics dashboards featuring responsive grids, hover motion, and micro-interactions.',
        tags: ['Charts', 'Responsive', 'Web'],
        githubUrl: 'https://github.com/example/insight-boards',
        liveUrl: 'https://insight.dev',
      ),
    ]);
  }

  void loadExperience() {
    experience.assignAll([
      WorkExperience(
        company: 'Neon Labs',
        role: 'Senior Flutter Engineer',
        timeline: '2022 — Present',
      ),
      WorkExperience(
        company: 'Cloud Arc',
        role: 'Mobile Engineer',
        timeline: '2020 — 2022',
      ),
      WorkExperience(
        company: 'PixelPoint',
        role: 'Software Engineer',
        timeline: '2018 — 2020',
      ),
      WorkExperience(
        company: 'Freelance',
        role: 'Flutter Developer',
        timeline: '2016 — 2018',
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
