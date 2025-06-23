// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/loan_list.dart';
import 'package:bseccs/widgets/listTextWidget.dart';
import 'package:bseccs/widgets/navDrawWidget.dart';

class LoanDashboard extends StatefulWidget {
  const LoanDashboard({super.key});

  @override
  State<LoanDashboard> createState() => _LoanDashboardState();
}

class _LoanDashboardState extends State<LoanDashboard>
    with WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();
  var data;
  var cust_cd;
  var bank_id;
  @override
  void initState() {
    cust_cd = sharedPrefModel.getUserData('cust_id');
    bank_id = sharedPrefModel.getUserData('bank_id');
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
    }
  }

  Future<void> LoanTypeList() async {
    var map = <String, dynamic>{};
    map['cust_cd'] = cust_cd;
    map['bank_id'] = bank_id;

    final response = await MasterModel.globalApiCall(1, '/loan_type_list', map);
    var dt = jsonDecode(response.body);
    if (response.statusCode == 200) {
      data = dt['msg'];
    }
    //print(data);
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
        drawer: navigationDrawer(),
        body: FutureBuilder(
            future: LoanTypeList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column();
              } else if (data != 'No Data Found') {
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
                                  return LoanDtls(
                                    accNum: data[index]['ACC_CD'].toString(),
                                    acctype:
                                        data[index]['ACC_TYPE_DESC'].toString(),
                                    loanId: data[index]['LOAN_ID'].toString(),
                                    prinAmt: data[index]
                                            ['A.CURR_PRN_AMT+A.OVD_PRN_AMT']
                                        .toString(),
                                    intAmt: data[index]
                                            ['A.CURR_INTT+A.OVD_INTT']
                                        .toString(),
                                    bankId: bank_id,
                                  );
                                }));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                // width: (size.width - 40) * 0.7,
                                height: 106,
                                // decoration: BoxDecoration(color: Colors.grey[300]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: (size.width - 40) * 0.6,
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 0, 0),
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index]['ACC_TYPE_DESC']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                softWrap: true,
                                                maxLines: 3,
                                              ),
                                              MyStFulListText(
                                                accNum: data[index]['LOAN_ID']
                                                    .toString(),
                                                ac_flag: 'D',
                                                key: UniqueKey(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: (size.width - 90) * 0.5,
                                        height: 50,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 15,
                                            ),
                                            Text(
                                              int.parse(data[index][
                                                          'A.CURR_PRN_AMT+A.OVD_PRN_AMT']
                                                      .toString())
                                                  .toStringAsFixed(2),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 25,
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
                                  left: 10, top: 8, right: 10, bottom: 8),
                              child: Divider(
                                thickness: 0.8,
                              ),
                            ),
                          ],
                        )));
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'No Data Found',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                );
              }
            }));
  }
}
