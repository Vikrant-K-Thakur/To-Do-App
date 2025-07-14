class ToDoModel {
  String title;
  bool isCompleted;
  String date;
  String time;
  String category;
  List<String> subtasks;
  bool isStarred;
  bool hasReminder;
  bool isRecurring;

  ToDoModel({
    required this.title,
    this.isCompleted = false,
    this.date = '',
    this.time = '',
    this.category = '',
    this.subtasks = const [],
    this.isStarred = false,
    this.hasReminder = false,
    this.isRecurring = false,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'isCompleted': isCompleted,
        'date': date,
        'time': time,
        'category': category,
        'subtasks': subtasks,
        'isStarred': isStarred,
        'hasReminder': hasReminder,
        'isRecurring': isRecurring,
      };

  factory ToDoModel.fromMap(Map map) => ToDoModel(
        title: map['title'],
        isCompleted: map['isCompleted'],
        date: map['date'],
        time: map['time'],
        category: map['category'],
        subtasks: List<String>.from(map['subtasks']),
        isStarred: map['isStarred'],
        hasReminder: map['hasReminder'],
        isRecurring: map['isRecurring'],
      );
}
