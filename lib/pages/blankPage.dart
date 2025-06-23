// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  BlankPage({super.key, required this.titleVal});
  String titleVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(titleVal),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            titleVal,
            style: const TextStyle(fontSize: 20),
          ))
        ],
      ),
    );
  }
}
