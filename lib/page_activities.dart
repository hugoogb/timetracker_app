import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timetracker_app/custom_search_delegate.dart';
import 'package:timetracker_app/page_intervals.dart';
import 'package:timetracker_app/page_report.dart';
import 'package:timetracker_app/tree.dart' hide getTree;
// the old getTree()
import 'package:timetracker_app/requests.dart';
// has the new getTree() that sends an http request to the server
import 'package:timetracker_app/page_create_project.dart';
import 'package:timetracker_app/page_create_task.dart';

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
  static const int periodeRefresh = 500;
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    futureTree = getTree(id);
    _activateTimer();
    currentPageIndex = 0;
  }

  void _refresh() async {
    futureTree = getTree(id);
    setState(() {});
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
                snapshot.data!.root.name == "root"
                    ? "Home"
                    : snapshot.data!.root.name,
              ),
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      // method to show the search bar
                      showSearch(
                          context: context,
                          // delegate to customize the search bar
                          delegate: CustomSearchDelegate(snapshot.data!));
                    },
                    icon: const Icon(Icons.search)),
                IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      while (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      const PageActivities(0);
                    }),
                IconButton(
                    icon: const Icon(Icons.list_alt_sharp),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => const PageReport(),
                      ));
                    }),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (currentPageIndex == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateProject(id)));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateTask(id)));
                }
              },
              label: Text(
                  currentPageIndex == 0 ? "Create Project" : "Create Task"),
              icon: const Icon(Icons.add),
            ),
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.folder),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
              ],
            ),
            body: <Widget>[
              ListView.builder(
                  // it's like ListView.builder() but better because it includes a separator between items
                  padding: const EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.root.children.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sortedChildren = snapshot.data!.root.children
                      ..sort(((a, b) => a.name.compareTo(b.name)));
                    return _buildCardProject(sortedChildren[index]);
                  }),
              ListView.builder(
                  // it's like ListView.builder() but better because it includes a separator between items
                  padding: const EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.root.children.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sortedChildren = snapshot.data!.root.children
                      ..sort(((a, b) => a.name.compareTo(b.name)));
                    return _buildCardTask(sortedChildren[index]);
                  }),
            ][currentPageIndex],
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

  Widget _buildCardProject(Activity activity) {
    String strDuration =
        Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list
    // removes the microseconds part
    assert(activity is Project || activity is Task);
    if (activity is Project) {
      return Card(
        child: ListTile(
          iconColor: activity.activeChildren ? Colors.blue : Colors.grey,
          title: Text(activity.name),
          leading: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.folder),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text("Project: ${activity.name}"),
                                content: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Initial date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(activity.initialDate == null
                                            ? "null (Project not initialized)"
                                            : activity.initialDate
                                                .toString()
                                                .split('.')[0]),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Final date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(activity.finalDate == null
                                            ? "null (Project not initialized)"
                                            : activity.finalDate
                                                .toString()
                                                .split('.')[0]),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "ID: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${activity.id}"),
                                      ],
                                    ),
                                  ],
                                ));
                          });
                    },
                    icon: const Icon(Icons.info)),
              ]),
          trailing: Text(strDuration),
          onTap: () => _navigateDownActivities(activity.id),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildCardTask(Activity activity) {
    String strDuration =
        Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list
    // removes the microseconds part
    assert(activity is Project || activity is Task);
    if (activity is Task) {
      return Card(
        child: ListTile(
          iconColor: activity.active ? Colors.blue : Colors.grey,
          title: Text(
            activity.name,
          ),
          leading: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.task),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text("Task: ${activity.name}"),
                                content: Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Initial date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(activity.initialDate == null
                                            ? "null (Task not initialized)"
                                            : activity.initialDate
                                                .toString()
                                                .split('.')[0]),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "Final date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(activity.finalDate == null
                                            ? "null (Task not initialized)"
                                            : activity.finalDate
                                                .toString()
                                                .split('.')[0]),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        const Text(
                                          "ID: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${activity.id}"),
                                      ],
                                    ),
                                  ],
                                ));
                          });
                    },
                    icon: const Icon(Icons.info)),
              ]),
          trailing: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    strDuration,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (activity.active) {
                        stop(activity.id);
                        _refresh();
                      } else {
                        start(activity.id);
                        _refresh();
                      }
                    },
                    icon: Icon(
                      activity.active ? Icons.stop : Icons.play_arrow,
                    ))
              ]),
          onTap: () => _navigateDownIntervals(activity.id),
        ),
      );
    } else {
      return Container();
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
