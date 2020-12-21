import 'package:bloc_todo/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_todo/bloc/todo_bloc.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final TodoBloc todoBloc = TodoBloc();
  final String title;

  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                child: Container(
                    //This is where the magic starts
                    child: _getHomePageWidget()))),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () {
            _showAddTodoSheet(context);
          },
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 32,
            color: Colors.indigoAccent,
          ),
        ));
  }

  Widget _getAddTodoInputWidget(BuildContext context, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: new Container(
        color: Colors.transparent,
        child: new Container(
          height: 230,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0)
              )
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 15, top: 25.0, right: 15, bottom: 30),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        textInputAction: TextInputAction.newline,
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w400),
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: 'I have to...',
                            labelText: 'New Todo',
                            labelStyle: TextStyle(
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.w500)),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Empty description!';
                          }
                          return value.contains('')
                              ? 'Do not use the @ char.'
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, top: 15),
                      child: CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        radius: 18,
                        child: IconButton(
                          icon: Icon(
                            Icons.save,
                            size: 22,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            final newTodo = TodoModel(desc: controller.value.text);
                            if (newTodo.desc.isNotEmpty) {
                              todoBloc.addTodo(newTodo);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getHomePageWidget() {
    return StreamBuilder(
      stream: todoBloc.todoList,
      builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _getTodoListWidget(snapshot);
          } else {
            return _getNoTodoMessageWidget();
          }
        } else {
          return _getLoadingWidget();
        }
      }
    );
  }

  Widget _getTodoListWidget(AsyncSnapshot<List<TodoModel>> snapshot) {
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, itemPosition) {
          TodoModel todo = snapshot.data[itemPosition];
          return _getTodoDismissibleCard(todo);
        },
      );
  }

  Widget _getTodoDismissibleCard(TodoModel todo) {
    return Dismissible(
        background: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Deleting", style: TextStyle(color: Colors.white)),
            ),
          ),
          color: Colors.redAccent,
        ),
        onDismissed: (direction) { todoBloc.deleteTodoById(todo.id); },
        direction: _dismissDirection,
        key: new ObjectKey(todo),
        child: _getTodoListCard(todo)
    );
  }

  Widget _getTodoListCard(TodoModel todo) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[200], width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white,
        child: ListTile(
          leading: InkWell(
            onTap: () {
              //Reverse the value
              todo.isDone = !todo.isDone;
              todoBloc.updateTodo(todo);
            },
            child: Container(
              //decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: todo.isDone
                    ? Icon(
                  Icons.done,
                  size: 26.0,
                  color: Colors.indigoAccent,
                )
                    : Icon(
                  Icons.check_box_outline_blank,
                  size: 26.0,
                  color: Colors.tealAccent,
                ),
              ),
            ),
          ),
          title: Text(
            todo.desc,
            style: TextStyle(
                fontSize: 16.5,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w500,
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        )
    );
  }

  Widget _getLoadingWidget() {
    todoBloc.getTodoList();
    return Center(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading...", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        )
    );
  }

  Widget _getNoTodoMessageWidget() {
    return Container(
        child: Center(
          child: Container(
            child: Text("Start adding Todo...", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
          )
        )
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    final textEditingController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return _getAddTodoInputWidget(context, textEditingController);
        });
  }

  dispose() {
    todoBloc.dispose();
  }
}
