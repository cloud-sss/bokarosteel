// ignore_for_file: must_be_immutable, file_names

import 'dart:convert';

import 'package:bseccs/pages/rest_pin.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';

class DepositAccHolder extends StatelessWidget {
  DepositAccHolder(
      {Key? key,
      required this.accNum,
      required this.accType,
      required this.bankId})
      : super(key: key);
  String? accNum;
  String? accType;
  String? bankId;

  final ThemeModel _themeModel = ThemeModel();

  var data;
  Future<void> depostAccountHolder() async {
    // const url = 'https://restaurantapi.opentech4u.co.in/api';

    var map = <String, dynamic>{};
    map['acc_num'] = accNum;
    map['acc_type'] = accType;
    map['bank_id'] = bankId;
    map['cust_cd'] = sharedPrefModel.getUserData('cust_id');
    // print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_joint_holder', map);
    var dt = jsonDecode(response.body);
    // print(dt);

    if (response.statusCode == 200) {
      data = dt;
      // print(data);
    }
  }

  Future<void> depostNomine() async {
    var map = <String, dynamic>{};
    map['acc_num'] = accNum;
    map['acc_type'] = accType;
    map['bank_id'] = bankId;
    map['member_id'] = sharedPrefModel.getUserData('cust_id');
    // print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_nomine', map);
    var dt = jsonDecode(response.body);
    // print(dt);

    if (response.statusCode == 200) {
      data = dt;
      // print(data);
    }
  }

  showNomie(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Container(
            height: 380,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                ),
                BoxShadow(
                  color: Colors.grey.shade100,
                  spreadRadius: -12.0,
                  blurRadius: 12.0,
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(237, 9, 79, 159),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '''Nominee Details''',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade600,
                    height: 8.0,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 280,
                      child: FutureBuilder(
                          future: depostNomine(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Column();
                            } else {
                              return SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  // padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  itemCount: data['msg'] != 'No Data Found'
                                      ? data['msg'].length
                                      : 0,
                                  shrinkWrap: true,
                                  itemBuilder: (contex, index) => Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                  color: _themeModel
                                                      .lightIconTextColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                  data['msg'] !=
                                                              'No Data Found' &&
                                                          data['msg'].length > 0
                                                      ? data['msg'][index]
                                                              ['NOM_NAME']
                                                          .toString()
                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                  ))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Relation',
                                                  style: TextStyle(
                                                    color: _themeModel
                                                        .lightIconTextColor,
                                                    fontSize: 18,
                                                  )),
                                              Text(
                                                  data['msg'] !=
                                                              'No Data Found' &&
                                                          data['msg'].length > 0
                                                      ? data['msg'][index]
                                                              ['RELATION']
                                                          .toString()
                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 8,
                                            right: 0,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                          // color: Colors.grey.shade600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAccountHolder(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        builder: (BuildContext context) {
          return Container(
            height: 380,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                ),
                BoxShadow(
                  color: Colors.grey.shade100,
                  spreadRadius: -12.0,
                  blurRadius: 12.0,
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(237, 9, 79, 159),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '''Joint Holder's Details''',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade600,
                    height: 8.0,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 280,
                      child: FutureBuilder(
                          future: depostAccountHolder(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Column();
                            } else {
                              return SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  // padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  itemCount: data['msg'] != 'No Data Found'
                                      ? data['msg'].length
                                      : 0,
                                  shrinkWrap: true,
                                  itemBuilder: (contex, index) => Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                  color: _themeModel
                                                      .lightIconTextColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                  data['msg'] !=
                                                              'No Data Found' &&
                                                          data['msg'].length > 0
                                                      ? data['msg'][index]
                                                              ['ACC_HOLDER']
                                                          .toString()
                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                  ))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Relation',
                                                  style: TextStyle(
                                                    color: _themeModel
                                                        .lightIconTextColor,
                                                    fontSize: 18,
                                                  )),
                                              Text(
                                                  data['msg'] !=
                                                              'No Data Found' &&
                                                          data['msg'].length > 0
                                                      ? data['msg'][index]
                                                              ['RELATION']
                                                          .toString()
                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 8,
                                            right: 0,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                          // color: Colors.grey.shade600,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const ResetPin();
            }));
          },
          // onPressed: () {
          //   showAccountHolder(context);
          // },
          // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
          style: ElevatedButton.styleFrom(
            // backgroundColor: MainApp.primaryColor,
            elevation: 2.0,
            textStyle: const TextStyle(color: Colors.white),
            minimumSize: Size((MediaQuery.of(context).size.width / 3.5), 40),
          ),
          child: const Text('Reset Pin'),
        ),
        ElevatedButton(
          onPressed: () {
            showNomie(context);
          },
          // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
          style: ElevatedButton.styleFrom(
            // backgroundColor: MainApp.primaryColor,
            elevation: 2.0,
            textStyle: const TextStyle(color: Colors.white),
            minimumSize: Size((MediaQuery.of(context).size.width / 3.5), 40),
          ),
          child: const Text('Nominee'),
        ),
      ],
    );
  }
}
