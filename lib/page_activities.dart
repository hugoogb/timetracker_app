import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timetracker_app/page_intervals.dart';
import 'package:timetracker_app/page_report.dart';
import 'package:timetracker_app/tree.dart' hide getTree;
// the old getTree()
import 'package:timetracker_app/requests.dart';
// has the new getTree() that sends an http request to the server

class PageActivities extends StatefulWidget {
  final int id;

  const PageActivities(this.id, {Key? key}) : super(key: key);

  @override
  State<PageActivities> createState() => _PageActivitiesState();
}

class _PageActivitiesState extends State<PageActivities> {
  late int id;
  late Future<Tree> futureTree;

  late Timer _timer;
  static const int periodeRefresh = 6;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    futureTree = getTree(id);
    _activateTimer();
  }

  void _refresh() async {
    futureTree = getTree(id);
    setState(() {});
  }

  void _activateTimer() {
    _timer = Timer.periodic(const Duration(seconds: periodeRefresh), (Timer t) {
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

  // future with listview
  // https://medium.com/nonstopio/flutter-future-builder-with-list-view-builder-d7212314e8c9
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      // this makes the tree of children, when available, go into snapshot.data
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                snapshot.data!.root.name,
                style: const TextStyle(
                  color: Colors.orange,
                ),
              ),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.home),
                    color: Colors.orange,
                    onPressed: () {
                      while (Navigator.of(context).canPop()) {
                        print("pop");
                        Navigator.of(context).pop();
                      }
                      const PageActivities(0);
                    }),
                IconButton(
                    icon: const Icon(Icons.list_alt_sharp),
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => const PageReport(),
                      ));
                    }),
                //TODO: other actions
              ],
            ),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.children.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildCard(snapshot.data!.root.children[index], index),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildCard(Activity activity, int index) {
    String strDuration =
        Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list
    // removes the microseconds part
    assert(activity is Project || activity is Task);
    if (activity is Project) {
      return Card(
        // color: const Color.fromRGBO(100, 100, 100, 1),
        color: Colors.orange,
        child: ListTile(
          title: Text(activity.name),
          trailing: Text(strDuration),
          onTap: () => _navigateDownActivities(activity.id),
          // TODO: navigate down to show children tasks and projects
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
          onTap: () => _navigateDownIntervals(activity.id),
          onLongPress: () {
            if ((activity as Task).active) {
              stop(activity.id);
              _refresh();
            } else {
              start(activity.id);
              _refresh();
            }
          },
        ),
      );
    }
  }

  void _navigateDownActivities(int childId) {
    _timer.cancel();
    // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageActivities(childId),
    ))
        .then((var value) {
      _activateTimer();
      _refresh();
    });
  }

  void _navigateDownIntervals(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageIntervals(childId),
    ))
        .then((var value) {
      _activateTimer();
      _refresh();
    });
    //https://stackoverflow.com/questions/49830553/how-to-go-back-and-refresh-the-previous-page-in-flutter?noredirect=1&lq=1
  }
}
