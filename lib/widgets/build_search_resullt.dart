import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:task_manager/screens/edit_screen.dart';

import '../models/task.dart';

class BuildSearchResult extends StatefulWidget {
  final List<Task> tasks;
  const BuildSearchResult({super.key, required this.tasks});

  @override
  State<BuildSearchResult> createState() => _BuildSearchResultState();
}

class _BuildSearchResultState extends State<BuildSearchResult> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: widget.tasks.length,
        gridDelegate: SliverWovenGridDelegate.count(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          pattern: [
            const WovenGridTile(0.95),
            const WovenGridTile(
              7 / 8,
              crossAxisRatio: 0.9,
              alignment: AlignmentDirectional.centerEnd,
            ),
          ],
        ),
        itemBuilder: (BuildContext context, int index) {
          Task task = widget.tasks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    task: task,
                  ),
                ),
              );
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
