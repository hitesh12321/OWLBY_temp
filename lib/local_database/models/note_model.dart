class NoteModel {
  int? id;
  String title;
  String content;
  String createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // Convert Note -> Map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "createdAt": createdAt,
    };
  }

  // Convert Map -> Note
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      createdAt: map["createdAt"],
    );
  }
}
