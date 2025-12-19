import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmind/app_feature/task_management/model/task_model.dart';

class TaskDatabase {
  TaskDatabase({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('tasks');

  Stream<List<TaskItem>> watchTasks() {
    return _tasks
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(TaskItem.fromSnapshot).toList();
    });
  }

  Future<void> createTask(TaskItem item) async {
    final doc = _tasks.doc();
    final record = item.copyWith(
      id: doc.id,
      createdAt: DateTime.now(),
    );
    await doc.set(record.toMap());
  }

  Future<void> updateTask(TaskItem item) async {
    if (item.id.isEmpty) return;
    await _tasks.doc(item.id).update(item.toMap());
  }

  Future<void> deleteTask(String id) async {
    if (id.isEmpty) return;
    await _tasks.doc(id).delete();
  }
}
