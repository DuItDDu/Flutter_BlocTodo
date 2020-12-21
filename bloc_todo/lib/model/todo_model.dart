class TodoModel {
  int id;
  String desc;
  bool isDone = false;

  TodoModel({this.id, this.desc, this.isDone = false});

  factory TodoModel.fromDatabaseJson(Map<String, dynamic> data) => TodoModel(
    id: data['id'],
    desc: data['desc'],
    isDone: data['is_done'] == 0 ? false : true,
  );

  Map<String, dynamic> toDatabaseJson() => {
    'id': this.id,
    'desc': this.desc,
    'is_done': this.isDone ? 1 : 0
  };
}