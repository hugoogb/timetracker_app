import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timetracker_app/page_activities.dart';
import 'package:timetracker_app/tree.dart';

class CustomSearchDelegate extends SearchDelegate {
  final Tree data;
  CustomSearchDelegate(this.data);

  // To generate fake results when clicking on tag results
  Random random = Random();

// Demo list to show querying
  List<String> fakeSearchTerms = [
    "java",
    "c++",
    "C++",
    "Java",
    "Python",
    "SQL",
    "Dart",
    "IntelliJ"
  ];

  @override
  String get searchFieldLabel => "Search by tag";

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var tag in fakeSearchTerms) {
      if (tag.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(tag);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Card(
          child: ListTile(
            title: Text(result),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
// Search by tag redirects to a random Project or Task (no functionality) just to test it works
                builder: (context) => PageActivities(
                    random.nextInt(data.root.children.length) + 1),
              ));
            },
          ),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var tag in fakeSearchTerms) {
      if (tag.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(tag);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Card(
          child: ListTile(
            title: Text(result),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
// Search by tag redirects to a random Project or Task (no functionality) just to test it works
                builder: (context) => PageActivities(
                    random.nextInt(data.root.children.length) + 1),
              ));
            },
          ),
        );
      },
    );
  }
}
