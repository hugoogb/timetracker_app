import 'package:flutter/material.dart';
import 'package:timetracker_app/page_intervals.dart';
import 'package:timetracker_app/page_report.dart';
import 'package:timetracker_app/tree.dart' as t;
// to avoid collision with an Interval class in another library

class PageActivities extends StatefulWidget {
  const PageActivities({super.key});

  @override
  State<PageActivities> createState() => _PageActivitiesState();
}

class _PageActivitiesState extends State<PageActivities> {
  late t.Tree tree;

  @override
  void initState() {
    super.initState();
    tree = t.getTree();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tree.root.name,
          style: const TextStyle(
            color: Colors.orange,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.home),
              color: Colors.orange,
              onPressed: () {}
              // TODO go home page = root
              ),
          IconButton(
              icon: const Icon(Icons.list_alt_sharp),
              color: Colors.orange,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (context) => const PageReport(),
                ));
              }),
          //TODO other actions
        ],
      ),
      body: ListView.separated(
        // it's like ListView.builder() but better
        // because it includes a separator between items
        padding: const EdgeInsets.all(16.0),
        itemCount: tree.root.children.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildCard(tree.root.children[index], index),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _buildCard(t.Activity activity, int index) {
    String strDuration =
        Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list
    // removes the microseconds part
    assert(activity is t.Project || activity is t.Task);
    if (activity is t.Project) {
      return Card(
        // color: const Color.fromRGBO(100, 100, 100, 1),
        color: Colors.orange,
        child: ListTile(
          title: Text(activity.name),
          trailing: Text(strDuration),
          onTap: () => {},
          // TODO, navigate down to show children tasks and projects
        ),
      );
    } else {
      // Task task = activity as Task;
      return Card(
        // color: const Color.fromRGBO(150, 150, 150, 1),
        color: Colors.orangeAccent,
        child: ListTile(
          title: Text(
            activity.name,
            style: const TextStyle(
              color: Color.fromRGBO(30, 30, 30, 1),
            ),
          ),
          trailing: Text(
            strDuration,
            style: const TextStyle(
              color: Color.fromRGBO(30, 30, 30, 1),
            ),
          ),
          onTap: () => _navigateDownToIntervals(index),
          onLongPress: () {},
          // TODO start/stop counting the time for this task
        ),
      );
    }
  }

  void _navigateDownToIntervals(int childId) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => const PageIntervals()));
  }
}
