import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smp_todo/todo_model.dart';

import 'todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TodoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  DateTime scheduleDate = DateTime.now();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    eventTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //fetch the todoProvider and also listen to changes using listen flag 'true'
    final todos = Provider.of<TodoProvider>(context, listen: true).todos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => todoCard(todos[index]),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: todos.length),
      floatingActionButton: FloatingActionButton(
        onPressed: showBottomSheet,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget todoCard(TodoModel todoItem) {
    return Card(
      child: ListTile(
        title: Text(todoItem.title),
        subtitle: Text(todoItem.description),
        leading: Text(todoItem.eventType),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.MEd().format(todoItem.scheduleDate),
              style: const TextStyle(fontSize: 8),
            ),
            InkWell(
                onTap: () => deleteATodoItem(todoItem.id),
                child: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }

  void deleteATodoItem(String id) {
    //fetch the todoProvider
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    //call the deleteTodo method on the todoProvider
    todoProvider.deleteTodo(id);
  }

//a method that shows the bottom sheet
  void showBottomSheet() {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: eventTypeController,
                decoration: const InputDecoration(labelText: 'Event Type'),
              ),
              CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  onDateChanged: (selectedDate) {
                    setState(() {
                      scheduleDate = selectedDate;
                    });
                  }),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: newTodoAdder,
                child: const Text('Add Todo'),
              )
            ],
          ),
        );
      },
    );
  }

  //a method that adds a new todo to the todos list handle by the todoprovider
  void newTodoAdder() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.addTodo(
        title: titleController.text,
        scheduleDate: scheduleDate,
        description: descriptionController.text,
        eventType: eventTypeController.text);

    setState(() {
      titleController.text = '';
      descriptionController.text = '';
      eventTypeController.text = '';
    });
  }
}
