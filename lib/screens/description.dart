// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionScreen extends StatelessWidget {
  static const routeName = '/description';
  DescriptionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routeParam = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text(routeParam['title']),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                routeParam['title'],
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                routeParam['description'],
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Text(routeParam['description'])
          ],
        ),
      ),
    );
  }
}
