import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/popup_item.dart';
import 'package:task_manager/models/popup_items.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/screens/add_screen.dart';
import 'package:task_manager/screens/search_screen.dart';
import 'package:task_manager/widgets/build_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.15,
        title: const Text(
          'Todos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          StreamBuilder<List<Task>>(
              stream: loadTask(),
              builder: (context, snapshot) {
                final tasks = snapshot.data;
                return IconButton(
                  onPressed: () async {
                    await showSearch(
                      context: context,
                      delegate: Search(
                        tasks!,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search, color: Colors.black),
                );
              }),
          PopupMenuButton<PopUpItem>(
            onSelected: (item) => onSelected(context, item),
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
            itemBuilder: (context) => [
              ...PopUpItems.itemFirst.map(buildItem).toList(),
            ],
          ),
        ],
      ),
      body: const BuildGridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreen(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  PopupMenuItem<PopUpItem> buildItem(PopUpItem item) => PopupMenuItem(
        value: item,
        child: Row(
          children: [
            Text(item.text),
            const SizedBox(width: 12),
            Icon(item.icon, color: Colors.black, size: 20),
          ],
        ),
      );

  void onSelected(BuildContext context, PopUpItem item) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100.0, 40.0, 0.0, 100.0),
      items: [
        ...PopUpItems.itemSecond.map(buildItem).toList(),
      ],
    );
  }

  Stream<List<Task>> loadTask() => FirebaseFirestore.instance
      .collection('notes')
      .snapshots()
      .map((snapshots) =>
          snapshots.docs.map((e) => Task.fromJson(e.data())).toList());
}
