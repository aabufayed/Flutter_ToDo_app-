import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TodosList(title: 'Todos'),
    );
  }
}

class TodosList extends StatefulWidget {
  TodosList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final List<String> _todos = [];

  void _addTodo() async {
    final TextEditingController textEditingController = TextEditingController();

    final todo = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: textEditingController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter your todo'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new todo to the list of todos
                final newTodo = textEditingController.text;
                if (newTodo.isNotEmpty) {
                  Navigator.of(context).pop(newTodo);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (todo != null && todo.isNotEmpty) {
      setState(() {
        _todos.add(todo);
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodoCompleted(int index) {
    final todo = _todos[index];
    final isCompleted = todo.startsWith('✓ ');
    setState(() {
      _todos[index] = isCompleted ? todo.substring(2) : '✓ $todo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = _todos[index];
          return Dismissible(
            key: Key('$todo$index'),
            onDismissed: (direction) {
              _removeTodo(index);
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: CheckboxListTile(
                title: Text(
                  todo.startsWith('✓ ') ? todo.substring(2) : todo,
                  style: TextStyle(
                    decoration: todo.startsWith('✓ ')
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                value: todo.startsWith('✓ '),
                onChanged: (bool? value) {
                  _toggleTodoCompleted(index);
                },
                secondary: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeTodo(index);
                  },
                ),
              ),
            ),
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}