// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/deposit_list.dart';
import 'package:bseccs/pages/other_deposit_list.dart';
import 'package:bseccs/widgets/listTextWidget.dart';

class DepositDashboard extends StatefulWidget {
  const DepositDashboard({super.key});

  @override
  State<DepositDashboard> createState() => _DepositDashboardState();
}

class _DepositDashboardState extends State<DepositDashboard>
    with WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();
  final int _currentIndex = 0;
  var cust_cd;
  var bankId;

  @override
  void initState() {
    cust_cd = sharedPrefModel.getUserData('cust_id');
    bankId = sharedPrefModel.getUserData('bank_id');
    WidgetsBinding.instance.addObserver(this);
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
      // The app is being minimized
      // Add any cleanup code or exit logic here
      // For example, to exit the app:
      // exit(0);
    }
  }

  var data;
  Future<void> DepositTypeList() async {
    var map = <String, dynamic>{};
    map['cust_cd'] = cust_cd;
    map['bank_id'] = bankId;
    final response =
        await MasterModel.globalApiCall(1, '/deposit_type_list', map);
    var dt = jsonDecode(response.body);
    //print(dt);
    if (response.statusCode == 200) {
      data = dt['msg'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          elevation: 10,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: _themeModel.navLogoImage,
          actions: [
            IconButton(
                onPressed: () {
                  dialogModel.logOutDialog(context);
                },
                icon: const Icon(Icons.power_settings_new_rounded))
          ],
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: FutureBuilder(
          future: DepositTypeList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              dialogModel.showLoading();
              return const Column();
            } else {
              dialogModel.dismissLoading();
              return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemCount: data.length,
                  itemBuilder: (contex, index) => SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                if (data[index]['ACC_TYPE_CD'] == 3 ||
                                    data[index]['ACC_TYPE_CD'] == 4 ||
                                    data[index]['ACC_TYPE_CD'] == 5 ||
                                    data[index]['ACC_TYPE_CD'] == 6) {
                                  return DepositDtls(
                                      acc_num:
                                          data[index]['ACC_NUM'].toString(),
                                      acc_type:
                                          data[index]['ACC_TYPE_CD'].toString(),
                                      acc_name: data[index]['ACC_TYPE_DESC'],
                                      curr_bal: data[index]['PRN_AMT'] != null
                                          ? data[index]['PRN_AMT']
                                              .round()
                                              .toString()
                                          : '',
                                      bank_id: bankId,
                                      ac_flag:
                                          data[index]['AC_FLAG'].toString(),
                                      cust_cd: cust_cd);
                                } else {
                                  return DepositDtls(
                                      acc_num:
                                          data[index]['ACC_NUM'].toString(),
                                      acc_type:
                                          data[index]['ACC_TYPE_CD'].toString(),
                                      acc_name: data[index]['ACC_TYPE_DESC'],
                                      curr_bal: data[index]['BALANCE'] != null
                                          ? data[index]['BALANCE']
                                              .round()
                                              .toString()
                                          : '',
                                      bank_id: bankId,
                                      ac_flag:
                                          data[index]['AC_FLAG'].toString(),
                                      cust_cd: cust_cd);
                                }
                              }));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              height: 80,
                              // decoration: BoxDecoration(color: Colors.grey[300]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: (size.width - 60) * 0.7,
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]['ACC_TYPE_DESC'],
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                              softWrap: true,
                                              maxLines: 3,
                                            ),
                                            MyStFulListText(
                                              accNum: data[index]['ACC_NUM']
                                                  ?.toString(),
                                              ac_flag: data[index]['AC_FLAG']
                                                  .toString(),
                                              key: UniqueKey(),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: (size.width - 80) * 0.5,
                                      height: 50,
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 0, 3, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.currency_rupee_outlined,
                                            size: 11,
                                          ),
                                          Text(
                                            [3, 4, 5, 6].contains(
                                                    data[index]['ACC_TYPE_CD'])
                                                ? (data[index]['PRN_AMT']
                                                            as num?)
                                                        ?.round()
                                                        .toString() ??
                                                    ''
                                                : (data[index]['BALANCE']
                                                            as num?)
                                                        ?.round()
                                                        .toString() ??
                                                    '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 22,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 10, top: 4, right: 10, bottom: 4),
                            child: Divider(
                              thickness: 0.8,
                            ),
                          ),
                        ],
                      )));
            }
          }),
    );
  }
}
