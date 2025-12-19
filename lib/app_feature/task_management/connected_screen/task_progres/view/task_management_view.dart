import 'package:devmind/app_feature/auth_system/controller/auth_controller.dart';
import 'package:devmind/app_feature/firebase_service/cloudnary_setup.dart';
import 'package:devmind/app_feature/task_management/connected_screen/task_progres/controller/task_controller.dart';
import 'package:devmind/app_feature/task_management/model/task_model.dart';
import 'package:devmind/app_common/routes/app_pages.dart';
import 'package:devmind/app_common/theme/app_theme.dart';
import 'package:devmind/app_common/widgets/custom_button.dart';
import 'package:devmind/app_common/widgets/glass_container.dart';
import 'package:devmind/app_common/widgets/responsive.dart';
import 'package:devmind/app_common/widgets/sound_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskManagementView extends StatefulWidget {
  const TaskManagementView({super.key});

  @override
  State<TaskManagementView> createState() => _TaskManagementViewState();
}

class _TaskManagementViewState extends State<TaskManagementView> {
  final AuthController auth = Get.find<AuthController>();
  final TaskController controller = Get.find<TaskController>();
  final projectController = TextEditingController();
  final docLinkController = TextEditingController();
  final descriptionController = TextEditingController();
  final CloudinaryService _cloudinary = CloudinaryService();
  bool isDone = false;
  bool _isUploadingImage = false;
  bool _isSavingTask = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.user.value == null) {
        Get.offAllNamed(Routes.login);
      }
    });
  }

  @override
  void dispose() {
    projectController.dispose();
    docLinkController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientDark),
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 20),
                  _buildProgress(context),
                  const SizedBox(height: 20),
                  _buildAddTask(context),
                  const SizedBox(height: 20),
                  _buildTaskList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        CustomButton(
          label: 'Back to Portfolio',
          icon: Icons.arrow_back,
          onTap: () => Get.offAllNamed(Routes.portfolio),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        const Spacer(),
        Text(
          'Task Board',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildProgress(BuildContext context) {
    return Obx(() {
      final progress = controller.progress;
      return GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      height: 14,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.glow],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.glow.withOpacity(0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% completed',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddTask(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 900;
      return GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Project Update',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildImageUploader(height: 320),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 6,
                    child: _buildTaskFormFields(),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageUploader(height: 240),
                  const SizedBox(height: 20),
                  _buildTaskFormFields(),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTaskFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: projectController,
          decoration: const InputDecoration(
            labelText: 'Project name',
            prefixIcon: Icon(Icons.work_outline),
          ),
        ),
        const SizedBox(height: 16),
        _buildDocLinkRow(),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          minLines: 5,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Description / notes',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'Mark as done',
              style: TextStyle(color: Colors.white70),
            ),
            Switch(
              value: isDone,
              onChanged: (value) => setState(() => isDone = value),
              activeColor: AppColors.primary,
            ),
            const Spacer(),
            CustomButton(
              label: _isSavingTask ? 'Saving...' : 'Save to Firebase',
              icon: Icons.cloud_upload_outlined,
              onTap: _isSavingTask ? null : _saveTask,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploader({double height = 220}) {
    return GestureDetector(
      onTap: _isUploadingImage ? null : _pickAndUploadImage,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          color: AppColors.background2,
        ),
        child: _isUploadingImage
            ? const Center(child: CircularProgressIndicator())
            : _imageUrl == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload_outlined,
                          size: 48, color: Colors.white70),
                      SizedBox(height: 8),
                      Text(
                        'Upload project image',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'PNG / JPG up to 5MB',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: CustomButton(
                          label: 'Change image',
                          icon: Icons.edit,
                          onTap: _pickAndUploadImage,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildDocLinkRow() {
    return Responsive(builder: (context, size) {
      final isMobile = size == DeviceSize.mobile;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: docLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Google Doc link',
                    prefixIcon: Icon(Icons.link_outlined),
                  ),
                ),
              ),
              if (!isMobile) const SizedBox(width: 12),
              if (!isMobile)
                CustomButton(
                  label: 'Open Google Doc',
                  icon: Icons.description_outlined,
                  onTap: _openGoogleDoc,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
            ],
          ),
          if (isMobile) const SizedBox(height: 12),
          if (isMobile)
            CustomButton(
              label: 'Open Google Doc',
              icon: Icons.description_outlined,
              onTap: _openGoogleDoc,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
        ],
      );
    });
  }

  Widget _buildTaskList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your tasks',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final tasks = controller.tasks;
          if (tasks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No tasks yet. Add your first project update above.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
            );
          }
          return Column(
            children:
                tasks.map((task) => _buildTaskCard(context, task)).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskItem task) {
    final theme = Theme.of(context);
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 96,
              height: 96,
              child: Image.network(
                task.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.background2,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.projectName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  task.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _formatDate(task.createdAt),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    if (task.docLink?.isNotEmpty == true) ...[
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: () => _openExistingDoc(task.docLink!),
                        icon: const Icon(Icons.link, size: 16),
                        label: const Text('Google Doc'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.glow,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: task.isDone,
                onChanged: (_) {
                  SoundPlayer.playClick();
                  controller.toggleStatus(task);
                },
                activeColor: AppColors.primary,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white70,
                ),
                onPressed: () {
                  SoundPlayer.playClick();
                  controller.deleteTask(task.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    SoundPlayer.playClick();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null) return;
      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        Get.snackbar('Upload failed', 'Unable to read the selected file.');
        return;
      }
      setState(() => _isUploadingImage = true);
      final response = await _cloudinary.uploadBytes(
        bytes: bytes,
        fileName: file.name,
      );
      setState(() {
        _imageUrl = response.secureUrl;
      });
      Get.snackbar('Image uploaded', 'Ready to save this project.');
    } catch (e) {
      // ignore: avoid_print
      print('Cloudinary upload failed: $e');
      Get.snackbar('Upload failed', 'Please try again.');
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _saveTask() async {
    final projectName = projectController.text.trim();
    final description = descriptionController.text.trim();
    final docLink = docLinkController.text.trim();

    if (_imageUrl == null) {
      Get.snackbar('Missing image', 'Upload a project preview first.');
      return;
    }
    if (projectName.isEmpty) {
      Get.snackbar('Missing title', 'Add a project name.');
      return;
    }
    if (description.isEmpty) {
      Get.snackbar('Missing description', 'Describe the project progress.');
      return;
    }

    SoundPlayer.playClick();
    setState(() => _isSavingTask = true);
    try {
      await controller.addTask(
        TaskItem(
          id: '',
          projectName: projectName,
          description: description,
          imageUrl: _imageUrl!,
          docLink: docLink.isEmpty ? null : docLink,
          createdAt: DateTime.now(),
          isDone: isDone,
        ),
      );
      Get.snackbar('Saved', 'Task stored in Firebase.');
      _resetForm();
    } catch (e) {
      // ignore: avoid_print
      print('Task save failed: $e');
      Get.snackbar('Save failed', 'Could not store the task. Try again.');
    } finally {
      setState(() => _isSavingTask = false);
    }
  }

  void _resetForm() {
    projectController.clear();
    docLinkController.clear();
    descriptionController.clear();
    setState(() {
      _imageUrl = null;
      isDone = false;
    });
  }

  Future<void> _openGoogleDoc() async {
    const url = 'https://docs.google.com/document/u/0/';
    await _launchExternal(Uri.parse(url));
  }

  Future<void> _openExistingDoc(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      Get.snackbar('Invalid link', 'This Google Doc link is not valid.');
      return;
    }
    await _launchExternal(uri);
  }

  Future<void> _launchExternal(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Link error', 'Could not open ${uri.toString()}');
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM, yyyy').format(date);
  }
}
