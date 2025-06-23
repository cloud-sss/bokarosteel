// ignore_for_file: must_be_immutable, unused_field, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/widgets/depositAcHolderWidget.dart';

class AccountDtls extends StatelessWidget {
  AccountDtls(
      {Key? key,
      required this.accNum,
      required this.accType,
      required this.accTypeName,
      required this.bankId})
      : super(key: key);
  String? accNum;
  String? accType;
  String? accTypeName;
  String? bankId;

  final String _userName = sharedPrefModel.getUserData('user_name');

  final ThemeModel _themeModel = ThemeModel();
  var intt_val = 0;
  var mat_visible = false;
  var data;

  Future<void> depositAccDtls() async {
    // const url = 'https://restaurantapi.opentech4u.co.in/api';

    var map = <String, dynamic>{};
    map['acc_num'] = accNum;
    map['acc_type'] = accType;
    map['bank_id'] = bankId;
    // print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_dtls', map);
    var dt = jsonDecode(response.body);
    // print(dt);

    if (response.statusCode == 200) {
      data = dt['msg'];
      // print(data);
      if (accType == '6') {
        var op_dt = DateTime.parse(data[0]["OPENING_DT"].toString());
        var mat_dt = DateTime.parse(data[0]["MAT_DT"].toString());
        var sys_dt = DateTime.now();
        var period = int.parse(mat_dt.difference(op_dt).inDays.toString());
        var mapCal = <String, dynamic>{};
        mapCal['acc_type'] = accType;
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
        mat_visible = accType != '6' ? false : true;
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
      } else {
        intt_val = 0;
      }
    }
  }

  Future<void> depostNomine() async {
    // const url = 'https://restaurantapi.opentech4u.co.in/api';

    var map = <String, dynamic>{};
    map['acc_num'] = accNum;
    map['acc_type'] = accType;
    map['bank_id'] = bankId;
    map['member_id'] = sharedPrefModel.getUserData('cust_id');
    print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_nomine', map);
    var dt = jsonDecode(response.body);
    // print(dt);

    if (response.statusCode == 200) {
      data = dt['msg'];
      // print(data);
    }
  }

  final _headerStyle = const TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. It is also used to temporarily replace text in a process called greeking, which allows designers to consider the form of a webpage or publication, without the meaning of the text influencing the design.''';
  final _loremIpsum2 =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: FutureBuilder(
            future: depositAccDtls(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column();
              } else {
                return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('A/C Type',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(accTypeName.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.grey[600],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('A/C No',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    accNum.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.grey[600],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Customer ID',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    data[index]['CUST_CD']?.toString() ?? '',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.grey[600],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.grey[600],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Opening Date',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      DateFormat('d MMM y')
                                          .format(DateTime.parse(data[index]
                                                  ['OPENING_DT']
                                              .toString()))
                                          .toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.grey[600],
                                          fontSize: 15))
                                ],
                              )
                            ],
                          ),
                          if (accType.toString() == '6')
                            Column(
                              children: [
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
                                                data[index]['INSTL_AMT'] != null
                                                    ? data[index]['INSTL_AMT']
                                                        .toStringAsFixed(2)
                                                    : '0',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.grey[600],
                                                    fontSize: 15)),
                                          ],
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
                              ],
                            ),
                          if (accType.toString() == '6')
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Installment No',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        data[index]['INSTL_NO'] != null
                                            ? data[index]['INSTL_NO'].toString()
                                            : '0',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[600],
                                            fontSize: 15))
                                  ],
                                )
                              ],
                            ),
                          if (accType.toString() == '2' ||
                              accType.toString() == '3' ||
                              accType.toString() == '4' ||
                              accType.toString() == '5' ||
                              accType.toString() == '6' ||
                              accType.toString() == '11' ||
                              accType.toString() == '10' ||
                              accType.toString() == '14' ||
                              accType.toString() == '15' ||
                              accType.toString() == '16' ||
                              accType.toString() == '17')
                            Column(
                              children: [
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
                                                    .format(DateTime.parse(
                                                        data[index]['MAT_DT']
                                                            .toString()))
                                                    .toString()
                                                : 'NA',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[600],
                                                fontSize: 15)),
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
                              ],
                            ),
                          if (accType.toString() == '2' ||
                              accType.toString() == '3' ||
                              accType.toString() == '4' ||
                              accType.toString() == '5' ||
                              accType.toString() == '6' ||
                              accType.toString() == '11' ||
                              accType.toString() == '10' ||
                              accType.toString() == '14' ||
                              accType.toString() == '15' ||
                              accType.toString() == '16' ||
                              accType.toString() == '17')
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
                                            data[index]['DEP_PERIOD'] != null
                                                ? data[index]['DEP_PERIOD']
                                                    .toString()
                                                : '0',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[600],
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
                              ],
                            ),
                          if (accType.toString() == '2' ||
                              accType.toString() == '3' ||
                              accType.toString() == '4' ||
                              accType.toString() == '5' ||
                              accType.toString() == '6' ||
                              accType.toString() == '11' ||
                              accType.toString() == '10' ||
                              accType.toString() == '14' ||
                              accType.toString() == '15' ||
                              accType.toString() == '16' ||
                              accType.toString() == '17')
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
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[600],
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
                          Visibility(
                            visible: mat_visible,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Principal',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
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
                                            (data[index]['BALANCE'] ?? 0)
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey[600],
                                                fontSize: 15)),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: mat_visible,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 10, top: 8, right: 10, bottom: 8),
                              child: Divider(
                                thickness: 0.8,
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Text('Lock Mode',
                          //             style: TextStyle(
                          //                 color: Colors.black, fontSize: 18)),
                          //         const SizedBox(
                          //           height: 8,
                          //         ),
                          //         Text(data[index]['LOCK_MODE'].toString(),
                          //             style: TextStyle(
                          //                 color: Colors.grey[600],
                          //                 fontSize: 15))
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          // const Padding(
                          //   padding: EdgeInsets.only(
                          //       left: 10, top: 8, right: 10, bottom: 8),
                          //   child: Divider(
                          //     thickness: 0.8,
                          //   ),
                          // ),
                          // DepositAccHolder(
                          //   accNum: accNum,
                          //   accType: accType,
                          //   bankId: bankId,
                          // )
                        ],
                      );
                    });
              }
            }));
  }
}
