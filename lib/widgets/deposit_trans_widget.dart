// ignore_for_file: must_be_immutable, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/masterModel.dart';

class TransDtls extends StatelessWidget {
  TransDtls(
      {Key? key,
      required this.accNum,
      required this.accType,
      required this.bankId,
      // ignore: non_constant_identifier_names
      required this.ac_flag,
      required this.cust_cd})
      : super(key: key);
  String? accNum;
  String? accType;
  String? bankId;
  String? ac_flag;
  String? cust_cd;

  var data;
  Future<void> depositTransList() async {
    var map = <String, dynamic>{};
    map['acc_num'] = accNum;
    map['acc_type'] = accType;
    map['bank_id'] = bankId;
    map['AC_FLAG'] = ac_flag;
    map['cust_cd'] = cust_cd;
    // print(map);
    final response =
        await MasterModel.globalApiCall(1, '/deposit_tns_dtls', map);
    var dt = jsonDecode(response.body);
    // print(dt);

    if (response.statusCode == 200) {
      data = dt['msg'];
      // print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    // depositTransList();
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: depositTransList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column();
          } else if (data != 'No Data Found') {
            return ListView.builder(
                itemCount: data.length >= 15 ? 15 : data.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        // width: (size.width - 40) * 0.7,
                        height: 75,
                        // decoration: BoxDecoration(color: Colors.grey[300]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: Text(
                                  DateFormat('dd MMM y')
                                      .format(DateTime.parse(
                                          data[index]['TRANS_DT']))
                                      .toString(),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              width: (size.width - 40) * 0.59,
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data[index]['PARTICULARS'] ?? '',
                                    style: const TextStyle(fontSize: 15),
                                    softWrap: true,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: (size.width - 90) * 0.4,
                                height: 50,
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.currency_rupee_outlined,
                                      size: 15,
                                      color: data[index]['TRANS_TYPE'] != 'W'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    Text(
                                      data[index]['AMOUNT'].toStringAsFixed(2),
                                      style: TextStyle(
                                          color:
                                              data[index]['TRANS_TYPE'] != 'W'
                                                  ? Colors.green
                                                  : Colors.red),
                                    ),
                                    Icon(
                                      data[index]['TRANS_TYPE'] != 'W'
                                          ? Icons.add_rounded
                                          : Icons.remove,
                                      size: 15,
                                      color: data[index]['TRANS_TYPE'] != 'W'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ],
                                ))
                          ],
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
                  );
                });
          } else {
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
        });
  }
}
