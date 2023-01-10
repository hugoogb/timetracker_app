import 'package:flutter/material.dart';
import 'package:time_tracker/page_activities.dart';
import 'package:time_tracker/requests.dart';

class CreateTask extends StatefulWidget {
  final int id;

  const CreateTask(this.id, {Key? key}) : super(key: key);

  @override
  _PageCreateTaskState createState() => _PageCreateTaskState();
}

class _PageCreateTaskState extends State<CreateTask>{

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
      appBar: AppBar(
          title: Text("Create new task")),
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
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of task'
              ),
            ),
            SizedBox(height: 30),
            TextField(
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of tags (Ex: urgent, normal, etc, )',
              ),
            ),
            SizedBox(height: 270),
            TextButton(
              child: Text('CREATE'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                fixedSize: Size.square(100),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                newTask(id, name); //, task);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PageActivities(0))
                );
              },
            )
          ],
        ),
      ),
    );
  }
}