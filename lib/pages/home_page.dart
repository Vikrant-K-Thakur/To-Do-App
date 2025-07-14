import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/data/database.dart';
import 'package:my_flutter_app/util/dialog_box.dart';
import 'package:my_flutter_app/util/todo_tile.dart';
import 'package:my_flutter_app/util/color_mode.dart';
import 'calendar_page.dart';
import 'me_page.dart';

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

  final _todoBox = Hive.box('todo_box');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_todoBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      // Migrate if old list format is found
      final oldData = _todoBox.get('TODOLIST');
      if (oldData is List && oldData.isNotEmpty && oldData[0] is List) {
        // Convert old ["Task", false] to map
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
        db.updateDataBase(); // Save updated format
      } else {
        db.loadData();
      }
    }
    super.initState();
  }

  void cycleColorMode() {
    final current = widget.colorModeNotifier.value;
    final next =
        ColorMode.values[(current.index + 1) % ColorMode.values.length];
    widget.colorModeNotifier.value = next;

    final settingsBox = Hive.box('settings');
    settingsBox.put('themeIndex', next.index);
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index]['isCompleted'] = value ?? false;
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add({
        'title': _controller.text,
        'isCompleted': false,
        'date': _dateController.text,
        'time': _timeController.text,
        'category': _categoryController.text,
        'subtasks': _subtasks,
        'isStarred': _isStarred,
        'hasReminder': _hasReminder,
        'isRecurring': _isRecurring,
      });

      _controller.clear();
      _dateController.clear();
      _timeController.clear();
      _categoryController.clear();
      _subtasks = [];
      _isStarred = false;
      _hasReminder = false;
      _isRecurring = false;
    });

    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    _subtasks = [];
    _isStarred = false;
    _hasReminder = false;
    _isRecurring = false;

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
          onSave: saveNewTask,
          onCancel: () {
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
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
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
            ),
            ListTile(
              leading: Icon(
                Icons.star_rate_rounded,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Starred Tasks'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Categories'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                Icons.brush_outlined,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Themes'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Settings'),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Calendar',
          ),
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

  const TaskListView({
    super.key,
    required this.db,
    required this.checkboxChanged,
    required this.deleteTask,
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
          isStarred: task['isStarred'], // ✅ Add this line
          onChanged: (value) => checkboxChanged(value, index),
          deleteFunction: (context) => deleteTask(index),
        );
      },
    );
  }
}
