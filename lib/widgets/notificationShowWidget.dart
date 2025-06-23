// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ShowNotification extends StatelessWidget {
  ShowNotification({Key? key, required this.date, required this.narration}) : super(key: key);
  String? date;
  String? narration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      height: 300,
      // color: Colors.amber,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 65,
            width: double.maxFinite,
            decoration: const BoxDecoration(
                color: Color.fromARGB(237, 9, 79, 159),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    date.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              narration.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          )
        ]),
      ),
    );
  }
}