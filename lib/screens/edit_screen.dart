import 'package:flutter/material.dart';
import 'package:task_manager/services/firestore_service.dart';

import '../models/task.dart';

class EditScreen extends StatefulWidget {
  final Task task;
  const EditScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
    super.initState();
  }

  void _saveForm() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: _saveForm,
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0.15,
        title: const Text(
          'Edit',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              await FirestoreService().editTask(
                title: titleController.text,
                description: descriptionController.text,
                docId: widget.task.id,
              );

              setState(() {
                isLoading = false;
              });

              if (!mounted) return;
              Navigator.pop(context);
            },
            // save task then complete finish
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete task?'),
                  content:
                      const Text('Are you sure you want to remove everything'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirestoreService().deleteTask(widget.task.id);

                        if (!mounted) return;
                        // close the dialog
                        Navigator.pop(context);
                        //close the edit screen
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(18, 25, 18, 25),
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      textAlign: TextAlign.left,
                      maxLines: null,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      textAlign: TextAlign.left,
                      maxLines: null,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
