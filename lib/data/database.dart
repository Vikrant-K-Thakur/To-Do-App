import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List<Map<String, dynamic>> toDoList = [];

  final _todoBox = Hive.box('todo_box');

  void createInitialData() {
    toDoList = [
      {
        'title': 'Task 1',
        'isCompleted': false,
        'date': '',
        'time': '',
        'category': '',
        'subtasks': [],
        'isStarred': false,
        'hasReminder': false,
        'isRecurring': false,
      },
      {
        'title': 'Task 2',
        'isCompleted': false,
        'date': '',
        'time': '',
        'category': '',
        'subtasks': [],
        'isStarred': false,
        'hasReminder': false,
        'isRecurring': false,
      },
    ];
    updateDataBase();
  }

  void loadData() {
    final rawList = _todoBox.get('TODOLIST');
    if (rawList != null) {
      toDoList = List<Map<String, dynamic>>.from(
        (rawList as List).map((e) => Map<String, dynamic>.from(e)),
      );
    }
  }

  void updateDataBase() {
    _todoBox.put('TODOLIST', toDoList);
  }
}
