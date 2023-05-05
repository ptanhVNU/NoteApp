import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String titleInput = " ";
  bool isLoading = false;
  File? _storedImage;
  String path = '';
  String fileName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.15,
        titleSpacing: 0,
        centerTitle: false,
        title: const Text(
          'Add',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final picker = ImagePicker();
              final results =
                  await picker.pickImage(source: ImageSource.gallery);
              if (results == null) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No file selected'),
                  ),
                );
                return;
              }
              path = results.path;
              setState(() {
                _storedImage = File(path);
              });
              fileName = results.name;
            },
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              await FirestoreService().addNote(
                title: _titleController.text,
                description: _descriptionController.text,
              );
              await StorageService().uploadFile(path, fileName);
              // xu ly up len firebase o day
              setState(() {
                isLoading = false;
              });
              if (!mounted) return;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.3)),
                        border: InputBorder.none,
                      ),
                      controller: _titleController,
                      onChanged: (val) {
                        titleInput = val;
                      },
                    ),
                    if (_storedImage != null)
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        height: 250.0,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  image: FileImage(_storedImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _storedImage = null;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    TextField(
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.3)),
                        border: InputBorder.none,
                      ),
                      controller: _descriptionController,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
