import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Widget buildCupertinoHeaderImage(BuildContext context) {
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Opacity(
          opacity: 0.7,
          child: ClipRRect( // Optional: adds rounded edges for iOS polish
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/ic_work_sheet_header.png',
              fit: BoxFit.fill, // Better for iOS aesthetics
            ),
          ),
        ),
      ),
    ),
  );
}
