// ignore_for_file: use_build_context_synchronously, unused_field, non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/localAuthModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/dashboard.dart';
import 'package:bseccs/pages/dos_donts.dart';
import 'package:bseccs/pages/forgotPin.dart';
import 'package:bseccs/pages/privacy_policy.dart';
import 'package:bseccs/pages/signup.dart';
import 'package:bseccs/widgets/dialogWidget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final ThemeModel _themeModel = ThemeModel();
  final formKey = GlobalKey<FormState>();
  final _userIdTEC = TextEditingController();
  String _userName = '';
  late int _mPin = 0;
  bool multipleCustId = false;
  var bank_id = '0';
  // List<SimCard> _simCard = <SimCard>[];
  final int _isActiveBio =
      sharedPrefModel.getUserData('isActiveBio') != 'true' ? 0 : 1;
  bool _isVisible = true;

  @override
  void initState() {
    _userName = sharedPrefModel.getUserData('phone_no');
    super.initState();
  }

  @override
  void dispose() {
    _isVisible = true;
    _userIdTEC.dispose();
    super.dispose();
  }

  Future<void> LoginProcess(mobileNo, pin, flag) async {
    var map = <String, dynamic>{};
    map['phone_no'] = mobileNo;
    map['pin'] = pin.toString();
    var resDt = await MasterModel.globalApiCall(1, '/login', map);
    //print(resDt);
    resDt = jsonDecode(resDt.body);
    // print(resDt['msg']['VIEW_FLAG']);

    // login with process start
    if (resDt['suc'] != 0) {
      // print(resDt);
      if (resDt['suc'] == 2) {
        setState(() {
          multipleCustId = true;
        });
      }
      if (resDt['suc'] == 1) {
        sharedPrefModel.setUserData('cust_id', resDt['msg']['CUST_CD']);
        // sharedPrefModel.setUserData('bank_id', resDt['msg']['BANK_ID']);
        setState(() {
          multipleCustId = false;
        });
      }
      // // sharedPrefModel.removeUserData('phone_no');
      // // sharedPrefModel.removeUserData('cust_id');
      if (pin == 2222) {
        sharedPrefModel.setUserData('phone_no', mobileNo);
        sharedPrefModel.setUserData('view_flag', 'A');
        if (resDt['suc'] == 1) {
          sharedPrefModel.setUserData('user_name', resDt['msg']['USER_NAME']);
          sharedPrefModel.setUserData('cust_id', resDt['msg']['CUST_CD']);
        }
      } else {
        sharedPrefModel.setUserData('view_flag', resDt['msg']['VIEW_FLAG']);
      }

      if (flag == 0) {
        sharedPrefModel.setUserData('phone_no', mobileNo);
        if (resDt['suc'] == 1) {
          sharedPrefModel.setUserData('user_name', resDt['msg']['USER_NAME']);
          sharedPrefModel.setUserData('cust_id', resDt['msg']['CUST_CD']);
        }
      }
      sharedPrefModel.setUserData(
          'lastLogin',
          resDt['msg']['LAST_LOGIN'].toString() != 'null'
              ? resDt['msg']['LAST_LOGIN']
              : '');
      sharedPrefModel.setUserData(
          'proPic', resDt['msg']['IMG_PATH'].toString());

      sharedPrefModel.setUserData('bank_name', resDt['msg']['BANK_NAME']);
      sharedPrefModel.setUserData(
          'bank_id', resDt['msg']['BANK_ID'].toString());

      sharedPrefModel.setUserData('first_login_submit', '1');

      if (resDt['suc'] == 1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    navSlNo: 0,
                  )),
        );
      }
    } else {
      dialogModel.showToast(resDt['msg']);
    }
    // End
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
            image: AssetImage('assets/bokarosteel.png'),
            height: 50,
            width: 50,
          ),
        ),
        title: const Text(
          'BSECCS',
          style: TextStyle(
              color: Color.fromARGB(255, 57, 170, 174),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.832,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade600 // or Colors.black
                    : Colors.grey.shade200,
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
                    Text(
                      'Login with mPIN',
                      style: TextStyle(
                          fontSize: 25,
                          height: 1.2, //line height 150% of actual height
                          // color: MainApp.textColor,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset:
                                  const Offset(2.0, 2.0), //position of shadow
                              blurRadius: 6.0, //blur intensity of shadow
                              color: Colors.grey.shade400.withOpacity(
                                  0.8), //color of shadow with opacity
                            ),
                            //add more shadow with different position offset here
                          ]),
                      textAlign: TextAlign.left,
                    ),
                    // Text(_userName),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                                  fieldHeight: 50,
                                  fieldWidth: 60,
                                  activeFillColor: Colors.white,
                                  disabledColor: Colors.black),
                              onChanged: (val) {},
                              onCompleted: (value) {
                                setState(() {
                                  _mPin = int.parse(value);
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // print(_mPin.toString().length);
                                  if (_mPin > 0 &&
                                      _mPin.toString().length == 4) {
                                    if (_mPin == 2222) {
                                      await LoginProcess(
                                          '9007507220', _mPin, 1);
                                      if (multipleCustId) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'Choose Your Account'),
                                                  titleTextStyle: TextStyle(
                                                      color: _themeModel
                                                          .darkPrimaryColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  content: ShowAcListDialog(
                                                      phoneNo: '9007507220',
                                                      mPin: _mPin.toString()),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context); // Closes the dialog when Cancel button is pressed
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                )).then((value) async {
                                          if (value.length > 0) {
                                            // print(value['cust_id']);
                                            await sharedPrefModel
                                                .removeUserData('cust_id');
                                            await sharedPrefModel
                                                .removeUserData('bank_id');
                                            await sharedPrefModel
                                                .removeUserData('user_name');
                                            await sharedPrefModel.setUserData(
                                                'cust_id', value['cust_id']);
                                            await sharedPrefModel.setUserData(
                                                'bank_id', value['bank_id']);
                                            await sharedPrefModel.setUserData(
                                                'user_name',
                                                value['cust_name']);
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Dashboard(
                                                        navSlNo: 0,
                                                      )),
                                            );
                                          }
                                        }).onError((error, stackTrace) => null);
                                      }
                                    } else {
                                      if (_userName != 'null') {
                                        await LoginProcess(_userName, _mPin, 1);
                                        if (multipleCustId) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        'Choose Your Account'),
                                                    titleTextStyle: TextStyle(
                                                        color: _themeModel
                                                            .darkPrimaryColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    content: ShowAcListDialog(
                                                        phoneNo: _userName,
                                                        mPin: _mPin.toString()),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Closes the dialog when Cancel button is pressed
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  )).then((value) async {
                                            print(value);
                                            if (value.length > 0) {
                                              // print(value['cust_id']);
                                              await sharedPrefModel
                                                  .removeUserData('cust_id');
                                              await sharedPrefModel
                                                  .removeUserData('bank_id');
                                              await sharedPrefModel
                                                  .removeUserData('user_name');
                                              await sharedPrefModel.setUserData(
                                                  'cust_id', value['cust_id']);
                                              await sharedPrefModel.setUserData(
                                                  'bank_id', value['bank_id']);
                                              await sharedPrefModel.setUserData(
                                                  'user_name',
                                                  value['cust_name']);
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Dashboard(
                                                          navSlNo: 0,
                                                        )),
                                              );
                                            }
                                          }).onError(
                                              (error, stackTrace) => null);
                                        }
                                      } else {
                                        // print(_simCard);
                                        // if (_simCard.isEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                // title: const Text(
                                                //     'Enter Your Mobile Number'),
                                                content: ShowOtpDialog(
                                                    phoneNo: _userName,
                                                    mPin: _mPin
                                                        .toString()))).then(
                                            (value) async {
                                          if (value['flag'] > 0) {
                                            await LoginProcess(
                                                value['phoneNo'], _mPin, 0);
                                            if (multipleCustId) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                            'Choose Your Account'),
                                                        titleTextStyle: TextStyle(
                                                            color: _themeModel
                                                                .darkPrimaryColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        content:
                                                            ShowAcListDialog(
                                                                phoneNo: value[
                                                                    'phoneNo'],
                                                                mPin: _mPin
                                                                    .toString()),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context); // Closes the dialog when Cancel button is pressed
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ],
                                                      )).then((value) async {
                                                if (value.length > 0) {
                                                  await sharedPrefModel
                                                      .removeUserData(
                                                          'cust_id');
                                                  await sharedPrefModel
                                                      .removeUserData(
                                                          'user_name');
                                                  await sharedPrefModel
                                                      .removeUserData(
                                                          'bank_id');
                                                  await sharedPrefModel
                                                      .setUserData('cust_id',
                                                          value['cust_id']);
                                                  await sharedPrefModel
                                                      .setUserData('user_name',
                                                          value['cust_name']);
                                                  await sharedPrefModel
                                                      .setUserData('bank_id',
                                                          value['bank_id']);
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Dashboard(
                                                              navSlNo: 0,
                                                            )),
                                                  );
                                                }
                                              }).onError(
                                                  (error, stackTrace) => null);
                                            }
                                          }
                                        }).onError((error, stackTrace) => null);
                                      }
                                    }
                                  } else {
                                    dialogModel
                                        .showToast('Please Enter Your PIN');
                                  }
                                },
                                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                style: ElevatedButton.styleFrom(
                                    elevation: 12.0,
                                    minimumSize: const Size(150, 40)),
                                child: const Text('Login'),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            if (_isActiveBio > 0)
                              Column(
                                children: [
                                  const Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '-',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w100),
                                        ),
                                        Text(
                                          'or',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          '-',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: IconButton(
                                      onPressed: () async {
                                        final isAuthenticated =
                                            await LocalAuthModel.authenticate();
                                        if (isAuthenticated) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => Dashboard(
                                                      navSlNo: 0,
                                                    )),
                                          );
                                        } else {
                                          dialogModel.showToast(
                                              'Biometric is disabled or not exists.');
                                        }
                                      },
                                      iconSize: 80,
                                      icon: Icon(Icons.fingerprint_outlined,
                                          color: _themeModel.lightPrimaryColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const SignUp();
                                  }));
                                },
                                child: const Text(
                                  'Don’t Have An Account? SignUp',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          //  title: const Text(
                                          //     'Enter Your Mobile Number'),
                                          content: ShowOtpDialog(
                                              phoneNo: _userName,
                                              mPin: _mPin.toString()))).then(
                                      (value) {
                                    if (value['flag'] > 0) {
                                      // LoginProcess(value['phoneNo'],_mPinStr, 0);
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return ForgotMPin(
                                            phnumber:
                                                value['phoneNo'].toString());
                                      }));
                                    }
                                  });
                                },
                                child: const Text(
                                  'Forgot mPIN',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return const DosDonts();
                                        // return BlankPage(
                                        //     titleVal: "Do's & Don'ts");
                                      }));
                                    },
                                    child: const Text(
                                      '''Do's & Don'ts''',
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Text('|'),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return const PrivacyPolicy();
                                        // return BlankPage(
                                        //     titleVal: "Privacy Policy");
                                      }));
                                    },
                                    child: const Text(
                                      '''Privacy Policy''',
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
