class RecordingModel {
  final String recordingId; // uuid
  final String filePath;
  final String title;
  final DateTime createdAt;
  final String? userId;
  String? backendSessionId;
  final String status; // pending_processing / processing / completed /local

  String? summary;
  String? sentiment;
  String? keywords;
  int? duration;
  String? notes;

  RecordingModel({
    required this.recordingId,
    required this.filePath,
    required this.title,
    required this.createdAt,
    required this.status,
    this.backendSessionId,
    this.userId,
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
    String? userId,
    String? summary,
    String? sentiment,
    String? keywords,
    int? duration,
    String? notes,
  }) {
    return RecordingModel(
      recordingId: id ?? this.recordingId,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      backendSessionId: backendSessionId ?? this.backendSessionId,
      userId: userId ?? this.userId,
      summary: summary ?? this.summary,
      sentiment: sentiment ?? this.sentiment,
      keywords: keywords ?? this.keywords,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': recordingId,
        'file_path': filePath,
        'title': title,
        'created_at': createdAt.toIso8601String(),
        "backend_session_id": backendSessionId,
        "user_id": userId,
        "status": status,
        "summary": summary,
        "sentiment": sentiment,
        "keywords": keywords,
        "duration": duration,
        "notes": notes,
      };
  // this map can be json so i used it here

  factory RecordingModel.fromMap(Map<String, dynamic> map) => RecordingModel(
        recordingId: map['id'],
        filePath: map['file_path'],
        title: map['title'],
        createdAt: DateTime.parse(map['created_at']),
        backendSessionId: map["backend_session_id"],
        userId: map["user_id"],
        status: map['status'] ?? 'local',
        summary: map["summary"],
        sentiment: map["sentiment"],
        keywords: map["keywords"],
        duration: map["duration"],
        notes: map["notes"],
      );
}
