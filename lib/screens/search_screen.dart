import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

import 'package:task_manager/widgets/build_search_resullt.dart';

class Search extends SearchDelegate {
  final List<Task> tasks;

  Search(this.tasks);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> matchQuery = [];
    for (var item in tasks) {
      if (item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return BuildSearchResult(tasks: matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> matchQuery = [];
    for (var item in tasks) {
      if (item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return BuildSearchResult(tasks: matchQuery);
  }
}
