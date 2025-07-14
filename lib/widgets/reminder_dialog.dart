import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderDialog extends StatelessWidget {
  final BuildContext parentContext;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const ReminderDialog({
    super.key,
    required this.parentContext,
    required this.dateController,
    required this.timeController,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('Set Reminder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: parentContext,
                initialDate: now,
                firstDate: now,
                lastDate: DateTime(2100),
              );
              if (parentContext.mounted && picked != null) {
                dateController.text = DateFormat('yyyy-MM-dd').format(picked);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: parentContext,
                initialTime: TimeOfDay.now(),
              );
              if (parentContext.mounted && picked != null) {
                timeController.text = picked.format(parentContext);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Select Time',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
