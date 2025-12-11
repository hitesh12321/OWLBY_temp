class RecordingModel {
  final String id; // uuid
  final String filePath;
  final String title;
  final DateTime createdAt;

  String? backendSessionId;
  final String status; // pending_processing / processing / completed /local

  String? summary;
  String? sentiment;
  String? keywords;
  int? duration;
  String? notes;

  RecordingModel({
    required this.id,
    required this.filePath,
    required this.title,
    required this.createdAt,
    required this.status,
    this.backendSessionId,
    this.summary,
    this.sentiment,
    this.keywords,
    this.duration,
    this.notes,
  });

  RecordingModel copyWith({
    String? id,
    String? title,
    String? filePath,
    DateTime? createdAt,
    String? status,
    String? backendSessionId,
    String? summary,
    String? sentiment,
    String? keywords,
    int? duration,
    String? notes,
  }) {
    return RecordingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      backendSessionId: backendSessionId ?? this.backendSessionId,
      summary: summary ?? this.summary,
      sentiment: sentiment ?? this.sentiment,
      keywords: keywords ?? this.keywords,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'file_path': filePath,
        'title': title,
        'created_at': createdAt.toIso8601String(),
        "backend_session_id": backendSessionId,
        "status": status,
        "summary": summary,
        "sentiment": sentiment,
        "keywords": keywords,
        "duration": duration,
        "notes": notes,
      };
  // this map can be json so i used it here

  factory RecordingModel.fromMap(Map<String, dynamic> map) => RecordingModel(
        id: map['id'],
        filePath: map['file_path'],
        title: map['title'],
        createdAt: DateTime.parse(map['created_at']),
        backendSessionId: map["backend_session_id"],
        status: map['status'] ?? 'local',
        summary: map["summary"],
        sentiment: map["sentiment"],
        keywords: map["keywords"],
        duration: map["duration"],
        notes: map["notes"],
      );
}
