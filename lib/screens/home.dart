// ignore_for_file: prefer_const_constructors, sort_child_properties_last


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/task_item.dart';
import '../screens/add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';

  // signout
  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  getUid() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('myTasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final todos = snapshot.data!.docs;
            todos.forEach((item) {
              // print(item['title']);
              // print(item['description']);
              print(item.id);
            });
            if (todos.length == 0) {
              return Center(
                child: Text(
                  'No Task, start by adding some',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) => TaskItem(
                title: todos[index]['title'],
                description: todos[index]['description'],
                time: (todos[index]['createdAt'] as Timestamp).toDate(),
                id: todos[index].id,
                userId: uid,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTask(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
