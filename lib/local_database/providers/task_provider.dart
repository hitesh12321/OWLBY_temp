import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../db/task_database.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await OwlbyDatabase.instance.getTasks();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    await OwlbyDatabase.instance.addTask(TaskModel(title: title));
    await loadTasks();
  }

  Future<void> toggleTask(TaskModel task) async {
    task.isDone = !task.isDone;
    await OwlbyDatabase.instance.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await OwlbyDatabase.instance.deleteTask(id);
    await loadTasks();
  }

  Future<void> updateTaskTitle(int id, String newTitle) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle;

    await OwlbyDatabase.instance.updateTask(task);
    await loadTasks();
  }
}
