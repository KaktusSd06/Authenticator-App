import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog{
  void showErrorDialog(BuildContext context,String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Закрити"),
            ),
          ],
        );
      },
    );
  }
}