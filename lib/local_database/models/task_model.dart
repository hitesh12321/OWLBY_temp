class TaskModel {
  int? id;
  String title;
  bool isDone;

  TaskModel({
    this.id,
    required this.title,
    this.isDone = false,
  });

  // Convert Task to Map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
    };
  }

  // Convert Map from DB → TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] == 1,
    );
  }
}
