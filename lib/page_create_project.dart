import 'package:flutter/material.dart';
import 'package:timetracker_app/page_activities.dart';
import 'package:timetracker_app/requests.dart';

class CreateProject extends StatefulWidget {
  final int id;

  const CreateProject(this.id, {Key? key}) : super(key: key);

  @override
  State<CreateProject> createState() => _PageCreateProjectState();
}

class _PageCreateProjectState extends State<CreateProject> {
  late String name = "";
  late int id;
  late List<String> tag;
  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    //TextEditingController _textName = TextEditingController(text: "");
    return Scaffold(
      appBar: AppBar(title: const Text("Create new project")),
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
                  border: OutlineInputBorder(), labelText: 'Name of project'),
            ),
            const SizedBox(height: 30),
            const TextField(
              /* onChanged: (texto) {
                  tag = texto as List<String>;
                },*/
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
                createProject(id, name); //, tag);
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
