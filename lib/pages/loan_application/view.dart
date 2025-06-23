// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/loan_application/entry.dart';
import 'package:bseccs/pages/member_application/memb_pdf_view.dart';

class GenLoanApplicationView extends StatefulWidget {
  const GenLoanApplicationView({super.key});

  @override
  State<GenLoanApplicationView> createState() => _GenLoanApplicationViewState();
}

class _GenLoanApplicationViewState extends State<GenLoanApplicationView> {
  final ThemeModel _themeModel = ThemeModel();
  String cust_id = sharedPrefModel.getUserData('cust_id');
  String bankId = sharedPrefModel.getUserData('bank_id');
  var data;
  Future<void> GetMembFormDtls() async {
    var map = <String, dynamic>{};
    map['member_id'] = cust_id;
    var resDt =
        await MasterModel.globalApiCall(1, '/get_loan_application', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      data = resDt['msg'];
    } else {
      data = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Loan Application'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: GetMembFormDtls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // dialogModel.showLoading();
            return const Column();
          } else {
            // dialogModel.dismissLoading();
            if (data.length > 0) {
              return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  itemCount: data.length,
                  itemBuilder: (contex, index) => SingleChildScrollView(
                        child: Card(
                            child: _SampleCard(
                                sl_no: data[index]['SL_NO'].toString(),
                                rcpt_dt: data[index]['RECEIPT_DATE'].toString(),
                                loan_amt:
                                    data[index]['APPLY_LOAN_AMT'].toString(),
                                repaid_dt: data[index]['REPAID_DT'].toString(),
                                bankId: bankId)),
                      ));
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No data found.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return GenLoanApplicationEntry();
          }));
        },
        foregroundColor: _themeModel.lightIconColor,
        backgroundColor: _themeModel.lightPrimaryColor,
        // shape: customizations[index].$3,
        child: const Icon(
          Icons.post_add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard(
      {required this.sl_no,
      required this.rcpt_dt,
      required this.loan_amt,
      required this.repaid_dt,
      required this.bankId});
  final String sl_no;
  final String rcpt_dt;
  final String loan_amt;
  final String repaid_dt;
  final String bankId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 220,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Form Sl No.:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(sl_no)
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  'Receipt Date:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat('dd MMM y')
                      .format(DateTime.parse(rcpt_dt))
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
                  'Loan Amount:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(loan_amt)
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  'Repaid Upto:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat('dd MMM y')
                      .format(DateTime.parse(repaid_dt))
                      .toString(),
                  softWrap: true,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 8, right: 10, bottom: 8),
              child: Divider(
                thickness: 0.8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      tooltip: 'View Transaction',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return GenLoanApplicationEntry(
                            slNo: int.parse(sl_no),
                          );
                        }));
                      },
                    ),
                    const Text('View')
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      tooltip: 'View PDF',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return PdfViewerPage(
                            flag: 'G',
                            id: sl_no.toString(),
                            bankId: bankId,
                          );
                        }));
                      },
                    ),
                    const Text('View PDF')
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
