import 'package:get/get.dart';

class TaskItem {
  TaskItem({
    required this.title,
    required this.category,
    required this.dueDate,
    this.isDone = false,
  });

  final String title;
  final String category;
  final DateTime dueDate;
  final bool isDone;

  TaskItem copyWith({
    String? title,
    String? category,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return TaskItem(
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TaskController extends GetxController {
  final tasks = <TaskItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSeedTasks();
  }

  void loadSeedTasks() {
    tasks.assignAll([
      TaskItem(
        title: 'Wire portfolio hero animation',
        category: 'Design',
        dueDate: DateTime.now().add(const Duration(days: 2)),
      ),
      TaskItem(
        title: 'Hook GetX task CRUD',
        category: 'Development',
        dueDate: DateTime.now().add(const Duration(days: 4)),
      ),
      TaskItem(
        title: 'Add Firebase config',
        category: 'Integration',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        isDone: true,
      ),
    ]);
  }

  void addTask(TaskItem task) {
    tasks.add(task);
  }

  void updateTask(int index, TaskItem task) {
    if (index < 0 || index >= tasks.length) return;
    tasks[index] = task;
  }

  void deleteTask(int index) {
    if (index < 0 || index >= tasks.length) return;
    tasks.removeAt(index);
  }

  void toggleStatus(int index) {
    if (index < 0 || index >= tasks.length) return;
    final task = tasks[index];
    tasks[index] = task.copyWith(isDone: !task.isDone);
  }

  double get progress {
    if (tasks.isEmpty) return 0;
    final done = tasks.where((task) => task.isDone).length;
    return done / tasks.length;
  }
}
