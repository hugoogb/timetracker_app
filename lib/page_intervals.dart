import 'package:flutter/material.dart';
import 'package:timetracker_app/tree.dart' as t;
// to avoid collision with an Interval class in another library

class PageIntervals extends StatefulWidget {
  const PageIntervals({Key? key}) : super(key: key);

  @override
  State<PageIntervals> createState() => _PageIntervalsState();
}

class _PageIntervalsState extends State<PageIntervals> {
  late t.Tree tree;

  @override
  void initState() {
    super.initState();
    tree = t.getTreeTask();
    // the root is a task and the children its intervals
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
        leading: GestureDetector(
          onTap: () {
            // Navigate to the previous screen
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_sharp,
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
          //TODO other actions
        ],
      ),
      body: ListView.separated(
        // it's like ListView.builder() but better because it includes a
        // separator between items
        padding: const EdgeInsets.all(16.0),
        itemCount: tree.root.children.length, // number of intervals
        itemBuilder: (BuildContext context, int index) =>
            _buildRow(tree.root.children[index], index),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget _buildRow(t.Interval interval, int index) {
    String strDuration =
        Duration(seconds: interval.duration).toString().split('.').first;
    String strInitialDate = interval.initialDate.toString().split('.')[0];
    // this removes the microseconds part
    String strFinalDate = interval.finalDate.toString().split('.')[0];
    return Card(
      color: Colors.orangeAccent,
      child: ListTile(
        title: Text(
          'from $strInitialDate to $strFinalDate',
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
      ),
    );
  }
}
