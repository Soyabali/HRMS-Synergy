import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Needed for DottedBorder
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

Widget buildCupertinoProjectCard(BuildContext context, dynamic projectName) {
  return Align(
    alignment: Alignment.centerLeft,
    child: DottedBorder(
      color: CupertinoColors.systemGrey,
      strokeWidth: 1.0,
      dashPattern: [4, 2],
      borderType: BorderType.RRect,
      radius: const Radius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/workdetail.jpeg',
                height: 25,
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '$projectName',
                style: const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.label,
                  fontFamily: 'OpenSans',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
