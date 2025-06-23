// ignore_for_file: file_names, unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';

String url = MasterModel.BaseUrl.toString();

// ignore: must_be_immutable
class ForgotMPin extends StatefulWidget {
  ForgotMPin({Key? key, required this.phnumber}) : super(key: key);
  String phnumber;
  @override
  State<ForgotMPin> createState() => _ForgotMPinState();
}

class _ForgotMPinState extends State<ForgotMPin>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  late int _mPin;
  late int _confmPin;
  String phoneNo = sharedPrefModel.getUserData('phone_no').toString();

  @override
  void initState() {
    super.initState();
    // print(widget.acc_num);
    // print(widget.acc_type);
  }

  @override
  void dispose() {
    super.dispose();
  }

  var dt;
  Future<void> ResetPinSave() async {
    var map = <String, dynamic>{};

    map['phone_no'] = widget.phnumber;
    map['pin'] = _mPin.toString();
    // dialogHelper.showLoading('Loading');
    final response = await MasterModel.globalApiCall(1, '/set_pin', map);
    var resDt = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (resDt['suc'] > 0) {
        Navigator.pop(context);
        dialogModel.showToast('Successfully Updated!!');
      } else {
        dialogModel.showToast(dt['msg'].toString());
      }
      dialogModel.dismissLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // double c_width = MediaQuery.of(context).size.width * 1.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
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
                  const Center(
                    child: Text(
                      'Reset Your mPIN',
                      style: TextStyle(fontSize: 20),
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
                                // if (_mPin == _confmPin) {
                                ResetPinSave();
                                // } else {
                                //   dialogHelper.showToast(
                                //       'mPIN and Confirm mPIN does not match');
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 12.0,
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
