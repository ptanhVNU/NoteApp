import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:task_manager/screens/edit_screen.dart';

import '../models/task.dart';

class BuildGridView extends StatefulWidget {
  const BuildGridView({
    super.key,
    // required this.tasks,
  });

  @override
  State<BuildGridView> createState() => _BuildGridViewState();
}

class _BuildGridViewState extends State<BuildGridView> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('notes').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
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
                  // Parse snapshot get from Firebase into Task Model
                  Task task = Task.fromSnapshot(
                    snapshot.data!.docs[index],
                  );
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/box_empty.png'),
              const SizedBox(height: 15),
              const Text(
                'Empty',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        );
      },
    );
  }
}
