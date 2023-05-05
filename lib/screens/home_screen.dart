import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/popup_item.dart';
import '../models/popup_items.dart';
import '../models/note.dart';
import 'add_screen.dart';
import 'search_screen.dart';
import '../widgets/build_grid_view.dart';

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
          'Notes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          StreamBuilder<List<Note>>(
              stream: loadNote(),
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

  Stream<List<Note>> loadNote() => FirebaseFirestore.instance
      .collection('notes')
      .snapshots()
      .map((snapshots) =>
          snapshots.docs.map((e) => Note.fromJson(e.data())).toList());
}
