// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionViewModel {
  static viewTransaction(
      {required BuildContext context,
      required String trnId,
      required String trnDate,
      required String chqNo,
      required String chqDate,
      required String bankName}) {
    return showModalBottomSheet(
        context: context,
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
                              '''Upload Transaction Details''',
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Transaction ID:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(trnId)
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Transaction Date:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat('dd MMM y')
                                      .format(DateTime.parse(trnDate))
                                      .toString(),
                                  softWrap: true,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Cheque No.:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(chqNo)
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Cheque Date:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat('dd MMM y')
                                      .format(DateTime.parse(chqDate))
                                      .toString(),
                                  softWrap: true,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Bank Name:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(bankName)
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

// class TransactionViewWidget extends StatefulWidget {
//   TransactionViewWidget(
//       {super.key,
//       required this.trnId,
//       required this.trnDate,
//       required this.chqNo,
//       required this.chqDate,
//       required this.bankName});
//   String trnId;
//   String trnDate;
//   String chqNo;
//   String chqDate;
//   String bankName;

//   @override
//   State<TransactionViewWidget> createState() => _TransactionViewWidgetState();
// }

// class _TransactionViewWidgetState extends State<TransactionViewWidget> {
//   final ThemeModel _themeModel = ThemeModel();

//   viewTransaction(BuildContext context) {
//     return showModalBottomSheet(
//         context: context, builder: (BuildContext context) {
//           return Container(
//             height: 380,
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                 ),
//                 BoxShadow(
//                   color: Colors.grey.shade100,
//                   spreadRadius: -12.0,
//                   blurRadius: 12.0,
//                 ),
//               ],
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(15.0),
//                   topRight: Radius.circular(15.0)),
//             ),
//             child: Center(
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.maxFinite,
//                     decoration: const BoxDecoration(
//                         // color: Color.fromARGB(237, 9, 79, 159),
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20.0),
//                             topRight: Radius.circular(20.0))),
//                     child: const Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(10),
//                             child: Text(
//                               '''Upload Transaction Details''',
//                               style: TextStyle(
//                                   fontSize: 18.0, color: Colors.black),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.grey.shade600,
//                     height: 8.0,
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 10, right: 10),
//                   //   child: SizedBox(
//                   //     height: 280,
//                   //     child:
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return viewTransaction(context);
//   }
// }
