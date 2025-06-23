// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:pdpeccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/models/transactionViewModel.dart';
import 'package:bseccs/pages/transaction/entry.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final ThemeModel _themeModel = ThemeModel();
  String cust_id = sharedPrefModel.getUserData('cust_id');
  var data;
  Future<void> TransactionList() async {
    var map = <String, dynamic>{};
    map['cust_id'] = cust_id;
    var resDt = await MasterModel.globalApiCall(1, '/transaction_upload', map);
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
        title: const Text('Upload Transaction'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: TransactionList(),
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
                          trn_id: data[index]['TRNS_ID'].toString(),
                          trn_dt: data[index]['TRNS_DT'].toString(),
                          chq_no: data[index]['CHQ_NO'].toString(),
                          chq_dt: data[index]['CHQ_DT'].toString(),
                          bank_name: data[index]['BANK_NAME'].toString(),
                        )),
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
            return TransactionEntry(trnId: '');
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
      {required this.trn_id,
      required this.trn_dt,
      required this.chq_no,
      required this.chq_dt,
      required this.bank_name});
  final String trn_id;
  final String trn_dt;
  final String chq_no;
  final String chq_dt;
  final String bank_name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 186,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Transaction ID:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(trn_id)
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  'Transaction Date:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat('dd MMM y')
                      .format(DateTime.parse(trn_dt))
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(bank_name)
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
                        TransactionViewModel.viewTransaction(
                            context: context,
                            trnId: trn_id,
                            trnDate: trn_dt,
                            chqNo: chq_no,
                            chqDate: chq_dt,
                            bankName: bank_name);
                      },
                    ),
                    const Text('View')
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_note_outlined),
                      tooltip: 'Edit Transaction',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TransactionEntry(trnId: trn_id);
                        }));
                      },
                    ),
                    const Text('Edit')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
