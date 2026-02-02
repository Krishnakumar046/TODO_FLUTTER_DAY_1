import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DialogWidget(),
    );
  }
}

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  final TextEditingController myController = TextEditingController();
  List<String> taskList = [];

  void _updateTaskValue(int index, String newValue) {
    setState(() {
      taskList[index] = newValue;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth:100,
        title: Text('TODO',style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.8,
      ),
      body: taskList.isNotEmpty
          ? ListView.builder(
        padding: const EdgeInsets.only(top:150 ,left:20,right: 20),
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final task = taskList[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                task,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => _EditDialog(
                          val: task,
                          index: index,
                          updateField: _updateTaskValue,
                        ),
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        taskList.removeAt(index);
                      });
                    },
                  ),
                ],
              )
            ),
          );
        },
      )
          : const _EmptyState(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuilder(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _dialogOpen = false;

  Future<void> _dialogBuilder(BuildContext context) async {
    if (_dialogOpen) return;

    _dialogOpen = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: TextField(
            controller: myController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter task name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
        {
          Navigator.of(dialogContext).pop(),
          print("<<<<<<<<<<<<>>>>>>>>>>>>>>>"),
          print(myController.text),
          print("<<<<<<<<<<<<>>>>>>>>>>>>>>>"),
          myController.clear(),
        }
        ,      child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                final text = myController.text.trim();
                if (text.isNotEmpty) {
                  setState(() => taskList.add(text));
                  Navigator.of(dialogContext).pop();
                  print("<<<<<<<<<<<<>>>>>>>>>>>>>>>");
                  print(myController.text);
                  print("<<<<<<<<<<<<>>>>>>>>>>>>>>>");
                  myController.clear();
                }
                print(taskList);
                print("taskList");
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );

    _dialogOpen = false;
  }
}
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 16),
          Text(
            "Make Your First List",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 6),
          Text(
            "By Adding The Task",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
class _EditDialog extends StatefulWidget {
  final String val;
  final int index;
  final void Function(int, String) updateField;

  const _EditDialog({
    Key? key,
    required this.val,
    required this.index,
    required this.updateField,
  }) : super(key: key);

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.val);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Task"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Edit task",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            final updatedText = _controller.text.trim();
            if (updatedText.isNotEmpty) {
              widget.updateField(widget.index, updatedText);
              Navigator.pop(context);
            }
          },
          child: const Text("SAVE"),
        ),
      ],
    );
  }
}



