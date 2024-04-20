import 'package:flutter/material.dart';
import 'package:smp_todo/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  //private list of todos
  List<TodoModel> _todos = [];

  //getter for the private todos list
  List<TodoModel> get todos => _todos;

  void addTodo(
      {required String title,
      required DateTime scheduleDate,
      required String description,
      required String eventType}) {
    //create a new todo instance(object)
    final newTodo = TodoModel(
        id: const Uuid().v4(),
        title: title,
        creationDate: DateTime.now(),
        scheduleDate: scheduleDate,
        description: description,
        eventType: eventType,
        isDone: false);

    //add the new created todo object the todo list
    _todos.add(newTodo);

    //notify the listeners that a new todo has been added
    notifyListeners();
  }

  void deleteTodo(String id) {
    //removes where an element in the list equals the provided id
    _todos.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
