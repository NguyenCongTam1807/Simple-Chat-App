import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String errorText)  {
  showDialog(context: context, builder: (ctx) {
    return AlertDialog(
      title: const Text("An error occured"),
      content: Text(errorText),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("OK"),
        )
      ],
    );
  });
}