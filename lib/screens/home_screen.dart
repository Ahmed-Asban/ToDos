import 'package:clincapp/data/dummy_todos.dart';
import 'package:clincapp/models/todo_model.dart';
import 'package:clincapp/screens/add_edit_todo_screen.dart';
import 'package:clincapp/screens/todo_detail_screen.dart';
import 'package:clincapp/widgets/todo_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late List<Todo> todos;
  late TabController _tabController;
  String _searchQuery = '';
  Priority? _selectedPriority;
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    todos = List.from(dummyTodos);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Todo> get _filteredTodos {
    var filtered = todos.where((todo) {
      // Search filter
      final matchesSearch =
          _searchQuery.isEmpty ||
          todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          todo.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          todo.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      // Priority filter
      final matchesPriority =
          _selectedPriority == null || todo.priority == _selectedPriority;

      // Completion filter based on tab
      final matchesCompletion = _tabController.index == 0
          ? true
          : // All
            _tabController.index == 1
          ? !todo.isCompleted
          : // Active
            todo.isCompleted; // Completed

      return matchesSearch &&
          matchesPriority &&
          matchesCompletion &&
          _showCompleted;
    }).toList();

    // Sort by priority and date
    filtered.sort((a, b) {
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      if (a.priority != b.priority)
        return b.priority.index.compareTo(a.priority.index);
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  void _addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Todo added successfully!')));
  }

  void _updateTodo(Todo updatedTodo) {
    setState(() {
      final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Todo updated successfully!')));
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      todos.removeWhere((t) => t.id == todo.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${todo.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              todos.add(todo);
            });
          },
        ),
      ),
    );
  }

  void _toggleTodo(int id) {
    setState(() {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index].isCompleted = !todos[index].isCompleted;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Tasks',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.task_alt, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                '${_filteredTodos.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search todos...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Priority Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _selectedPriority == null,
                            onSelected: (_) {
                              setState(() {
                                _selectedPriority = null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ...Priority.values.map((priority) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(priority.displayName),
                                selected: _selectedPriority == priority,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedPriority =
                                        _selectedPriority == priority
                                        ? null
                                        : priority;
                                  });
                                },
                                backgroundColor: priority.color.withOpacity(
                                  0.1,
                                ),
                                selectedColor: priority.color.withOpacity(0.3),
                                checkmarkColor: priority.color,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'All', icon: Icon(Icons.list)),
              Tab(text: 'Active', icon: Icon(Icons.pending_actions)),
              Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
            ],
          ),
          // Todo List
          Expanded(
            child: _filteredTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_turned_in,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No matching todos found'
                              : _tabController.index == 1
                              ? 'No active tasks\nAdd a new task to get started!'
                              : _tabController.index == 2
                              ? 'No completed tasks\nComplete some tasks to see them here!'
                              : 'No todos available\nTap + to add a new todo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = _filteredTodos[index];
                      return TodoTile(
                        todo: todo,
                        onToggle: () => _toggleTodo(todo.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoDetailScreen(
                                todo: todo,
                                onDelete: _deleteTodo,
                                onUpdate: _updateTodo,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTodoScreen()),
          );
          if (result != null && result is Todo) {
            _addTodo(result);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Todo'),
        elevation: 0,
      ),
    );
  }
}
