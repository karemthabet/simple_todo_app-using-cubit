import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/bussiness_logic/cubit/taskmodel_cubit.dart';
import 'package:todo_app/widgets/edit_task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  runApp(
    BlocProvider(create: (context) => TaskmodelCubit(), child: SimpleToDoApp()),
  );
}

class SimpleToDoApp extends StatelessWidget {
  const SimpleToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoSimpleUI(),
    );
  }
}

class ToDoSimpleUI extends StatefulWidget {
  const ToDoSimpleUI({super.key});

  @override
  State<ToDoSimpleUI> createState() => _ToDoSimpleUIState();
}

class _ToDoSimpleUIState extends State<ToDoSimpleUI> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" Simple To-Do")),
      body: BlocBuilder<TaskmodelCubit, TaskmodelState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "add Task ",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TaskmodelCubit>().addTask(
                          _controller.text,
                        );
                        _controller.clear();
                      },
                      child: const Text('add Task'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Checkbox(
                          value: state.tasks[index].isCompleted,
                          onChanged: (_) {
                            context.read<TaskmodelCubit>().toggleTask(
                              state.tasks[index].id,
                            );
                          },
                        ),
                        title: Text(
                          state.tasks[index].title,
                          style: TextStyle(
                            decoration:
                                state.tasks[index].isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => EditTaskDialog(
                                        task: state.tasks[index],
                                      ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context.read<TaskmodelCubit>().removeTask(
                                  state.tasks[index].id,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
