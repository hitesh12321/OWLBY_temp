class SessionModel {
  String id;
  String filePath;
  String title;
  DateTime createdAt;

  String? backendId;
  String status; // pending_processing / processing / completed

  String? summary;
  String? sentiment;
  String? keywords;
  String? duration;
  String? notes;

  SessionModel({
    required this.id,
    required this.filePath,
    required this.title,
    required this.createdAt,
    required this.status,
    this.backendId,
    this.summary,
    this.sentiment,
    this.keywords,
    this.duration,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "file_path": filePath,
    "title": title,
    "created_at": createdAt,
    "backend_id": backendId,
    "status": status,
    "summary": summary,
    "sentiment": sentiment,
    "keywords": keywords,
    "duration": duration,
    "notes": notes,
  };

  factory SessionModel.fromMap(Map<String, dynamic> map) => SessionModel(
    id: map["id"],
    filePath: map["file_path"],
    title: map["title"],
    createdAt: map["created_at"],
    backendId: map["backend_id"],
    status: map["status"],
    summary: map["summary"],
    sentiment: map["sentiment"],
    keywords: map["keywords"],
    duration: map["duration"],
    notes: map["notes"],
  );
}
