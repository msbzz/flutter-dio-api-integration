import 'package:flutter/material.dart';
 
messageSnackBar({
  required BuildContext context,
  required String message,
  bool isError = true,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: (isError) ? Colors.red : Colors.green,
    action:null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}