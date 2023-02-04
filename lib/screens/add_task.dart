// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_final_fields


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/add-task';
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionCntroller = TextEditingController();

  saveTaskToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('myTasks')
        .doc(randomAlphaNumeric(10))
        .set({
      'title': _titleController.text,
      'description': _descriptionCntroller.text,
      'time': time.toString(),
      'createdAt': time
    });
    Fluttertoast.showToast(msg: 'Task added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Title',
                    ),
                    controller: _titleController,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Description',
                    ),
                    controller: _descriptionCntroller,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveTaskToFirebase,
                      child: Text(
                        'Create Task',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                        }
                        return Colors.purple;
                      })),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
