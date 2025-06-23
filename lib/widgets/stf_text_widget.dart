// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/pages/login.dart';

class StateFulTextWidget extends StatefulWidget {
  StateFulTextWidget({
    Key? key,
    required this.accNum,
  }) : super(key: key);
  String? accNum;

  @override
  State<StateFulTextWidget> createState() => _StateFulTextWidgetState();
}

class _StateFulTextWidgetState extends State<StateFulTextWidget> {
  String? _showAccNum;
  String? _actualAccNum;
  bool _showAccNumFlag = false;

  @override
  void initState() {
    accNumGenerate();
    super.initState();
  }

  accNumGenerate() {
    _actualAccNum = widget.accNum.toString();
    late String star = MasterModel.createStar(_actualAccNum!.length - 2);
    // print(_actualAccNum!.length - 2);
    _showAccNum =
        (_actualAccNum?.replaceRange(0, (_actualAccNum!.length - 2), star))
            .toString();
    // print(_showAccNum);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _showAccNumFlag ? widget.accNum.toString() : _showAccNum.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
              onPressed: (() {
                setState(() {
                  _showAccNumFlag = !_showAccNumFlag;
                });
              }),
              icon: Icon(
                _showAccNumFlag
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({super.key});

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  int secondsRemaining = 120;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        if (mounted) {
          setState(() {
            secondsRemaining--;
          });
        }
      } else {
        if (mounted) {
          sharedPrefModel.removeUserData('cust_id');
          sharedPrefModel.removeUserData('bank_id');
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const Login();
          }), (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    secondsRemaining = 120;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Your session will expire in $secondsRemaining seconds',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ));
  }
}
