import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:uuid/uuid.dart';

part 'taskmodel_state.dart';

class TaskmodelCubit extends HydratedCubit<TaskmodelState> {
  TaskmodelCubit() : super(TaskmodelInitial());

  void addTask(String title) {
    final TaskModel newTask = TaskModel(
      id: const Uuid().v4(),
      title: title,
      isCompleted: false,
    );
    emit(TaskmodelUpdate([...state.tasks, newTask]));
  }

  void removeTask(String currentId) {
    emit(TaskmodelUpdate(
      state.tasks.where((task) => task.id != currentId).toList(),
    ));
  }

  void updateTask(TaskModel updatedTask) {
    final newTasks = state.tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    emit(TaskmodelUpdate(newTasks));
  }

  void toggleTask(String currentId) {
    final newTasks = state.tasks.map((task) {
      return task.id == currentId
          ? task.copyWith(isCompleted: !task.isCompleted)
          : task;
    }).toList();
    emit(TaskmodelUpdate(newTasks));
  }

  // ✅ لتحميل البيانات المخزنة
  @override
  TaskmodelState? fromJson(Map<String, dynamic> json) {
    try {
      final tasksJson = json['tasks'] as List;
      final tasks = tasksJson
          .map((taskJson) => TaskModel.fromJson(taskJson))
          .toList();
      return TaskmodelUpdate(tasks);
    } catch (e) {
      return TaskmodelInitial(); // fallback لو حصل خطأ
    }
  }

  // ✅ لتخزين البيانات
  @override
  Map<String, dynamic>? toJson(TaskmodelState state) {
    final tasksJson = state.tasks.map((task) => task.toJson()).toList();
    return {'tasks': tasksJson};
  }
}
