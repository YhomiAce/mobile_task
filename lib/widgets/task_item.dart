// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../screens/description.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime time;
  final String id;
  final String userId;
  const TaskItem(
      {required this.title,
      required this.description,
      required this.time,
      required this.id,
      required this.userId,
      super.key});

  deleteTask() async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('myTasks')
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DescriptionScreen.routeName, arguments: {
          'title': title,
          'description': description,
        });
      },
      child: Container(
        height: 90,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xff32a887),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    top: 10,
                  ),
                  child: Text(DateFormat.yMd().add_jm().format(time)),
                ),
              ],
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: deleteTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
