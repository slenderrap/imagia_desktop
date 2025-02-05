import 'package:flutter/material.dart';

void showError(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Error",
          style: TextStyle(
            color: Color(0xFFD62728),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFD6D6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
            mensaje,
            style: const TextStyle(
              color: Color(0xFFD62728),
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK", style: TextStyle(color: Color(0xFFD62728))),
          ),
        ],
      );
    },
  );
}
