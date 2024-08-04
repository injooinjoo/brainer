// lib/models/goal.dart

class Goal {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String examId; // 추가: 시험 ID
  DateTime? examDate; // 추가: 시험 날짜

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.examId,
    this.examDate,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'] ?? false,
      examId: json['examId'],
      examDate:
          json['examDate'] != null ? DateTime.parse(json['examDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'examId': examId,
      'examDate': examDate?.toIso8601String(),
    };
  }
}
