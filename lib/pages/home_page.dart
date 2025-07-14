import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/data/database.dart';
import 'package:my_flutter_app/widgets/reminder_dialog.dart';
import 'package:my_flutter_app/widgets/dialog_box.dart';
import 'package:my_flutter_app/widgets/todo_tile.dart';
import 'package:my_flutter_app/util/color_mode.dart';
import '../pages/calendar_page.dart';
import '../pages/me_page.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<ColorMode> colorModeNotifier;
  const HomePage({super.key, required this.colorModeNotifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _controller = TextEditingController();

  int _selectedIndex = 0;
  List<String> _subtasks = [];
  bool _isStarred = false;
  bool _hasReminder = false;
  bool _isRecurring = false;
  int? _editingIndex;

  final _todoBox = Hive.box('todo_box');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    super.initState();
    if (_todoBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      final oldData = _todoBox.get('TODOLIST');
      if (oldData is List && oldData.isNotEmpty && oldData[0] is List) {
        db.toDoList = oldData.map((e) {
          return {
            'title': e[0],
            'isCompleted': e[1],
            'date': '',
            'time': '',
            'category': '',
            'subtasks': [],
            'isStarred': false,
            'hasReminder': false,
            'isRecurring': false,
          };
        }).toList();
        db.updateDataBase();
      } else {
        db.loadData();
      }
    }
  }

  void cycleColorMode() {
    final current = widget.colorModeNotifier.value;
    final next = ColorMode.values[(current.index + 1) % ColorMode.values.length];
    widget.colorModeNotifier.value = next;
    Hive.box('settings').put('themeIndex', next.index);
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index]['isCompleted'] = value ?? false;
    });
    db.updateDataBase();
  }

  void toggleStar(int index) {
    setState(() {
      db.toDoList[index]['isStarred'] = !db.toDoList[index]['isStarred'];
    });
    db.updateDataBase();
  }

  void editTask(int index) {
    final task = db.toDoList[index];
    _controller.text = task['title'];
    _dateController.text = task['date'];
    _timeController.text = task['time'];
    _categoryController.text = task['category'];
    _subtasks = List<String>.from(task['subtasks']);
    _isStarred = task['isStarred'];
    _hasReminder = task['hasReminder'];
    _isRecurring = task['isRecurring'];
    _editingIndex = index;

    _showDialog();
  }

  void addReminder(int index) {
    final task = db.toDoList[index];
    _controller.text = task['title'];
    _dateController.text = task['date'];
    _timeController.text = task['time'];
    _editingIndex = index;

    _showReminderDialog();
  }

  void _showReminderDialog() {
    if (_editingIndex == null) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return ReminderDialog(
          parentContext: context,
          dateController: _dateController,
          timeController: _timeController,
          onSave: () {
            setState(() {
              final task = db.toDoList[_editingIndex!];
              task['date'] = _dateController.text;
              task['time'] = _timeController.text;
              task['hasReminder'] = true;
              db.toDoList[_editingIndex!] = task;
              db.updateDataBase();
              _editingIndex = null;
              _dateController.clear();
              _timeController.clear();
            });
            Navigator.pop(ctx);
          },
          onCancel: () {
            _editingIndex = null;
            _dateController.clear();
            _timeController.clear();
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          titleController: _controller,
          dateController: _dateController,
          timeController: _timeController,
          categoryController: _categoryController,
          subtasks: _subtasks,
          onUpdateSubtasks: (list) => _subtasks = list,
          isStarred: _isStarred,
          hasReminder: _hasReminder,
          isRecurring: _isRecurring,
          onFlagChange: (starred, reminder, recurring) {
            _isStarred = starred;
            _hasReminder = reminder;
            _isRecurring = recurring;
          },
          onSave: () {
            setState(() {
              final updatedTask = {
                'title': _controller.text,
                'isCompleted': false,
                'date': _dateController.text,
                'time': _timeController.text,
                'category': _categoryController.text,
                'subtasks': _subtasks,
                'isStarred': _isStarred,
                'hasReminder': _hasReminder,
                'isRecurring': _isRecurring,
              };
              if (_editingIndex != null) {
                db.toDoList[_editingIndex!] = updatedTask;
              } else {
                db.toDoList.add(updatedTask);
              }
              _editingIndex = null;
              _controller.clear();
              _dateController.clear();
              _timeController.clear();
              _categoryController.clear();
              _subtasks = [];
              _isStarred = false;
              _hasReminder = false;
              _isRecurring = false;
            });
            db.updateDataBase();
            Navigator.of(context).pop();
          },
          onCancel: () {
            _editingIndex = null;
            _controller.clear();
            _dateController.clear();
            _timeController.clear();
            _categoryController.clear();
            _subtasks = [];
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void createNewTask() {
    _controller.clear();
    _dateController.clear();
    _timeController.clear();
    _categoryController.clear();
    _subtasks = [];
    _isStarred = false;
    _hasReminder = false;
    _isRecurring = false;
    _editingIndex = null;
    _showDialog();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TaskListView(
        db: db,
        checkboxChanged: checkboxChanged,
        deleteTask: deleteTask,
        toggleStar: toggleStar,
        editTask: editTask,
        addReminder: addReminder,
      ),
      const CalendarPage(),
      const MePage(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Center(child: Text('TO DO')),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: cycleColorMode,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                children: [
                  Icon(Icons.check_box, size: 40, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    'To-Do List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Theme.of(context).primaryColor),
              title: const Text('Starred Tasks'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: createNewTask,
              child: const Icon(Icons.add),
            )
          : null,
      body: pages[_selectedIndex],
    );
  }
}

class TaskListView extends StatelessWidget {
  final ToDoDataBase db;
  final Function(bool?, int) checkboxChanged;
  final Function(int) deleteTask;
  final Function(int) toggleStar;
  final Function(int) editTask;
  final Function(int) addReminder;

  const TaskListView({
    super.key,
    required this.db,
    required this.checkboxChanged,
    required this.deleteTask,
    required this.toggleStar,
    required this.editTask,
    required this.addReminder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: db.toDoList.length,
      itemBuilder: (context, index) {
        final task = db.toDoList[index];
        return ToDoTile(
          taskName: task['title'],
          taskCompleted: task['isCompleted'],
          isStarred: task['isStarred'],
          onChanged: (value) => checkboxChanged(value, index),
          deleteFunction: (context) => deleteTask(index),
          onToggleStar: () => toggleStar(index),
          onEdit: () => editTask(index),
          onAddReminder: () => addReminder(index),
        );
      },
    );
  }
}