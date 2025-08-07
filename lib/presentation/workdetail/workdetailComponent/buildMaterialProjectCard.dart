import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

import '../../resources/app_text_style.dart';

Widget buildMaterialProjectCard(BuildContext context,String projectName,
) {
  return Align(
    alignment: Alignment.centerLeft,
    child: DottedBorder(
      color: Platform.isIOS ? CupertinoColors.systemGrey : Colors.grey,
      strokeWidth: 1.0,
      dashPattern: [4, 2],
      borderType: BorderType.RRect,
      radius: const Radius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/workdetail.jpeg',
                height: 25,
                width: 25,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                projectName,
                style: Platform.isIOS
                    ? const TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.label,
                  fontFamily: 'OpenSans',
                )
                    : AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
