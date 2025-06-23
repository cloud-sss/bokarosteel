// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:bseccs/pages/transaction/view.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';

class TransactionEntry extends StatefulWidget {
  TransactionEntry({super.key, required this.trnId});
  String trnId;

  @override
  State<TransactionEntry> createState() => _TransactionEntryState();
}

class _TransactionEntryState extends State<TransactionEntry> {
  final ThemeModel _themeModel = ThemeModel();
  String cust_id = sharedPrefModel.getUserData('cust_id');
  String userName = sharedPrefModel.getUserData('user_name');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController trnsID = TextEditingController();
  TextEditingController trnsAmt = TextEditingController();
  TextEditingController cheqNo = TextEditingController();
  TextEditingController bankName = TextEditingController();

  DateTime trnsDate = DateTime.now();
  DateTime cheqDate = DateTime.now();
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.trnId != '') {
      getTransactionDetails();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    data = '';
  }

  getTransactionDetails() async {
    var map = <String, dynamic>{};
    map['trns_id'] = widget.trnId;
    map['cust_id'] = cust_id;
    var resDt = await MasterModel.globalApiCall(1, '/transaction_upload', map);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      data = resDt['msg'];
      setState(() {
        try {
          trnsDate = DateTime.parse(data[0]['TRNS_DT'].toString());
          cheqDate = DateTime.parse(data[0]['CHQ_DT'].toString());
        } catch (e) {
          print(e);
        }
        trnsID.text =
            data[0]['TRNS_ID'] != '' ? data[0]['TRNS_ID'].toString() : '';
        cheqNo.text =
            data[0]['CHQ_NO'] != '' ? data[0]['CHQ_NO'].toString() : '';
        trnsAmt.text =
            data[0]['TRNS_AMT'] != '' ? data[0]['TRNS_AMT'].toString() : "0";
        bankName.text =
            data[0]['BANK_NAME'] != '' ? data[0]['BANK_NAME'].toString() : '';
      });
    }
  }

  transactionSubmit(BuildContext context) async {
    var map = <String, dynamic>{};
    map['trns_id'] = trnsID.text;
    map['trns_dt'] = trnsDate.toString();
    map['trns_amt'] = trnsAmt.text;
    map['chq_no'] = cheqNo.text;
    map['chq_dt'] = cheqDate.toString();
    map['bank_name'] = bankName.text;
    map['cust_id'] = cust_id;
    map['user'] = userName;
    print(widget.trnId);

    map['id'] = widget.trnId != '' ? '1' : '0';
    //map['id'] = int.parse(widget.trnId) > 0 && widget.trnId != '' ? '1' : '0';
    var resDt =
        await MasterModel.globalApiCall(1, '/transaction_upload_save', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    //Navigator.pop(context, resDt['msg']);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionView()),
    ); // showConfirmAlertDialog(context).then((value) {
    //   if (value == true) {
    //     if (resDt['suc'] > 0) {
    //       // Navigator.pop(context, true);
    //       Navigator.pop(context, resDt['msg']);
    //     } else {
    //       // Navigator.pop(context, false);
    //       Navigator.pop(context, resDt['msg']);
    //     }
    //   } else {
    //     Navigator.pop(context, false);
    //   }
    // });
  }

  showConfirmAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = OutlinedButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = OutlinedButton(
      child: const Text("Continue"),
      onPressed: () => Navigator.pop(context, true),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.amber.shade400,
        size: 60,
      ),
      title: const Text("Alert!"),
      content: const Text(
        "This transaction ID is already exist. Do you want to update?",
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      //print(value);
    }).onError((error, stackTrace) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 5, // Space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: _themeModel.lightPrimaryColor,
                          width: 3.0, // Underline thickness
                        ))),
                        child: const Text(
                          'Upload Transaction Details',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Transaction Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialValue: trnsDate,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          trnsDate = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: trnsID,
                      decoration: const InputDecoration(
                          labelText: 'Transaction ID',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Transaction ID";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: trnsAmt,
                      decoration: const InputDecoration(
                          labelText: 'Amount', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Amount";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: cheqNo,
                      decoration: const InputDecoration(
                          labelText: 'Cheque No.',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Cheque No.";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Cheque Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialValue: cheqDate,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          cheqDate = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: bankName,
                      decoration: const InputDecoration(
                          labelText: 'Bank Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Bank Name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await transactionSubmit(context);
                            // await FeedbackApi.submitFeedBack(
                            //     value.toString(),
                            //     _remarks.text.toString(),
                            //     userName);
                          }
                        },
                        // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                        style: ElevatedButton.styleFrom(
                          // backgroundColor:
                          //     const Color.fromARGB(237, 9, 79, 159),
                          elevation: 0.0,
                          textStyle: const TextStyle(color: Colors.white),
                          // minimumSize: const Size(150, 40),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
