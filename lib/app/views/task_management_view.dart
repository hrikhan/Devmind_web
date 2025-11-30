import 'package:devmind/app/controllers/auth_controller.dart';
import 'package:devmind/app/controllers/task_controller.dart';
import 'package:devmind/app/routes/app_pages.dart';
import 'package:devmind/app/theme/app_theme.dart';
import 'package:devmind/app/widgets/custom_button.dart';
import 'package:devmind/app/widgets/glass_container.dart';
import 'package:devmind/app/widgets/responsive.dart';
import 'package:devmind/app/widgets/sound_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskManagementView extends StatefulWidget {
  const TaskManagementView({super.key});

  @override
  State<TaskManagementView> createState() => _TaskManagementViewState();
}

class _TaskManagementViewState extends State<TaskManagementView> {
  final AuthController auth = Get.find<AuthController>();
  final TaskController controller = Get.find<TaskController>();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  DateTime? selectedDate;
  bool isDone = false;

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
    titleController.dispose();
    categoryController.dispose();
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }

  Widget _buildProgress(BuildContext context) {
    return Obx(
      () {
        final progress = controller.progress;
        return GlassContainer(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddTask(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(18),
      child: Responsive(
        builder: (context, size) {
          final isMobile = size == DeviceSize.mobile;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: isMobile ? double.infinity : 260,
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                  ),
                  SizedBox(
                    width: isMobile ? double.infinity : 200,
                    child: TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ),
                  SizedBox(
                    width: isMobile ? double.infinity : 180,
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                          color: AppColors.background2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Select date'
                                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Done', style: TextStyle(color: Colors.white70)),
                      Switch(
                        value: isDone,
                        onChanged: (value) => setState(() => isDone = value),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                  CustomButton(
                    label: 'Save Task',
                    icon: Icons.add,
                    onTap: _saveTask,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your tasks',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: controller.tasks.asMap().entries.map((entry) {
              final index = entry.key;
              final task = entry.value;
              return GlassContainer(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.glow],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${task.category} · ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: task.isDone,
                      onChanged: (_) {
                        SoundPlayer.playClick();
                        controller.toggleStatus(index);
                      },
                      activeColor: AppColors.primary,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white70),
                      onPressed: () {
                        SoundPlayer.playClick();
                        controller.deleteTask(index);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    SoundPlayer.playClick();
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      initialDate: selectedDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  void _saveTask() {
    if (titleController.text.trim().isEmpty || categoryController.text.trim().isEmpty) {
      Get.snackbar('Missing info', 'Add a title and category');
      return;
    }
    controller.addTask(
      TaskItem(
        title: titleController.text.trim(),
        category: categoryController.text.trim(),
        dueDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
        isDone: isDone,
      ),
    );
    titleController.clear();
    categoryController.clear();
    selectedDate = null;
    setState(() => isDone = false);
  }
}
