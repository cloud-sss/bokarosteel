// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_build_context_synchronously, unused_local_variable, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/login.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpSetPin extends StatefulWidget {
  SignUpSetPin(
      {super.key,
      required this.phone_no,
      required this.bankId,
      required this.userName,
      required this.castCd});
  String phone_no;
  String bankId;
  String? userName;
  String? castCd;

  @override
  State<SignUpSetPin> createState() => _SignUpSetPinState();
}

class _SignUpSetPinState extends State<SignUpSetPin> {
  late int _mPin;
  late int _confmPin;
  final ThemeModel _themeModel = ThemeModel();

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 1.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Image(
            image: AssetImage('assets/bokarosteel.png'),
            height: 50,
            width: 50,
          ),
        ),
        title: const Text(
          'SynergicMobile',
          style: TextStyle(
              color: Color.fromARGB(244, 0, 128, 128),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.832,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return const Login();
                                  }), (route) => false);
                                },
                                icon: const Icon(Icons.arrow_back),
                                // color: MainApp.textColor,
                              ),
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 40,
                                    height:
                                        1.2, //line height 150% of actual height
                                    // color: MainApp.textColor,
                                    letterSpacing: 2,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(
                                            2.0, 2.0), //position of shadow
                                        blurRadius:
                                            6.0, //blur intensity of shadow
                                        color: Colors.grey.shade400.withOpacity(
                                            0.8), //color of shadow with opacity
                                      ),
                                      //add more shadow with different position offset here
                                    ]),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          const Center(
                            child: Text(
                              'Set Your mPIN',
                              style: TextStyle(
                                fontSize: 20,
                                // color: MainApp.textColor
                              ),
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
                                  const Text(
                                    'Enter mPIN:',
                                    style: TextStyle(
                                        // color: MainApp.textColor,
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
                                  const Text(
                                    'Confirm mPIN:',
                                    style: TextStyle(
                                        // color: MainApp.textColor,
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
                                          var map = <String, dynamic>{};
                                          map['user_id'] =
                                              widget.phone_no.toString();
                                          map['bank_id'] =
                                              widget.bankId.toString();
                                          map['pin'] = _mPin.toString();
                                          map['userName'] =
                                              widget.userName.toString();
                                          map['custCd'] =
                                              widget.castCd.toString();
                                          var res_dt =
                                              await MasterModel.globalApiCall(
                                                  1, '/save_user', map);
                                          res_dt = jsonDecode(res_dt.body);
                                          // ignore: unrelated_type_equality_checks
                                          if (res_dt['suc'] > 0) {
                                            sharedPrefModel.setUserData(
                                                'phone_no', widget.phone_no);
                                            sharedPrefModel.setUserData(
                                                'bank_id', widget.bankId);
                                            sharedPrefModel.setUserData(
                                                'user_name',
                                                widget.userName.toString());
                                            sharedPrefModel.setUserData(
                                                'cust_id',
                                                widget.castCd.toString());
                                            Navigator.pushAndRemoveUntil(
                                                context, MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                              return const Login();
                                            }), (route) => false);
                                          }
                                        } else {
                                          dialogModel.showToast(
                                              'mPIN and Confirm mPIN does not match');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          // backgroundColor:
                                          //     MainApp.primaryColor,
                                          elevation: 12.0,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          minimumSize: const Size(150, 40)),
                                      child: const Text('Submit'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )),
                        ])))
          ])),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade200,
        height: 50,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              'Version: 1.0',
              style: TextStyle(color: Colors.black54, fontSize: 10),
            )),
            Flexible(
              child: Center(
                child: Text(
                  'Copyright © ${DateFormat('y').format(DateTime.now()).toString()} Synergic Softek Solutions Pvt. Ltd. All Rights Reserved.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
