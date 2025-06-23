// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_local_variable, unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/signup_otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final _userIdTEC = TextEditingController();
  final ThemeModel _themeModel = ThemeModel();
  var pacsList = [];
  String? phoneNo;
  var bankId = '';

  @override
  void initState() {
    super.initState();
    // getPacsList();
  }

  @override
  void dispose() {
    _userIdTEC.dispose();
    super.dispose();
  }

  // Future<void> getPacsList() async {
  //   var map = <String, dynamic>{};
  //   var resDt = await MasterModel.globalApiCall(1, '/get_bank_list', map);
  //   resDt = jsonDecode(resDt.body);
  //   if (resDt['suc'] > 0) {
  //     setState(() {
  //       pacsList = resDt['msg'];
  //     });
  //     // if (pacsList.isNotEmpty) {
  //     //   pacsList = pacsList
  //     //       .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
  //     //           value: e['BANK_ID'], child: Text(e['BANK_NAME'])))
  //     //       .cast<String>()
  //     //       .toList();
  //     // }
  //   } else {
  //     dialogModel.showToast("Something went wrong");
  //   }
  // }

  Future<void> checkUser(phoneNo, bank_id) async {
    var map = <String, dynamic>{};
    map['phone_no'] = phoneNo;
    // map['bank_id'] = bank_id;
    var hasAcc = await MasterModel.globalApiCall(1, '/has_acc', map);
    hasAcc = jsonDecode(hasAcc.body);
    // print(hasAcc);
    if (hasAcc['suc'] != 0) {
      if (hasAcc['msg']['HAS_ACC'] > 0) {
        dialogModel.showToast('Mobile no. already registered');
      } else {
        var resDt = await MasterModel.globalApiCall(1, '/chk_acc', map);
        // print(resDt);
        resDt = jsonDecode(resDt.body);
        // print(resDt);
        if (resDt['suc'] != 0) {
          if (resDt['msg']['CHKACC'] != 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return SignUpOtp(
                phoneNo: phoneNo.toString(),
                bankId: bank_id, // resDt['msg']['BANK_ID'].toString(),
              );
            }));
          } else {
            dialogModel.showToast(
                'This mobile no. is not registered with us. Please contact with Bank');
          }
        } else {
          if (resDt['msg'] == 'No Data Found') {
            dialogModel.showToast(
                'This mobile no. is not registered with us. Please contact with Bank');
          }
        }
      }
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
          child: Container(
              height: MediaQuery.of(context).size.height * 0.832,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 40,
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
                            'Enter Your Mobile Number',
                            style: TextStyle(
                              fontSize: 20,
                              // color: MainApp.textColor
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        if (phoneNo == null)
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // DropdownButtonFormField(
                                  //   decoration: const InputDecoration(
                                  //       label: Text(
                                  //         'Select Bank',
                                  //         style: TextStyle(color: Colors.black),
                                  //       ),
                                  //       border: OutlineInputBorder()),
                                  //   items: pacsList.map((e) {
                                  //     return DropdownMenuItem(
                                  //       value: e['BANK_ID'],
                                  //       child: Text(e['BANK_NAME']),
                                  //     );
                                  //   }).toList(),
                                  //   onChanged: (value) {
                                  //     // print(value);
                                  //     setState(() {
                                  //       bankId = value.toString();
                                  //     });
                                  //   },
                                  // ),
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                  TextFormField(
                                    controller: _userIdTEC,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Color.fromRGBO(62, 43, 100, 1),
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Your Phone Number";
                                      } else {
                                        if (value.toString().length > 10) {
                                          return "Phone number must have 10 digit";
                                        } else {
                                          return null;
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        checkUser(_userIdTEC.text, bankId);
                                      } else {
                                        dialogModel.showToast(
                                            'Please Enter Correct Mobile Number');
                                      }
                                    },
                                    // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                    style: ElevatedButton.styleFrom(
                                        // backgroundColor:
                                        //     MainApp.primaryColor,
                                        elevation: 12.0,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        minimumSize: const Size(150, 40)),
                                    child: const Text('Next'),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ])))),
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
