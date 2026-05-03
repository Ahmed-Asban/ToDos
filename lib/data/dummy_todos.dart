import '../models/todo_model.dart';

List<Todo> dummyTodos = [
  Todo(
    id: 1,
    title: 'Learn Flutter',
    description:
        'Complete Flutter basics and widgets. Master the fundamental concepts of Flutter development including widgets, state management, and navigation.',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    priority: Priority.high,
    tags: ['Learning', 'Development'],
  ),
  Todo(
    id: 2,
    title: 'Build Todo App',
    description:
        'Create advanced todo project with beautiful UI and animations.',
    dueDate: DateTime.now().add(const Duration(days: 5)),
    priority: Priority.medium,
    tags: ['Project', 'Flutter'],
  ),
  Todo(
    id: 3,
    title: 'Practice UI Design',
    description: 'Improve Flutter layout skills and create responsive designs.',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    priority: Priority.medium,
    tags: ['Design', 'UI/UX'],
  ),
  Todo(
    id: 4,
    title: 'Study State Management',
    description:
        'Learn Provider, Riverpod, or Bloc for state management solutions.',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    priority: Priority.high,
    tags: ['Learning', 'State Management'],
  ),
];
