// lib/models/exam.dart

class Exam {
  final String id;
  final String name;
  final String description;

  Exam({required this.id, required this.name, required this.description});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
