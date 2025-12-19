import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  TaskItem({
    required this.id,
    required this.projectName,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    this.docLink,
    this.isDone = false,
  });

  final String id;
  final String projectName;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String? docLink;
  final bool isDone;

  factory TaskItem.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return TaskItem(
      id: snapshot.id,
      projectName: data['projectName'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      docLink: data['docLink'] as String?,
      isDone: data['isDone'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'description': description,
      'imageUrl': imageUrl,
      'docLink': docLink,
      'createdAt': Timestamp.fromDate(createdAt),
      'isDone': isDone,
    };
  }

  TaskItem copyWith({
    String? id,
    String? projectName,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    String? docLink,
    bool? isDone,
  }) {
    return TaskItem(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      docLink: docLink ?? this.docLink,
      isDone: isDone ?? this.isDone,
    );
  }
}
