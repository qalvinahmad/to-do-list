import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext, String, Function(String))? editTask;

  ToDoTile({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.editTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            // Ensures space before icon
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // checkbox
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),

              // task name
              Expanded(
                // Ensures remaining space is filled by Text
                child: Text(
                  taskName,
                  style: TextStyle(
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
