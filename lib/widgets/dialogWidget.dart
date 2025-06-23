// ignore_for_file: must_be_immutable, file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ShowAcListDialog extends StatefulWidget {
  ShowAcListDialog({super.key, required this.phoneNo, required this.mPin});
  String? phoneNo;
  String? mPin;

  @override
  State<ShowAcListDialog> createState() => _ShowAcListDialogState();
}

class _ShowAcListDialogState extends State<ShowAcListDialog> {
  var data;
  var bank_data;
  Future<void> depostNomine() async {
    // const url = 'https://restaurantapi.opentech4u.co.in/api';
    dialogModel.showLoading();
    var map = <String, dynamic>{};
    map['phone_no'] = widget.phoneNo;

    final response =
        await MasterModel.globalApiCall(1, '/get_all_cust_list', map);
    var dt = jsonDecode(response.body);

    if (response.statusCode == 200) {
      bank_data = dt['suc'] > 0 ? dt : 0;
      data = dt['suc'] > 0 ? dt : [];
    }
    dialogModel.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 262,
      child: SizedBox(
          width: double.maxFinite,
          child: FutureBuilder(
              future: depostNomine(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  dialogModel.showLoading();
                  return const Column();
                } else if (data['msg'] != 'No Data Found') {
                  dialogModel.dismissLoading();
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 1.0,
                      height: 1,
                    ),
                    shrinkWrap: true,
                    itemCount: data['msg']
                        .length, // Replace this with the actual number of items in your list
                    itemBuilder: (BuildContext context, int index) {
                      // Replace the following return statement with your custom list item widget
                      return ListTile(
                        title: Text(
                            '${data['msg'][index]['CUST_NAME']} (${data['msg'][index]['CUST_CD']})'),
                        onTap: () {
                          // Implement any actions you want to perform when tapping an item
                          Map dt = <String, dynamic>{};
                          dt['cust_id'] =
                              data['msg'][index]['CUST_CD'].toString();
                          dt['cust_name'] =
                              data['msg'][index]['CUST_NAME'].toString();
                          dt['bank_id'] = data['bank_id'];
                          Navigator.pop(context,
                              dt); // Closes the dialog when an item is tapped
                        },
                      );
                    },
                  );
                } else {
                  dialogModel.dismissLoading();
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No Data Found',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  );
                }
              })),
    );
  }
}

class ShowOtpDialog extends StatefulWidget {
  ShowOtpDialog({super.key, required this.phoneNo, required this.mPin});
  String? phoneNo;
  String? mPin;
  @override
  State<ShowOtpDialog> createState() => _ShowOtpDialogState();
}

class _ShowOtpDialogState extends State<ShowOtpDialog> {
  final formKey = GlobalKey<FormState>();
  final _userIdTEC = TextEditingController();
  bool? _isVisible;
  String? _otp;
  String? _enterOtp;
  // List<SimCard> _simCard = <SimCard>[];

  Future<void> SendOtp(phoneNo) async {
    var map = <String, dynamic>{};
    map['phone_no'] = phoneNo;
    var resDt = await MasterModel.globalApiCall(1, '/send_otp', map);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      setState(() {
        _otp = resDt['otp'].toString();
      });
      //print(_otp);
    }
  }

  Future<void> LoginProcess(mobileNo, pin, flag) async {
    var map = <String, dynamic>{};
    map['phone_no'] = mobileNo;
    map['pin'] = pin;
    var resDt = await MasterModel.globalApiCall(0, '/login', map);
    resDt = jsonDecode(resDt.body);
    // print(resDt['msg']);
    if (resDt['suc'] != 0) {
      // sharedPrefModel.removeUserData('phone_no');
      // sharedPrefModel.removeUserData('cust_id');
      if (flag == 0) {
        sharedPrefModel.setUserData('phone_no', mobileNo);
        sharedPrefModel.setUserData(
            'user_MainApp.textColor', resDt['msg']['USER_NAME']);
        sharedPrefModel.setUserData('cust_id', resDt['msg']['CUST_CD']);
      }
      sharedPrefModel.setUserData('lastLogin', resDt['msg']['LAST_LOGIN']);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) => Dashboard(
      //             navSlNo: 0,
      //           )),
      // );
    }
  }

  @override
  void initState() {
    _isVisible = true;
    // _simCard = widget.simList;
    super.initState();
  }

  @override
  void dispose() {
    _isVisible = true;
    _userIdTEC.dispose();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 262,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: _isVisible!,
                child: Column(
                  children: [
                    const Text(
                      'Enter Your Mobile Number',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                  ],
                ),
              ),
              Visibility(
                  visible: _isVisible! ? false : true,
                  child: Column(
                    children: [
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PinCodeTextField(
                        obscureText: true,
                        appContext: context,
                        length: 4,
                        keyboardType: TextInputType.phone,
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 200),
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            // borderRadius: BorderRadius.circular(5),
                            fieldHeight: 40,
                            fieldWidth: 35,
                            activeFillColor: Colors.white,
                            disabledColor: Colors.black),
                        onChanged: (val) {
                          // print(val);
                        },
                        onCompleted: (value) async {
                          setState(() {
                            _enterOtp = value.toString();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            SendOtp(_userIdTEC.text);
                          },
                          child: const Text('Resend OTP',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
              // Visibility(
              //   visible: _isVisible!,
              //   child: ElevatedButton(
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      _userIdTEC.text.length == 10) {
                    if (_isVisible!) {
                      SendOtp(_userIdTEC.text);
                      setState(() {
                        _isVisible = !_isVisible!;
                      });
                    } else {
                      if (_enterOtp == _otp) {
                        Map dt = <String, dynamic>{};
                        dt['flag'] = 1;
                        dt['phoneNo'] = _userIdTEC.text;
                        Navigator.pop(context, dt);
                        // LoginProcess(_userIdTEC.text, widget.mPin, 0);
                      }
                    }
                  } else {
                    dialogModel.showToast('Please Enter Correct Mobile Number');
                  }
                },
                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    // textStyle: const TextStyle(color: Colors.white),
                    minimumSize: const Size(150, 40)),
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
