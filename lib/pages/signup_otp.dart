// ignore_for_file: must_be_immutable, use_build_context_synchronously, unused_field, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/signup_setup_pin.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpOtp extends StatefulWidget {
  SignUpOtp({super.key, required this.phoneNo, required this.bankId});
  String? phoneNo;
  String? bankId;

  @override
  State<SignUpOtp> createState() => _SignUpOtpState();
}

class _SignUpOtpState extends State<SignUpOtp> {
  String? _userName;
  String? _castCd;
  String? _otp;
  String? _Enterotp;
  final ThemeModel _themeModel = ThemeModel();

  // FOR TIMER //
  int secondsRemaining = 20;
  bool enableResend = false;
  bool enableOtpText = true;
  late Timer timer;
  // END //

  @override
  void initState() {
    super.initState();
    SendOtp(callRe: false);
    initiateOtpReTimer();
  }

  @override
  void dispose() {
    super.dispose();
    enableResend = false;
    enableOtpText = true;
  }

  initiateOtpReTimer() {
    if (enableOtpText) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsRemaining != 0) {
          if (mounted) {
            setState(() {
              secondsRemaining--;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              enableResend = true;
              enableOtpText = false;
            });
          }
        }
      });
    }
  }

  Future<void> SendOtp({callRe = false}) async {
    var map = <String, dynamic>{};
    map['phone_no'] = widget.phoneNo;
    var resDt = await MasterModel.globalApiCall(1, '/send_otp', map);
    try {
      resDt = jsonDecode(resDt.body);
      // print(resDt);
      if (resDt['suc'] > 0) {
        setState(() {
          _otp = resDt['otp'].toString();
          if (callRe) {
            secondsRemaining = 10;
            enableResend = false;
            enableOtpText = true;
          }
        });
        // if (callRe) initiateOtpReTimer();
      } else {
        dialogModel.showToast(resDt['msg'].toString());
      }
    } catch (err) {
      print(err);
      dialogModel.showToast("Something went wrong. Please try again later");
    }
  }

  Future<void> getUserDtls() async {
    var map = <String, dynamic>{};
    map['phone_no'] = widget.phoneNo;
    map['bank_id'] = widget.bankId;
    var resDt = await MasterModel.globalApiCall(1, '/prof_dtls', map);
    resDt = jsonDecode(resDt.body);
    // print(resDt);
    if (resDt['suc'] != 0) {
      setState(() {
        _userName = resDt['msg']['CUST_NAME'].toString();
        _castCd = resDt['msg']['CUST_CD'].toString();
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SignUpSetPin(
          phone_no: widget.phoneNo.toString(),
          bankId: widget.bankId.toString(),
          userName: _userName.toString(),
          castCd: _castCd.toString(),
        );
      }));
    } else {
      dialogModel.showToast(resDt['msg'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 1.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Image(
            image: AssetImage('assets/sss-logo.png'),
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
          child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.832,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                            // color: MainApp.textColor,
                          ),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 40,
                                height: 1.2, //line height 150% of actual height
                                // color: MainApp.textColor,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(
                                        2.0, 2.0), //position of shadow
                                    blurRadius: 6.0, //blur intensity of shadow
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
                          'Enter OTP',
                          style: TextStyle(
                            fontSize: 20,
                            //  color: MainApp.textColor
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'OTP is send to ${widget.phoneNo}',
                          style: const TextStyle(
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              PinCodeTextField(
                                obscureText: false,
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
                                    _Enterotp = value;
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
                                    if (_Enterotp == _otp) {
                                      getUserDtls();
                                    } else {
                                      dialogModel.showToast(
                                          'Please Enter Correct OTP');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor:
                                      //     MainApp.primaryColor,
                                      elevation: 12.0,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      minimumSize: const Size(150, 40)),
                                  child: const Text('Verify'),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Visibility(
                                visible: enableOtpText,
                                child: Center(
                                  child: Text(
                                    'Wait $secondsRemaining seconds',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible: enableResend,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        SendOtp(callRe: true);
                                      },
                                      child: const Text('Resend OTP',
                                          style: TextStyle(
                                            fontSize: 20,
                                            // color: MainApp.textColor
                                          )),
                                    ),
                                  )),
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
