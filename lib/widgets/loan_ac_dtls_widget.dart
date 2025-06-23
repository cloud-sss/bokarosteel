// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/masterModel.dart';

class AccountDtls extends StatelessWidget {
  AccountDtls(
      {Key? key,
      required this.loanId,
      required this.accId,
      required this.bankId})
      : super(key: key);
  String? loanId;
  String? accId;
  String? bankId;

  var data;
  Future<void> loanAccDtls() async {
    var map = <String, dynamic>{};
    map['loan_id'] = loanId;
    map['acc_cd'] = accId;
    map['bank_id'] = bankId;

    final response = await MasterModel.globalApiCall(1, '/loan_acc_dtls', map);
    var dt = jsonDecode(response.body);

    if (response.statusCode == 200) {
      data = dt['msg'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: FutureBuilder(
          future: loanAccDtls(),
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
                                Text(data[index]['ACC_TYPE_DESC'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                                const Text('A/C No',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data[index]['LOAN_ID'].toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 15),
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
                                const Text('Customer ID',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(data[index]['MEMBER_ID'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                                const Text('Name',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(data[index]['CUST_NAME'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
                              ],
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     const Text(
                            //       'Period',
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 18),
                            //     ),
                            //     const SizedBox(
                            //       height: 8,
                            //     ),
                            //     Text('NA',
                            //         style: TextStyle(
                            //             color: Colors.grey[600], fontSize: 15))
                            //   ],
                            // )
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
                                const Text('Disbursement Date',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    DateFormat('dd MMM y')
                                        .format(DateTime.parse(
                                                data[index]['DISB_DT'])
                                            .add(const Duration(days: 1)))
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                                const Text('Disbursement Amount',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
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
                                        data[index]['DISB_AMT']
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                            color: Colors.grey[600],
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
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Rate',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data[index]['CURR_INTT_RATE']
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 15),
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           'Overdue Int. Rate',
                        //           style: TextStyle(
                        //               color: Colors.black, fontSize: 18),
                        //           // textAlign: TextAlign.right,
                        //         ),
                        //         const SizedBox(
                        //           height: 8,
                        //         ),
                        //         Text(
                        //           data[index]['OVD_INTT_RATE']
                        //               .toStringAsFixed(2),
                        //           style: TextStyle(
                        //               color: Colors.grey[600], fontSize: 15),
                        //           // textAlign: TextAlign.left,
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // ),
                        // const Padding(
                        //   padding: EdgeInsets.only(
                        //       left: 10, top: 8, right: 10, bottom: 8),
                        //   child: Divider(
                        //     thickness: 0.8,
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Installment No.',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(data[index]['INSTL_NO'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           'Installment Start Date',
                        //           style: TextStyle(
                        //               color: Colors.black, fontSize: 18),
                        //         ),
                        //         const SizedBox(
                        //           height: 8,
                        //         ),
                        //         Text(
                        //             DateFormat('d MMM y')
                        //                 .format(DateTime.parse(
                        //                         data[index]['INSTL_START_DT'])
                        //                     .add(const Duration(days: 1)))
                        //                 .toString(),
                        //             style: TextStyle(
                        //                 color: Colors.grey[600], fontSize: 15))
                        //       ],
                        //     )
                        //   ],
                        // ),
                        // const Padding(
                        //   padding: EdgeInsets.only(
                        //       left: 10, top: 8, right: 10, bottom: 8),
                        //   child: Divider(
                        //     thickness: 0.8,
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Closing Balance',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    (int.parse(data[index]['CURR_PRN']
                                                .toString()) +
                                            int.parse(data[index]['OVD_PRN']
                                                .toString()))
                                        .toStringAsFixed(2),
                                    // data[index]['CURR_INTT_RATE'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                                const Text(
                                  'Interest Balance',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    data[index]['CURR_INTT'].toString() !=
                                                'null' &&
                                            data[index]['OVD_INTT']
                                                    .toString() !=
                                                'null'
                                        ? (int.parse(data[index]['CURR_INTT']
                                                    .toString()) +
                                                int.parse(data[index]
                                                        ['OVD_INTT']
                                                    .toString()))
                                            .toStringAsFixed(2)
                                        : '0',
                                    // data[index]['CURR_INTT_RATE'].toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                                const Text('Interest Calculated Upto:',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    DateFormat('d MMM y')
                                        .format(DateTime.parse(data[index]
                                                ['LAST_INTT_CALC_DT'])
                                            .add(const Duration(days: 1)))
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 15))
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
                    );
                  });
            }
          }),
    );
  }
}
