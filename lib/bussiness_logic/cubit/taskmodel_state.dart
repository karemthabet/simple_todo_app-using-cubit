part of 'taskmodel_cubit.dart';

sealed class TaskmodelState extends Equatable {
  final List<TaskModel> tasks;
  const TaskmodelState(this.tasks);

  @override
  List<Object> get props => [tasks];
}

final class TaskmodelInitial extends TaskmodelState {
  TaskmodelInitial() : super([]);
}

final class TaskmodelUpdate extends TaskmodelState {
  const TaskmodelUpdate(List<TaskModel> newTasks) : super(newTasks);
}
