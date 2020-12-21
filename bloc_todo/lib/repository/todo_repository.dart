import 'package:bloc_todo/database/dao/todo_dao.dart';
import 'package:bloc_todo/model/todo_model.dart';

class TodoRepository {
  final todoDao = TodoDao();

  Future getTodoList({String query}) => todoDao.getTodoList(query: query);

  Future insertTodo(TodoModel todo) => todoDao.createTodo(todo);

  Future updateTodo(TodoModel todo) => todoDao.updateTodo(todo);

  Future deleteTodoById(int id) => todoDao.deleteTodo(id);

  Future deleteAllTodo() => todoDao.deleteAllTodo();
}