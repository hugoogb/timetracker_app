import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timetracker_app/page_activities.dart';
import 'package:timetracker_app/tree.dart' as t hide getTree;
// to avoid collision with an Interval class in another library
import 'package:timetracker_app/requests.dart';

class PageIntervals extends StatefulWidget {
  final int id;

  const PageIntervals(this.id, {Key? key}) : super(key: key);

  @override
  State<PageIntervals> createState() => _PageIntervalsState();
}

class _PageIntervalsState extends State<PageIntervals> {
  late int id;
  late Future<t.Tree> futureTree;

  late Timer _timer;
  static const int periodeRefresh = 1500;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    futureTree = getTree(id);
    _activateTimer();
  }

  void _activateTimer() {
    _timer =
        Timer.periodic(const Duration(milliseconds: periodeRefresh), (Timer t) {
      futureTree = getTree(id);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<t.Tree>(
      future: futureTree,
      // this makes the tree of children, when available, go into snapshot.data
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          int numChildren = snapshot.data!.root.children.length;
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.root.name),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      while (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      const PageActivities(0);
                    }),
              ],
            ),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: numChildren,
              itemBuilder: (BuildContext context, int index) =>
                  _buildRow(snapshot.data!.root.children[index], index),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(t.Interval interval, int index) {
    String strDuration =
        Duration(seconds: interval.duration).toString().split('.').first;
    String strInitial = interval.initialDate.toString().split('.')[0];
    String strInitialDate = strInitial.split(' ')[0];
    String strInitialHour = strInitial.split(' ')[1];
    // this removes the microseconds part
    String strFinal = interval.finalDate.toString().split('.')[0];
    String strFinalDate = strFinal.split(' ')[0];
    String strFinalHour = strFinal.split(' ')[1];
    return Card(
      child: ListTile(
        title: Text(
          'From $strInitialDate at $strInitialHour to $strFinalDate at $strFinalHour',
        ),
        trailing: Text(
          strDuration,
        ),
      ),
    );
  }
}
