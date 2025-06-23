// ignore_for_file: unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/localAuthModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/rest_pin.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:bseccs/widgets/depositAcHolderWidget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();

  final int _currentIndex = 0;
  String phoneNo = sharedPrefModel.getUserData('phone_no').toString();
  int _isActiveBio =
      sharedPrefModel.getUserData('isActiveBio') != 'true' ? 0 : 1;
  var ProPic = sharedPrefModel.getUserData('proPic');
  dynamic defImgPath;
  String baseUrl = MasterModel.BaseUrl;
  var dt;
  var bankId;

  @override
  void initState() {
    bankId = sharedPrefModel.getUserData('bank_id');
    defImgPath = ProPic.toString() != 'null'
        ? NetworkImage(Uri.parse('$baseUrl/$ProPic').toString())
        : const AssetImage('assets/img_avatar.png');
    // ProfileDtls();
    WidgetsBinding.instance.addObserver(this);
    setState(() {});
    // print('here');
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      dialogModel.sessionTimeOut(context);
    }
  }

  Future<void> ProfileDtls() async {
    var map = <String, dynamic>{};
    map['phone_no'] = phoneNo;
    map['bank_id'] = bankId;
    final response = await MasterModel.globalApiCall(1, '/prof_dtls', map);

    if (response.statusCode == 200) {
      dt = jsonDecode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: _themeModel.navLogoImage,
          actions: [
            IconButton(
                onPressed: () {
                  dialogModel.logOutDialog(context);
                },
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: _themeModel.lightIconColor,
                ))
          ],
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: FutureBuilder(
              future: ProfileDtls(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column();
                } else if (dt != 'No Data Found') {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (dt?['suc'] == 1)
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1))
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: defImgPath, fit: BoxFit.cover)),
                              ),
                            if (dt?['suc'] == 1)
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 8, right: 10, bottom: 8),
                                child: Divider(
                                  thickness: 0.8,
                                ),
                              ),
                            if (dt?['suc'] == 1)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Profile',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 40,
                                            top: 8,
                                            right: 40,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          "Name: ${dt?['msg']['CUST_NAME'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "MS No. : ${dt?['msg']['CUST_CD'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "Phone No: ${dt?['msg']['PHONE'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "Email : ${dt?['msg']['EMAIL'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "Date of Birth: ${dt?['msg']?['D_O_BIRTH'] != null && dt?['msg']?['D_O_BIRTH'] != "" ? DateFormat('dd/MM/yyyy').format(DateTime.parse(dt!['msg']['D_O_BIRTH']).toLocal()) : ''}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "Address: ${dt?['msg']['PRESENT_ADDRESS'] ?? ''}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     const Text('Activate Biometric',
                                      //         style: TextStyle(
                                      //             fontSize: 20,
                                      //             fontWeight: FontWeight.w400)),
                                      //     ToggleSwitch(
                                      //       minWidth: 50.0,
                                      //       cornerRadius: 20.0,
                                      //       activeBgColors: [
                                      //         [Colors.red[800]!],
                                      //         [Colors.green[800]!]
                                      //       ],
                                      //       activeFgColor: Colors.white,
                                      //       inactiveBgColor: Colors.grey,
                                      //       inactiveFgColor: Colors.white,
                                      //       initialLabelIndex: _isActiveBio,
                                      //       totalSwitches: 2,
                                      //       labels: const ['No', 'Yes'],
                                      //       radiusStyle: true,
                                      //       onToggle: (index) async {
                                      //         print('switched to: $index');
                                      //         if (_isActiveBio != index) {
                                      //           final isAuthenticated =
                                      //               await LocalAuthModel
                                      //                   .authenticate();
                                      //           if (isAuthenticated) {
                                      //             dialogModel.dismissLoading();
                                      //             sharedPrefModel.setUserData(
                                      //                 'isActiveBio',
                                      //                 index! > 0
                                      //                     ? 'true'
                                      //                     : 'false');
                                      //             setState(() {
                                      //               _isActiveBio = index;
                                      //             });
                                      //           } else {
                                      //             dialogModel.dismissLoading();
                                      //             dialogModel.showToast(
                                      //                 'Biometric is not enabled or not exists.');
                                      //             setState(() {
                                      //               _isActiveBio =
                                      //                   index == 0 ? 1 : 0;
                                      //             });
                                      //           }
                                      //         }
                                      //         // print('switched to: $index');
                                      //       },
                                      //     ),
                                      //   ],
                                      // ),
                                      // const SizedBox(
                                      //   height: 40,
                                      // ),
                                      // Center(
                                      //   child: ElevatedButton(
                                      //     onPressed: () async {
                                      //       Navigator.push(context,
                                      //           MaterialPageRoute(builder:
                                      //               (BuildContext context) {
                                      //         return const ResetPin();
                                      //       }));
                                      //     },
                                      //     style: ElevatedButton.styleFrom(
                                      //         elevation: 12.0,
                                      //         textStyle: const TextStyle(
                                      //             color: Colors.white),
                                      //         minimumSize: const Size(150, 40)),
                                      //     child: const Text('Reset mPIN'),
                                      //   ),
                                      // ),
                                      DepositAccHolder(
                                        accNum: '1000',
                                        accType: '1000',
                                        bankId: bankId,
                                      )
                                    ]),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No Data Found',
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ]),
                              )
                          ],
                        );
                      });
                } else {
                  return const Column();
                }
              }),
        ),
      ),
    );
  }
}
