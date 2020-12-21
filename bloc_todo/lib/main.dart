import 'package:bloc_todo/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter BlocTodo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        canvasColor: Colors.transparent,
      ),
      home: HomePage(title: 'Flutter BlocTodo'),
    );
  }
}