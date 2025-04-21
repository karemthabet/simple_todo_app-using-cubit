import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:uuid/uuid.dart';

part 'taskmodel_state.dart';

class TaskmodelCubit extends Cubit<TaskmodelState> {
  TaskmodelCubit() : super(TaskmodelInitial());
  addTask(String title) {
    final TaskModel newtask = TaskModel(
      id: Uuid().v4(),
      title: title,
      isCompleted: false,
    );

    emit(TaskmodelUpdate([...state.tasks, newtask]));
  }

  removeTask(String currentId) {
    emit(
      TaskmodelUpdate(
        state.tasks.where((task) => task.id != currentId).toList(),
      ),
    );
  }

  updateTask(TaskModel updatedTask) {
    final newTasks =
        state.tasks.map((task) {
          if (task.id == updatedTask.id) {
            return updatedTask;
          }
          return task;
        }).toList();

    emit(TaskmodelUpdate(newTasks));
  }

  toogleTask(String currentId) {
    {
      final List<TaskModel> newTasks =
          state.tasks
              .map(
                (task) =>
                    task.id == currentId
                        ? task.copyWith(isCompleted: !task.isCompleted)
                        : task,
              )
              .toList();
      emit(TaskmodelUpdate(newTasks));
    }
  }
}
