// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/widgets/depositAcHolderWidget.dart';
import 'package:bseccs/widgets/stf_text_widget.dart';

class OtherDepositList extends StatefulWidget {
  OtherDepositList(
      {super.key,
      required this.acc_num,
      required this.acc_type,
      required this.acc_name,
      required this.curr_bal,
      required this.bank_id});
  String? acc_num;
  String? acc_type;
  String? acc_name;
  String? curr_bal;
  String? bank_id;

  @override
  State<OtherDepositList> createState() => _OtherDepositListState();
}

class _OtherDepositListState extends State<OtherDepositList>
    with WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();
  String? bankId;
  String? _userName;
  String? _memberId;
  var intt_val = 0;
  var data;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    bankId = sharedPrefModel.getUserData('bank_id');
    _userName = sharedPrefModel.getUserData('user_name');
    _memberId = sharedPrefModel.getUserData('cust_id');
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

  Future<void> depositAccDtls() async {
    // const url = 'https://restaurantapi.opentech4u.co.in/api';

    var map = <String, dynamic>{};
    map['acc_num'] = widget.acc_num;
    map['acc_type'] = widget.acc_type;
    map['bank_id'] = bankId;
    // print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_dtls', map);
    var dt = jsonDecode(response.body);
    print(dt);

    if (response.statusCode == 200) {
      data = dt['msg'];
      var op_dt = DateTime.parse(data[0]["OPENING_DT"].toString());
      var mat_dt = DateTime.parse(data[0]["MAT_DT"].toString());
      var sys_dt = DateTime.now();
      var period = int.parse(mat_dt.difference(op_dt).inDays.toString());
      var mapCal = <String, dynamic>{};
      mapCal['acc_type'] = widget.acc_type;
      mapCal['prn_amt'] = data[0]['BALANCE'].toString();
      mapCal['sys_dt'] = sys_dt.toString();
      mapCal['intt_type'] = data[0]["INTT_TRF_TYPE"].toString();
      mapCal['period'] = period.toString();
      mapCal['intt_rate'] = data[0]['INTT_RT'].toString();
      mapCal['bank_id'] = bankId;
      var int_cal_dt =
          await MasterModel.globalApiCall(1, '/td_emi_calculator', mapCal);
      int_cal_dt = jsonDecode(int_cal_dt.body);
      // print(int_cal_dt['msg']);
      if (int_cal_dt['suc'].toString() != '0') {
        // setState(() {
        if (data[0]["INTT_TRF_TYPE"].toString() != 'O') {
          intt_val = int_cal_dt['msg']['RES'];
        } else {
          intt_val = int.parse(int_cal_dt['msg']['RES'].toString()) +
              int.parse(data[0]['BALANCE'].toString());
        }
        // });
      }
      // print(data);
    }
  }

  Future<void> depostNomine() async {
    // const url = 'https://restaurantapi.opentech4u.co.in/api';

    var map = <String, dynamic>{};
    map['acc_num'] = widget.acc_num;
    map['acc_type'] = widget.acc_type;
    map['bank_id'] = bankId;
    map['member_id'] = _memberId;
    // print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_nomine', map);
    var dt = jsonDecode(response.body);
    // print(dt);

    if (response.statusCode == 200) {
      data = dt['msg'];
      // print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 1.0;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: FutureBuilder(
          future: depositAccDtls(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column();
            } else {
              return Column(
                children: [
                  Container(
                    height: 150,
                    width: cWidth,
                    decoration:
                        BoxDecoration(color: _themeModel.lightPrimaryColor),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 35, 35, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.acc_name.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  softWrap: true,
                                ),
                              ),
                              StateFulTextWidget(
                                  accNum: widget.acc_num.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Balance',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.currency_rupee_outlined,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    (double.tryParse(
                                                widget.curr_bal?.toString() ??
                                                    '0') ??
                                            0)
                                        .toStringAsFixed(2),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 256,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('A/C Type',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(widget.acc_name.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15))
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('A/C No',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          widget.acc_num.toString(),
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Customer ID',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          data[index]['CUST_CD'].toString(),
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 15),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Name',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            )),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(_userName.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15))
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Opening Date',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            DateFormat('d MMM y')
                                                .format(DateTime.parse(
                                                    data[index]['OPENING_DT']
                                                        .toString()))
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15))
                                      ],
                                    )
                                  ],
                                ),
                                if (widget.acc_type.toString() == '6')
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            top: 8,
                                            right: 10,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Installment amount',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          237, 9, 79, 159),
                                                      fontSize: 18)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.currency_rupee_sharp,
                                                    color: Colors.grey[600],
                                                    size: 16,
                                                  ),
                                                  Text(
                                                      data[index]['INSTL_AMT'] !=
                                                              null
                                                          ? data[index]
                                                                  ['INSTL_AMT']
                                                              .toStringAsFixed(
                                                                  2)
                                                          : '0',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 15)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            top: 8,
                                            right: 10,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (widget.acc_type.toString() == '6')
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Installment No',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                              data[index]['INSTL_NO'] != null
                                                  ? data[index]['INSTL_NO']
                                                      .toString()
                                                  : '0',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 15))
                                        ],
                                      )
                                    ],
                                  ),
                                if (widget.acc_type.toString() == '2' ||
                                    widget.acc_type.toString() == '3' ||
                                    widget.acc_type.toString() == '4' ||
                                    widget.acc_type.toString() == '5' ||
                                    widget.acc_type.toString() == '6' ||
                                    widget.acc_type.toString() == '11' ||
                                    widget.acc_type.toString() == '10' ||
                                    widget.acc_type.toString() == '14' ||
                                    widget.acc_type.toString() == '15' ||
                                    widget.acc_type.toString() == '16' ||
                                    widget.acc_type.toString() == '17')
                                  Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            top: 8,
                                            right: 10,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Maturity Date',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        237, 9, 79, 159),
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                  data[index]['MAT_DT'] != null
                                                      ? DateFormat('d MMM y')
                                                          .format(DateTime
                                                              .parse(data[index]
                                                                      ['MAT_DT']
                                                                  .toString()))
                                                          .toString()
                                                      : 'NA',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15)),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            top: 8,
                                            right: 10,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (widget.acc_type.toString() == '2' ||
                                    widget.acc_type.toString() == '3' ||
                                    widget.acc_type.toString() == '4' ||
                                    widget.acc_type.toString() == '5' ||
                                    widget.acc_type.toString() == '6' ||
                                    widget.acc_type.toString() == '11' ||
                                    widget.acc_type.toString() == '10' ||
                                    widget.acc_type.toString() == '14' ||
                                    widget.acc_type.toString() == '15' ||
                                    widget.acc_type.toString() == '16' ||
                                    widget.acc_type.toString() == '17')
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Period',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          237, 9, 79, 159),
                                                      fontSize: 18)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                  data[index]['DEP_PERIOD'] !=
                                                          null
                                                      ? data[index]
                                                              ['DEP_PERIOD']
                                                          .toString()
                                                      : '0',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15))
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            top: 8,
                                            right: 10,
                                            bottom: 8),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (widget.acc_type.toString() == '2' ||
                                    widget.acc_type.toString() == '3' ||
                                    widget.acc_type.toString() == '4' ||
                                    widget.acc_type.toString() == '5' ||
                                    widget.acc_type.toString() == '6' ||
                                    widget.acc_type.toString() == '11' ||
                                    widget.acc_type.toString() == '10' ||
                                    widget.acc_type.toString() == '14' ||
                                    widget.acc_type.toString() == '15' ||
                                    widget.acc_type.toString() == '16' ||
                                    widget.acc_type.toString() == '17')
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Interest Rate',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          237, 9, 79, 159),
                                                      fontSize: 18)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                  data[index]['INTT_RT'] != null
                                                      ? data[index]['INTT_RT']
                                                          .toStringAsFixed(2)
                                                      : '0',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 15))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Principal',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_sharp,
                                              color: Colors.grey[600],
                                              size: 16,
                                            ),
                                            Text(
                                                (double.tryParse(data[index]
                                                                    ['BALANCE']
                                                                ?.toString() ??
                                                            '0') ??
                                                        0)
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Maturity Value',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_sharp,
                                              color: Colors.grey[600],
                                              size: 16,
                                            ),
                                            Text(intt_val.toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Lock Mode',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18)),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            data[index]['LOCK_MODE'].toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 15))
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  child: Divider(
                                    thickness: 0.8,
                                  ),
                                ),
                                DepositAccHolder(
                                  accNum: widget.acc_num,
                                  accType: widget.acc_type,
                                  bankId: bankId,
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                ],
              );
            }
          }),
      // body: Column(
      //   children: [
      //     Container(
      //       height: 150,
      //       width: c_width,
      //       decoration: BoxDecoration(color: _themeModel.lightPrimaryColor),
      //       child: Padding(
      //         padding: const EdgeInsets.fromLTRB(20, 35, 35, 15),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Expanded(
      //                   child: Text(
      //                     widget.acc_name.toString(),
      //                     style: const TextStyle(
      //                         color: Colors.white, fontSize: 18),
      //                     softWrap: true,
      //                   ),
      //                 ),
      //                 StateFulTextWidget(accNum: widget.acc_num.toString()),
      //               ],
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 const Text(
      //                   'Balance',
      //                   style: TextStyle(color: Colors.white, fontSize: 20),
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.end,
      //                   children: [
      //                     const Icon(
      //                       Icons.currency_rupee_outlined,
      //                       size: 15,
      //                       color: Colors.white,
      //                     ),
      //                     Text(
      //                       int.parse(widget.curr_bal.toString())
      //                           .toStringAsFixed(2),
      //                       style: const TextStyle(
      //                           color: Colors.white, fontSize: 20),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Padding(
      //         padding: const EdgeInsets.only(right: 20, left: 20),
      //         child: FutureBuilder(
      //             future: depositAccDtls(),
      //             builder: (context, snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 return Column();
      //               } else {
      //                 return ListView.builder(
      //                     itemCount: 1,
      //                     itemBuilder: (context, index) {
      //                       return Column(
      //                         children: [
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text('A/C Type',
      //                                       style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontSize: 18)),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Text(widget.acc_name.toString(),
      //                                       style: TextStyle(
      //                                           color: Colors.grey[600],
      //                                           fontSize: 15))
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text('A/C No',
      //                                       style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontSize: 18)),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Text(
      //                                     widget.acc_num.toString(),
      //                                     style: TextStyle(
      //                                         color: Colors.grey[600],
      //                                         fontSize: 15),
      //                                   )
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           Row(
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text(
      //                                     'Customer ID',
      //                                     style: TextStyle(
      //                                         color: Colors.black,
      //                                         fontSize: 18),
      //                                   ),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Text(
      //                                     data[index]['CUST_CD'].toString(),
      //                                     style: TextStyle(
      //                                         color: Colors.grey[600],
      //                                         fontSize: 15),
      //                                   )
      //                                 ],
      //                               )
      //                             ],
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text('Name',
      //                                       style: TextStyle(
      //                                         color: Colors.black,
      //                                         fontSize: 18,
      //                                       )),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Text(_userName.toString(),
      //                                       style: TextStyle(
      //                                           color: Colors.grey[600],
      //                                           fontSize: 15))
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   const Text(
      //                                     'Opening Date',
      //                                     style: TextStyle(
      //                                         color: Colors.black,
      //                                         fontSize: 18),
      //                                   ),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Text(
      //                                       DateFormat('d MMM y')
      //                                           .format(DateTime.parse(
      //                                               data[index]['OPENING_DT']
      //                                                   .toString()))
      //                                           .toString(),
      //                                       style: TextStyle(
      //                                           color: Colors.grey[600],
      //                                           fontSize: 15))
      //                                 ],
      //                               )
      //                             ],
      //                           ),
      //                           if (widget.acc_type.toString() == '6')
      //                             Column(
      //                               children: [
      //                                 const Padding(
      //                                   padding: EdgeInsets.only(
      //                                       left: 10,
      //                                       top: 8,
      //                                       right: 10,
      //                                       bottom: 8),
      //                                   child: Divider(
      //                                     thickness: 0.8,
      //                                   ),
      //                                 ),
      //                                 Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceBetween,
      //                                   children: [
      //                                     Column(
      //                                       crossAxisAlignment:
      //                                           CrossAxisAlignment.start,
      //                                       children: [
      //                                         const Text('Installment amount',
      //                                             style: TextStyle(
      //                                                 color: Color.fromARGB(
      //                                                     237, 9, 79, 159),
      //                                                 fontSize: 18)),
      //                                         const SizedBox(
      //                                           height: 8,
      //                                         ),
      //                                         Row(
      //                                           children: [
      //                                             Icon(
      //                                               Icons.currency_rupee_sharp,
      //                                               color: Colors.grey[600],
      //                                               size: 16,
      //                                             ),
      //                                             Text(
      //                                                 data[index]['INSTL_AMT'] !=
      //                                                         null
      //                                                     ? data[index]
      //                                                             ['INSTL_AMT']
      //                                                         .toStringAsFixed(
      //                                                             2)
      //                                                     : '0',
      //                                                 style: TextStyle(
      //                                                     color:
      //                                                         Colors.grey[600],
      //                                                     fontSize: 15)),
      //                                           ],
      //                                         )
      //                                       ],
      //                                     ),
      //                                   ],
      //                                 ),
      //                                 const Padding(
      //                                   padding: EdgeInsets.only(
      //                                       left: 10,
      //                                       top: 8,
      //                                       right: 10,
      //                                       bottom: 8),
      //                                   child: Divider(
      //                                     thickness: 0.8,
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           if (widget.acc_type.toString() == '6')
      //                             Row(
      //                               children: [
      //                                 Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.start,
      //                                   children: [
      //                                     Text(
      //                                       'Installment No',
      //                                       style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontSize: 18),
      //                                     ),
      //                                     const SizedBox(
      //                                       height: 8,
      //                                     ),
      //                                     Text(
      //                                         data[index]['INSTL_NO'] != null
      //                                             ? data[index]['INSTL_NO']
      //                                                 .toString()
      //                                             : '0',
      //                                         style: TextStyle(
      //                                             color: Colors.grey[600],
      //                                             fontSize: 15))
      //                                   ],
      //                                 )
      //                               ],
      //                             ),
      //                           if (widget.acc_type.toString() == '2' ||
      //                               widget.acc_type.toString() == '3' ||
      //                               widget.acc_type.toString() == '4' ||
      //                               widget.acc_type.toString() == '5' ||
      //                               widget.acc_type.toString() == '6' ||
      //                               widget.acc_type.toString() == '11' ||
      //                               widget.acc_type.toString() == '10' ||
      //                               widget.acc_type.toString() == '14' ||
      //                               widget.acc_type.toString() == '15' ||
      //                               widget.acc_type.toString() == '16' ||
      //                               widget.acc_type.toString() == '17')
      //                             Column(
      //                               children: [
      //                                 const Padding(
      //                                   padding: EdgeInsets.only(
      //                                       left: 10,
      //                                       top: 8,
      //                                       right: 10,
      //                                       bottom: 8),
      //                                   child: Divider(
      //                                     thickness: 0.8,
      //                                   ),
      //                                 ),
      //                                 Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceBetween,
      //                                   children: [
      //                                     Column(
      //                                       crossAxisAlignment:
      //                                           CrossAxisAlignment.start,
      //                                       children: [
      //                                         const Text(
      //                                           'Maturity Date',
      //                                           style: TextStyle(
      //                                               color: Color.fromARGB(
      //                                                   237, 9, 79, 159),
      //                                               fontSize: 18),
      //                                         ),
      //                                         const SizedBox(
      //                                           height: 8,
      //                                         ),
      //                                         Text(
      //                                             data[index]['MAT_DT'] != null
      //                                                 ? DateFormat('d MMM y')
      //                                                     .format(DateTime
      //                                                         .parse(data[index]
      //                                                                 ['MAT_DT']
      //                                                             .toString()))
      //                                                     .toString()
      //                                                 : 'NA',
      //                                             style: TextStyle(
      //                                                 color: Colors.grey[600],
      //                                                 fontSize: 15)),
      //                                       ],
      //                                     )
      //                                   ],
      //                                 ),
      //                                 const Padding(
      //                                   padding: EdgeInsets.only(
      //                                       left: 10,
      //                                       top: 8,
      //                                       right: 10,
      //                                       bottom: 8),
      //                                   child: Divider(
      //                                     thickness: 0.8,
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           if (widget.acc_type.toString() == '2' ||
      //                               widget.acc_type.toString() == '3' ||
      //                               widget.acc_type.toString() == '4' ||
      //                               widget.acc_type.toString() == '5' ||
      //                               widget.acc_type.toString() == '6' ||
      //                               widget.acc_type.toString() == '11' ||
      //                               widget.acc_type.toString() == '10' ||
      //                               widget.acc_type.toString() == '14' ||
      //                               widget.acc_type.toString() == '15' ||
      //                               widget.acc_type.toString() == '16' ||
      //                               widget.acc_type.toString() == '17')
      //                             Column(
      //                               children: [
      //                                 Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceBetween,
      //                                   children: [
      //                                     Column(
      //                                       crossAxisAlignment:
      //                                           CrossAxisAlignment.start,
      //                                       children: [
      //                                         const Text('Period',
      //                                             style: TextStyle(
      //                                                 color: Color.fromARGB(
      //                                                     237, 9, 79, 159),
      //                                                 fontSize: 18)),
      //                                         const SizedBox(
      //                                           height: 8,
      //                                         ),
      //                                         Text(
      //                                             data[index]['DEP_PERIOD'] !=
      //                                                     null
      //                                                 ? data[index]
      //                                                         ['DEP_PERIOD']
      //                                                     .toString()
      //                                                 : '0',
      //                                             style: TextStyle(
      //                                                 color: Colors.grey[600],
      //                                                 fontSize: 15))
      //                                       ],
      //                                     ),
      //                                   ],
      //                                 ),
      //                                 const Padding(
      //                                   padding: EdgeInsets.only(
      //                                       left: 10,
      //                                       top: 8,
      //                                       right: 10,
      //                                       bottom: 8),
      //                                   child: Divider(
      //                                     thickness: 0.8,
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           if (widget.acc_type.toString() == '2' ||
      //                               widget.acc_type.toString() == '3' ||
      //                               widget.acc_type.toString() == '4' ||
      //                               widget.acc_type.toString() == '5' ||
      //                               widget.acc_type.toString() == '6' ||
      //                               widget.acc_type.toString() == '11' ||
      //                               widget.acc_type.toString() == '10' ||
      //                               widget.acc_type.toString() == '14' ||
      //                               widget.acc_type.toString() == '15' ||
      //                               widget.acc_type.toString() == '16' ||
      //                               widget.acc_type.toString() == '17')
      //                             Column(
      //                               children: [
      //                                 Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceBetween,
      //                                   children: [
      //                                     Column(
      //                                       crossAxisAlignment:
      //                                           CrossAxisAlignment.start,
      //                                       children: [
      //                                         const Text('Interest Rate',
      //                                             style: TextStyle(
      //                                                 color: Color.fromARGB(
      //                                                     237, 9, 79, 159),
      //                                                 fontSize: 18)),
      //                                         const SizedBox(
      //                                           height: 8,
      //                                         ),
      //                                         Text(
      //                                             data[index]['INTT_RT'] != null
      //                                                 ? data[index]['INTT_RT']
      //                                                     .toStringAsFixed(2)
      //                                                 : '0',
      //                                             style: TextStyle(
      //                                                 color: Colors.grey[600],
      //                                                 fontSize: 15))
      //                                       ],
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           Row(
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   const Text(
      //                                     'Principal',
      //                                     style: TextStyle(
      //                                         color: Colors.black,
      //                                         fontSize: 18),
      //                                   ),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Row(
      //                                     children: [
      //                                       Icon(
      //                                         Icons.currency_rupee_sharp,
      //                                         color: Colors.grey[600],
      //                                         size: 16,
      //                                       ),
      //                                       Text(
      //                                           data[index]['BALANCE']
      //                                               .toStringAsFixed(2),
      //                                           style: TextStyle(
      //                                               color: Colors.grey[600],
      //                                               fontSize: 15)),
      //                                     ],
      //                                   )
      //                                 ],
      //                               )
      //                             ],
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text('Lock Mode',
      //                                       style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontSize: 18)),
      //                                   const SizedBox(
      //                                     height: 8,
      //                                   ),
      //                                   Text(
      //                                       data[index]['LOCK_MODE'].toString(),
      //                                       style: TextStyle(
      //                                           color: Colors.grey[600],
      //                                           fontSize: 15))
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.only(
      //                                 left: 10, top: 8, right: 10, bottom: 8),
      //                             child: Divider(
      //                               thickness: 0.8,
      //                             ),
      //                           ),
      //                           DepositAccHolder(
      //                             accNum: widget.acc_num,
      //                             accType: widget.acc_type,
      //                             bankId: bankId,
      //                           )
      //                         ],
      //                       );
      //                     });
      //               }
      //             }))
      //   ],
      // ),
    );
  }
}
