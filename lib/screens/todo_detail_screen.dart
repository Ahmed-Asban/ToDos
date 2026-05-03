import 'package:flutter/material.dart';
import 'package:clincapp/models/todo_model.dart';
import 'package:clincapp/screens/add_edit_todo_screen.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) onUpdate;

  const TodoDetailScreen({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onUpdate,
  });

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              onDelete(todo);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTodoScreen(todo: todo),
                ),
              );
              if (result != null && result is Todo) {
                onUpdate(result);
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          todo.isCompleted ? Icons.check_circle : Icons.pending,
                          color: todo.isCompleted
                              ? Colors.green
                              : Colors.orange,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          todo.isCompleted ? 'Completed' : 'In Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: todo.isCompleted
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        const Spacer(),
                        if (!todo.isCompleted)
                          ElevatedButton.icon(
                            onPressed: () {
                              final updatedTodo = todo.copyWith(
                                isCompleted: true,
                              );
                              onUpdate(updatedTodo);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Mark Complete'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.description),
                        SizedBox(width: 8),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      todo.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.priority_high,
                      'Priority',
                      todo.priority.displayName,
                      color: todo.priority.color,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Created',
                      _formatDate(todo.createdAt),
                    ),
                    if (todo.dueDate != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.event,
                        'Due Date',
                        _formatDate(todo.dueDate!),
                        color:
                            todo.dueDate!.isBefore(DateTime.now()) &&
                                !todo.isCompleted
                            ? Colors.red
                            : null,
                      ),
                    ],
                    if (todo.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.local_offer),
                          SizedBox(width: 8),
                          Text('Tags'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: todo.tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: Colors.blue[100],
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[600]),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.black,
              fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
