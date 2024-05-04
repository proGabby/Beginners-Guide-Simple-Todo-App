import 'package:flutter/material.dart';
import 'package:smp_todo/model/todo_model.dart';
import 'package:smp_todo/services/db_service.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  //private list of todos
  List<TodoModel> _todos = [];

  //getter for the private todos list
  List<TodoModel> get todos => _todos;

  Future<void> addTodo(
      {required String title,
      required DateTime scheduleDate,
      required String description,
      required String eventType}) async {
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

    await DBService.insert('todo', newTodo.toJson());
  }

  Future<void> deleteTodo(String id) async {
    //removes where an element in the list equals the provided id
    _todos.removeWhere((element) => element.id == id);
    notifyListeners();
    await DBService.deleteData('todo', id);
  }

  Future<void> fetchTodoFromDB() async {
    final fetchTodoList = await DBService.getData('todo');

    fetchTodoList.forEach((inCommingTodo) {
      final newTodoDBItem = TodoModel(
          id: inCommingTodo['id'],
          title: inCommingTodo['title'],
          creationDate: DateTime.parse(inCommingTodo['creationDate']),
          scheduleDate: DateTime.parse(inCommingTodo['scheduleDate']),
          description: inCommingTodo['description'],
          eventType: inCommingTodo['eventType'],
          isDone: false);

      _todos.add(newTodoDBItem);
    });
    notifyListeners();
  }
}
