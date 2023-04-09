// import 'package:crudrestapiwithdb/sqdb/sq.dart';
// import 'package:sqflite/sqflite.dart';
//
// class Todo {
//   final int id;
//   final String name;
//   final String description;
//   final String dueDate;
//   final bool completed;
//
//   Todo({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.dueDate,
//     required this.completed,
//   });
//
//   factory Todo.fromMap(Map<String, dynamic> json) => Todo(
//     id: json['id'] as int,
//     name: json['name'] as String,
//     description: json['description'] as String,
//     dueDate: json['dueDate'] as String,
//     completed: json['completed'] == 1,
//   );
//
//   Map<String, dynamic> toMap() => {
//     'id': id,
//     'name': name,
//     'description': description,
//     'dueDate': dueDate,
//     'completed': completed ? 1 : 0,
//   };
// }
// Future<List<Todo>> getTodosFromDatabase() async {
//   final Database database = await createDatabase();
//   final List<Map<String, dynamic>> todoMaps = await database.query('todos');
//   final List<Todo> todos =
//   todoMaps.map((map) => Todo.fromMap(map)).toList();
//   return todos;
// }