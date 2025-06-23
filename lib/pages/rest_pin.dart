// ignore_for_file: use_build_context_synchronously, unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPin extends StatefulWidget {
  const ResetPin({super.key});

  @override
  State<ResetPin> createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin>
    with SingleTickerProviderStateMixin {
  final ThemeModel _themeModel = ThemeModel();

  final int _currentIndex = 0;
  late int _oldmPin;
  late int _mPin;
  late int _confmPin;
  String phoneNo = sharedPrefModel.getUserData('phone_no').toString();

  @override
  void initState() {
    super.initState();
    // print(widget.acc_num);
    // print(widget.acc_type);
  }

  var dt;
  Future<void> ResetPinSave() async {
    var map = <String, dynamic>{};
    map['phone_no'] = phoneNo.toString();
    map['old_pin'] = _oldmPin.toString();
    map['pin'] = _mPin.toString();
    // dialogHelper.showLoading('Loading');
    // print('start');
    var response = await MasterModel.globalApiCall(1, '/reset_pin', map);
    response = jsonDecode(response.body);
    if (dt['suc'] > 0) {
      Navigator.pop(context);
      dialogModel.showToast('Successfully Updated!!');
    } else {
      dialogModel.showToast(dt['msg'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightPrimaryColor)),
      // drawer: const navigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Reset Your mPIN',
                      style: TextStyle(
                          fontSize: 20, color: _themeModel.lightIconTextColor),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Old mPIN:',
                            style: TextStyle(
                                color: _themeModel.lightIconTextColor,
                                letterSpacing: 2,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                          PinCodeTextField(
                            obscureText: true,
                            appContext: context,
                            length: 4,
                            keyboardType: TextInputType.phone,
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 200),
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                // borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 60,
                                activeFillColor: Colors.white,
                                disabledColor: Colors.black),
                            onChanged: (val) {
                              // print(val);
                            },
                            onCompleted: (value) {
                              setState(() {
                                _oldmPin = int.parse(value);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Enter mPIN:',
                            style: TextStyle(
                                color: _themeModel.lightIconTextColor,
                                letterSpacing: 2,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                          PinCodeTextField(
                            obscureText: true,
                            appContext: context,
                            length: 4,
                            keyboardType: TextInputType.phone,
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 200),
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                // borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 60,
                                activeFillColor: Colors.white,
                                disabledColor: Colors.black),
                            onChanged: (val) {
                              // print(val);
                            },
                            onCompleted: (value) {
                              setState(() {
                                _mPin = int.parse(value);
                              });
                              // print(value);
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Confirm mPIN:',
                            style: TextStyle(
                                color: _themeModel.lightIconTextColor,
                                letterSpacing: 2,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                          PinCodeTextField(
                            obscureText: true,
                            appContext: context,
                            length: 4,
                            keyboardType: TextInputType.phone,
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 200),
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                // borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 60,
                                activeFillColor: Colors.white,
                                disabledColor: Colors.black),
                            onChanged: (val) {
                              // print(val);
                            },
                            onCompleted: (value) {
                              setState(() {
                                _confmPin = int.parse(value);
                              });
                              // print(value);
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_mPin == _confmPin) {
                                  ResetPinSave();
                                } else {
                                  dialogModel.showToast(
                                      'mPIN and Confirm mPIN does not match');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _themeModel.lightPrimaryColor,
                                  elevation: 12.0,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  minimumSize: const Size(150, 40)),
                              child: const Text('Submit'),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      )),
                ])),
      ),
    );
  }
}
