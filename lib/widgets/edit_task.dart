import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bussiness_logic/cubit/taskmodel_cubit.dart';
import 'package:todo_app/models/task_model.dart';

class EditTaskDialog extends StatelessWidget {
  final TaskModel task;

  const EditTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: task.title,
    );

    return AlertDialog(
      title: const Text("Edit Task"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Write your task"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final updatedTask = task.copyWith(title: controller.text);
            context.read<TaskmodelCubit>().updateTask(updatedTask);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
