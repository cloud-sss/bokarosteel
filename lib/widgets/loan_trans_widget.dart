// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/masterModel.dart';

class TransDtls extends StatelessWidget {
  TransDtls({Key? key, required this.LoanId, required this.bankId})
      : super(key: key);
  String? LoanId;
  String? bankId;

  var data;
  Future<void> LoanTransDtls() async {
    var map = <String, dynamic>{};
    map['loan_id'] = LoanId;
    map['bank_id'] = bankId;

    final response = await MasterModel.globalApiCall(1, '/loan_tns_dtls', map);
    var dt = jsonDecode(response.body);

    if (response.statusCode == 200) {
      data = dt['msg'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: LoanTransDtls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column();
          } else {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        // width: (size.width - 40) * 0.7,
                        height: 80,
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
                                      .format(DateTime.parse(data[index]
                                                  ['TRANS_DT']
                                              .toString())
                                          .add(const Duration(days: 1)))
                                      .toString(),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              width: (size.width - 40) * 0.59,
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data[index]['TRANS_TYPE'].toString(),
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
                                    Icon(Icons.currency_rupee_outlined,
                                        size: 15,
                                        color: data[index]['TRANS_FLAG']
                                                    .toString() ==
                                                'R'
                                            ? Colors.green
                                            : Colors.red),
                                    Text(
                                      (int.parse(data[index]['DISB_AMT']
                                                  .toString()) +
                                              int.parse(data[index]['PRN_RECOV']
                                                  .toString()) +
                                              int.parse(data[index]
                                                      ['INTT_RECOV']
                                                  .toString()) +
                                              int.parse(data[index]['INTT_CALC']
                                                  .toString()))
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: data[index]['TRANS_FLAG']
                                                      .toString() ==
                                                  'R'
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    Icon(
                                      data[index]['TRANS_FLAG'].toString() ==
                                              'R'
                                          ? Icons.add_rounded
                                          : Icons.remove,
                                      size: 15,
                                      color: data[index]['TRANS_FLAG']
                                                  .toString() ==
                                              'R'
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
          }
        });
  }
}
