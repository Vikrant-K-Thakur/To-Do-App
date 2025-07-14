import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final bool isStarred;
  final Function(bool?)? onChanged;
  final Function(BuildContext context)? deleteFunction;
  final VoidCallback onToggleStar;
  final VoidCallback onEdit;
  final VoidCallback onAddReminder;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.isStarred,
    required this.onChanged,
    required this.deleteFunction,
    required this.onToggleStar,
    required this.onEdit,
    required this.onAddReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              icon: Icons.edit,
              backgroundColor: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onAddReminder(),
              icon: Icons.calendar_today_rounded,
              backgroundColor: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(77),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggleStar,
                child: Icon(
                  isStarred ? Icons.star : Icons.star_border,
                  color: isStarred ? Colors.amber : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

