class RecordingModel {
  final int? id;
  final String filePath;
  final String title;
  final DateTime createdAt;

  RecordingModel({
    this.id,
    required this.filePath,
    required this.title,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'file_path': filePath,
        'title': title,
        'created_at': createdAt.toIso8601String(),
      };

  factory RecordingModel.fromMap(Map<String, dynamic> map) => RecordingModel(
        id: map['id'],
        filePath: map['file_path'],
        title: map['title'],
        createdAt: DateTime.parse(map['created_at']),
      );
}
