import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/util/my_button.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController categoryController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  final List<String> subtasks;
  final void Function(List<String>) onUpdateSubtasks;

  final bool isStarred;
  final bool hasReminder;
  final bool isRecurring;
  final void Function(bool, bool, bool) onFlagChange;

  const DialogBox({
    super.key,
    required this.titleController,
    required this.dateController,
    required this.timeController,
    required this.categoryController,
    required this.onSave,
    required this.onCancel,
    required this.subtasks,
    required this.onUpdateSubtasks,
    required this.isStarred,
    required this.hasReminder,
    required this.isRecurring,
    required this.onFlagChange,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  late bool isStarred;
  late bool hasReminder;
  late bool isRecurring;

  final TextEditingController subtaskController = TextEditingController();
  late List<String> subtasks;

  final List<String> categories = ['Work', 'Personal', 'Shopping', 'Others'];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    isStarred = widget.isStarred;
    hasReminder = widget.hasReminder;
    isRecurring = widget.isRecurring;
    subtasks = List.from(widget.subtasks);
    selectedCategory = widget.categoryController.text.isNotEmpty
        ? widget.categoryController.text
        : null;
  }

  void _addSubtask() {
    final text = subtaskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        subtasks.add(text);
        widget.onUpdateSubtasks(subtasks);
        subtaskController.clear();
      });
    }
  }

  void _removeSubtask(int index) {
    setState(() {
      subtasks.removeAt(index);
      widget.onUpdateSubtasks(subtasks);
    });
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (!mounted) return;

    if (picked != null) {
      widget.dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);

    if (!mounted) return;
    if (picked != null) {
      widget.timeController.text = picked.format(context);
    }
  }

  void _updateFlags() {
    widget.onFlagChange(isStarred, hasReminder, isRecurring);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Task Title
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Subtasks
            Row(
              children: [
                const Icon(Icons.subdirectory_arrow_right),
                const SizedBox(width: 8),
                const Text('Subtasks'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Add Subtask'),
                        content: TextField(
                          controller: subtaskController,
                          autofocus: true,
                          onSubmitted: (_) => _addSubtask(),
                          decoration: const InputDecoration(
                            hintText: 'Enter subtask',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _addSubtask();
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            for (int i = 0; i < subtasks.length; i++)
              ListTile(
                leading: const Icon(Icons.circle, size: 8),
                title: Text(subtasks[i]),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () => _removeSubtask(i),
                ),
              ),

            const SizedBox(height: 12),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: const Text("Select Category"),
              items: categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  widget.categoryController.text = value ?? '';
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 12),

            // Reminder Checkbox
            Row(
              children: [
                Checkbox(
                  value: hasReminder,
                  onChanged: (val) {
                    setState(() {
                      hasReminder = val!;
                      _updateFlags();
                    });
                  },
                ),
                const Text('Reminder'),
              ],
            ),

            if (hasReminder)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: widget.dateController,
                          decoration: const InputDecoration(
                            labelText: 'Select Date',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: widget.timeController,
                          decoration: const InputDecoration(
                            labelText: 'Select Time',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Recurring + Star
            Row(
              children: [
                Checkbox(
                  value: isRecurring,
                  onChanged: (val) {
                    setState(() {
                      isRecurring = val!;
                      _updateFlags();
                    });
                  },
                ),
                const Text('Recurring'),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isStarred ? Icons.star : Icons.star_border,
                    color: isStarred ? Colors.amber : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isStarred = !isStarred;
                      _updateFlags();
                    });
                  },
                ),
                const Text('Star'),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(text: "Save", onPressed: widget.onSave),
                const SizedBox(width: 8),
                MyButton(text: "Cancel", onPressed: widget.onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
