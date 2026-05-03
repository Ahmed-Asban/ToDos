import 'package:flutter/material.dart';
import 'package:clincapp/models/todo_model.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onTap,
  });

  String _getTimeRemaining() {
    if (todo.dueDate == null) return '';
    final now = DateTime.now();
    final difference = todo.dueDate!.difference(now);
    if (difference.isNegative) return 'Overdue';
    if (difference.inDays > 0) return '${difference.inDays}d left';
    if (difference.inHours > 0) return '${difference.inHours}h left';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m left';
    return 'Due soon';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Checkbox
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => onToggle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  activeColor: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: todo.isCompleted ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      todo.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tags and metadata row
                    Row(
                      children: [
                        // Priority indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: todo.priority.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                todo.priority.icon,
                                size: 12,
                                color: todo.priority.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                todo.priority.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: todo.priority.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Due date indicator
                        if (todo.dueDate != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  todo.dueDate!.isBefore(DateTime.now()) &&
                                      !todo.isCompleted
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 12,
                                  color:
                                      todo.dueDate!.isBefore(DateTime.now()) &&
                                          !todo.isCompleted
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getTimeRemaining(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        todo.dueDate!.isBefore(
                                              DateTime.now(),
                                            ) &&
                                            !todo.isCompleted
                                        ? Colors.red
                                        : Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        // Tags preview
                        if (todo.tags.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_offer,
                                  size: 12,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  todo.tags.first,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (todo.tags.length > 1)
                                  Text(
                                    ' +${todo.tags.length - 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Trailing icon
              Icon(
                todo.isCompleted ? Icons.check_circle : Icons.chevron_right,
                color: todo.isCompleted ? Colors.green : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
