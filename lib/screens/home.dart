// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    print(userData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            height: 50,
            padding: EdgeInsets.only(
              top: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green,
            ),
            child: Text(
              "Welcome ${user!.email}",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: logout,
          ),
        ],
      )),
    );
  }
}
