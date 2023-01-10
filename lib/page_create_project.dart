import 'package:flutter/material.dart';
import 'package:time_tracker/page_activities.dart';
import 'package:time_tracker/requests.dart';

class CreateProject extends StatefulWidget {
  final int id;

  const CreateProject(this.id, {Key? key}) : super(key: key);

  @override
  _PageCreateProjectState createState() => _PageCreateProjectState();
}

class _PageCreateProjectState extends State<CreateProject>{

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
      appBar: AppBar(
        title: Text("Create new project")),
        body: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            children: [
              TextField(
                onChanged: (texto) {
                  name = texto;
                },
                //controller: _textName,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of project'

                ),
              ),
              SizedBox(height: 30),
              TextField(
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
              SizedBox(height: 270),
              TextButton(
                child: Text('CREATE'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  fixedSize: Size.square(100),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  newProject(id, name); //, tag);
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




