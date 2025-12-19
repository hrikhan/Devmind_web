import 'dart:async';

import 'package:devmind/app_feature/firebase_service/task_database.dart';
import 'package:devmind/app_feature/task_management/model/task_model.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  TaskController({TaskDatabase? database})
      : _database = database ?? TaskDatabase();

  final tasks = <TaskItem>[].obs;
  final TaskDatabase _database;
  StreamSubscription<List<TaskItem>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = _database.watchTasks().listen((remoteTasks) {
      tasks.assignAll(remoteTasks);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> addTask(TaskItem task) async {
    await _database.createTask(task);
  }

  Future<void> updateTask(TaskItem task) async {
    await _database.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _database.deleteTask(id);
  }

  Future<void> toggleStatus(TaskItem task) async {
    await _database.updateTask(task.copyWith(isDone: !task.isDone));
  }

  double get progress {
    if (tasks.isEmpty) return 0;
    final done = tasks.where((task) => task.isDone).length;
    return done / tasks.length;
  }
}
