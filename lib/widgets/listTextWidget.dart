// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';

class MyStFulListText extends StatefulWidget {
  MyStFulListText({super.key, required this.accNum, required this.ac_flag});
  String? accNum;
  String? ac_flag;

  @override
  State<MyStFulListText> createState() => _MyStFulListTextState();
}

class _MyStFulListTextState extends State<MyStFulListText> {
  String? _showAccNum;
  String? _ac_flag;
  String? _actualAccNum;
  bool _showAccNumFlag = false;

  @override
  void initState() {
    accNumGenerate();
    super.initState();
  }

  accNumGenerate() {
    _actualAccNum = widget.accNum.toString();
    _ac_flag = widget.ac_flag.toString();
    late String star = MasterModel.createStar(_actualAccNum!.length - 2);
    _showAccNum =
        _actualAccNum!.replaceRange(0, _actualAccNum!.length - 2, star);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.ac_flag.toString() == 'D') ...[
          Text(
            _showAccNumFlag ? widget.accNum.toString() : _showAccNum.toString(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showAccNumFlag = !_showAccNumFlag;
                });
              },
              icon: Icon(
                _showAccNumFlag
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: Colors.blue,
              ),
            ),
          ),
        ] else
          const SizedBox.shrink(),
      ],
    );
  }
}
