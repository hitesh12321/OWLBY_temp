import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/models/task_model.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    void _showEditDialog(BuildContext context, TaskProvider provider) {
      final controller = TextEditingController(text: task.title);

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Edit Task"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter new task title",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    provider.updateTaskTitle(task.id!, controller.text.trim());
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    }

    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Checkbox(
          activeColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          value: task.isDone,
          onChanged: (_) => provider.toggleTask(task),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context, provider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => provider.deleteTask(task.id!),
            ),
          ],
        ),
      ),
    );
  }
}
