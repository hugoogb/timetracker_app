import 'package:flutter/material.dart';
import 'package:timetracker_app/page_activities.dart';
import 'package:timetracker_app/requests.dart';

class CreateTask extends StatefulWidget {
  final int id;

  const CreateTask(this.id, {Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _PageCreateTaskState();
}

class _PageCreateTaskState extends State<CreateTask> {
  late String name = "";
  late int id;
  late List<String> task;
  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    //TextEditingController _textName = TextEditingController(text: "");
    return Scaffold(
      appBar: AppBar(title: const Text("Create new task")),
      body: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                name = text;
              },
              //controller: _textName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Name of task'),
            ),
            const SizedBox(height: 30),
            const TextField(
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of tags (Ex: urgent, normal, etc, )',
              ),
            ),
            const SizedBox(height: 270),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                fixedSize: const Size.square(100),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                createTask(id, name); //, task);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PageActivities(0)));
              },
              child: const Text('CREATE'),
            )
          ],
        ),
      ),
    );
  }
}
