import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:job_posting/Compoentns/my_button.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class NewJobPage extends StatefulWidget {
  const NewJobPage({super.key});

  @override
  State<NewJobPage> createState() => _NewJobPageState();
}

class _NewJobPageState extends State<NewJobPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController applyLinkController = TextEditingController();

  DateTime lastDate = DateTime.now();
  File? selectedImage;
  String? uploadedImageUrl;
  bool isLoading = false; // Loading indicator state

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String> _uploadImageToStorage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('job_images/${DateTime.now()}.jpg');
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }

  Future<void> _postJob() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true; // Start loading
      });

      uploadedImageUrl = await _uploadImageToStorage(selectedImage!);

      final newJob = {
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'salary': salaryController.text.trim(),
        'lastDate': Timestamp.fromDate(lastDate),
        'imageUrl': uploadedImageUrl,
        'applyLink': applyLinkController.text.trim(),
      };

      await FirebaseFirestore.instance.collection('jobs').add(newJob);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post job: $e")),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.tertiary,
            title: const Text('Add New Job'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: titleController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 14),
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Title can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 10,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 14),
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Description can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: salaryController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 14),
                                labelText: 'Salary',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Salary can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: applyLinkController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 14),
                                labelText: 'Apply Link',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Apply Link can\'t be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Last Date',
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.all(
                                10,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(
                                  15,
                                ),
                              ),
                              height: 55,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Pick a time',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      DatePicker.showDateTimePicker(
                                        context,
                                        onConfirm: (time) {
                                          setState(() {
                                            lastDate = time;
                                          });
                                        },
                                      );
                                    },
                                    child: Text(
                                      DateFormat('dd-MM-yyyy hh:mm a')
                                          .format(lastDate),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                child: selectedImage == null
                                    ? Center(
                                        child: Text(
                                          'Tap to select image',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  MyButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await _postJob();
                        // Todo newTodo = Todo(
                        //   title: titleController.text.trim(),
                        //   details: detailsController.text.trim(),
                        //   dateTime: DateTime.now(),
                        //   scheduledTime: scheduledTime,
                        // );

                        // Navigator.pop(context);
                      }
                    },
                    title: 'ADD',
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) // Overlay loading indicator
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
