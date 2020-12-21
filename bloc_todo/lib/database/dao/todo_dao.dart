import 'dart:async';
import 'package:bloc_todo/database/database.dart';
import 'package:bloc_todo/model/todo_model.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.provider;

  Future<int> createTodo(TodoModel todo) async {
    final db = await dbProvider.database;
    final result = db.insert(todoTable, todo.toDatabaseJson());
    return result;
  }

  Future<List<TodoModel>> getTodoList({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(
          todoTable,
          columns: columns,
          where: 'desc LIKE ?',
          whereArgs: ["%query%"]
        );
      }
    } else {
      result = await db.query(todoTable, columns: columns);
    }

    List<TodoModel> todoList = result.isNotEmpty ? result.map((item) => TodoModel.fromDatabaseJson(item)).toList() : [];
    return todoList;
  }

  Future<int> updateTodo(TodoModel todo) async {
    final db = await dbProvider.database;
    final result = await db.update(todoTable, todo.toDatabaseJson(), where: "id = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    final result = await db.delete(todoTable, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> deleteAllTodo() async {
    final db = await dbProvider.database;
    final result = await db.delete(todoTable);
    return result;
  }
}