// ignore_for_file: must_be_immutable, use_build_context_synchronously, unused_field

import 'dart:convert';

// import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/widgets/deposit_statement_widget.dart';

class StatementDtls extends StatefulWidget {
  StatementDtls(
      {Key? key,
      required this.acctype,
      required this.acctypeID,
      required this.accNum,
      required this.currAmt,
      required this.bankId,
      required this.ac_flag})
      : super(key: key);
  String? acctype;
  String? acctypeID;
  String? accNum;
  String? currAmt;
  String? bankId;
  String? ac_flag;

  @override
  State<StatementDtls> createState() => _StatementDtlsState();
}

class _StatementDtlsState extends State<StatementDtls> {
  final ThemeModel _themeModel = ThemeModel();
  DateTime? selectedDate;
  String userName = sharedPrefModel.getUserData('user_name');
  String bankName = sharedPrefModel.getUserData('bank_name');
  DateTime _frmDt = DateTime.now();
  DateTime? _todt;
  String custId = sharedPrefModel.getUserData('cust_id');
  int currYear = MasterModel.getFinDt();
  var totYear;

  var yearList = [
    {'id': 0, 'name': 'Select One'},
    {'id': 90, 'name': '3 Months'},
    {'id': 180, 'name': '6 Months'},
    {'id': 365, 'name': '1 Year'},
  ];

  Future depositAccDtls() async {
    var map = <String, dynamic>{};
    map['acc_num'] = widget.accNum;
    map['acc_type'] = widget.acctypeID;
    map['bank_id'] = widget.bankId;
    final response =
        await MasterModel.globalApiCall(1, '/deposit_acc_dtls', map);
    var dt = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = dt['msg'];
      return data;
    }
  }

  Future dailyDepositDtls(frmDt, toDt) async {
    var map = <String, dynamic>{};
    map['acc_num'] = widget.accNum;
    map['frm_dt'] = frmDt.toString();
    map['to_dt'] = toDt.toString();
    map['bank_id'] = widget.bankId.toString();
    final response =
        await MasterModel.globalApiCall(1, '/daily_deposit_download', map);
    var dt = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = dt['msg'];
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'View Statement',
              style: TextStyle(fontSize: 25, letterSpacing: 1),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          DropdownButtonFormField(
              isDense: true,
              decoration: const InputDecoration(
                  label: Text('Select Period'), border: OutlineInputBorder()),
              items: yearList.map((e) {
                return DropdownMenuItem(
                  child: Text(e['name'].toString()),
                  value: e['id'],
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  totYear = val;
                  _todt = DateTime.now();
                  _frmDt = DateTime.parse(DateTime.now().toString())
                      .subtract(Duration(days: int.parse(val.toString())));
                });
              }),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_todt != null) {
                if (widget.acctypeID == '2' ||
                    widget.acctypeID == '3' ||
                    widget.acctypeID == '4' ||
                    widget.acctypeID == '5' ||
                    //widget.acctypeID == '10' ||
                    // widget.acctypeID == '14' ||
                    widget.acctypeID == '15' ||
                    widget.acctypeID == '16' ||
                    widget.acctypeID == '17') {
                  var dt = await depositAccDtls();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => generateDemandAccType(
                      accNum: widget.accNum,
                      accType: widget.acctype,
                      acctypeID: widget.acctypeID,
                      currAmt: widget.currAmt,
                      custId: custId,
                      data: dt,
                      frmDt: _frmDt.toString(),
                      toDt: _todt.toString(),
                      userName: userName.toString(),
                      bankName: bankName,
                    ),
                  ));
                }
                // else if (widget.acctypeID == '11') {
                //   var dt = await dailyDepositDtls(_frmDt, _todt!);

                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => generateDailyDeposit(
                //       accNum: widget.accNum,
                //       accType: widget.acctype,
                //       acctypeID: widget.acctypeID,
                //       currAmt: widget.currAmt,
                //       custId: custId,
                //       data: dt,
                //       frmDt: _frmDt.toString(),
                //       toDt: _todt.toString(),
                //       userName: userName.toString(),
                //       bankName: bankName,
                //     ),
                //   ));
                // }
                else {
                  var map = <String, dynamic>{};
                  map['acc_num'] = widget.accNum.toString();
                  map['acc_type'] = widget.acctypeID.toString();
                  map['frm_dt'] = _frmDt.toString();
                  map['to_dt'] = _todt!.toString();
                  map['bank_id'] = widget.bankId;
                  map['ac_flag'] = widget.ac_flag;
                  map['cust_cd'] = custId;
                  var dt = await MasterModel.globalApiCall(
                      1, '/deposit_download_stmt', map);
                  dt = jsonDecode(dt.body);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => generateDemand(
                      accNum: widget.accNum,
                      accType: widget.acctype,
                      acctypeID: widget.acctypeID,
                      currAmt: widget.currAmt,
                      custId: custId,
                      data: dt,
                      frmDt: _frmDt.toString(),
                      toDt: _todt.toString(),
                      userName: userName.toString(),
                      bankName: bankName,
                    ),
                  ));
                }
              } else {
                dialogModel.showToast("Please select date");
              }
            },
            style: ElevatedButton.styleFrom(
                elevation: 12.0,
                textStyle: const TextStyle(color: Colors.white),
                minimumSize: const Size(150, 40)),
            child: const Text('View'),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Text(
          //   '* You can view maximum 6 months transactions',
          //   style: TextStyle(color: Colors.red, fontSize: 13),
          // )
        ],
      ),
    );
  }
}
