import 'package:bloc_todo/model/todo_model.dart';
import 'package:bloc_todo/repository/todo_repository.dart';
import 'dart:async';

class TodoBloc {
  final _todoRepository = TodoRepository();
  final _todoController = StreamController<List<TodoModel>>.broadcast();

  get todoList => _todoController.stream;

  TodoBloc() {
    getTodoList();
  }

  getTodoList({String query}) async {
    _todoController.sink.add(await _todoRepository.getTodoList(query: query));
  }

  addTodo(TodoModel todo) async {
    await _todoRepository.insertTodo(todo);
    getTodoList();
  }

  updateTodo(TodoModel todo) async {
    await _todoRepository.updateTodo(todo);
    getTodoList();
  }

  deleteTodoById(int id) async {
    _todoRepository.deleteTodoById(id);
    getTodoList();
  }

  dispose() {
    _todoController.close();
  }
}