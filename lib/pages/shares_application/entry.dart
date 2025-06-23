// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_build_context_synchronously, avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/shares_application/view.dart';
import 'package:bseccs/widgets/separatorWidget.dart';

class StockApplicationEntry extends StatefulWidget {
  StockApplicationEntry({super.key, this.slNo = 0});
  int slNo;

  @override
  State<StockApplicationEntry> createState() => _StockApplicationEntryState();
}

class _StockApplicationEntryState extends State<StockApplicationEntry> {
  final ThemeModel _themeModel = ThemeModel();
  String cust_id = sharedPrefModel.getUserData('cust_id');
  String userName = sharedPrefModel.getUserData('user_name');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController nameUser = TextEditingController();
  TextEditingController memberNumber = TextEditingController();
  TextEditingController shareNum = TextEditingController();
  TextEditingController allotShareNum = TextEditingController();
  TextEditingController nomiName = TextEditingController();
  TextEditingController nomiRel = TextEditingController();
  TextEditingController nomiAddr = TextEditingController();
  TextEditingController offName = TextEditingController();
  TextEditingController offDesig = TextEditingController();

  DateTime entryDate = DateTime.now();

  var data;

  @override
  void initState() {
    super.initState();
    getMemberDtls();
    if (widget.slNo > 0) {
      getStockApplicationDtls();
    }
  }

  @override
  void dispose() {
    super.dispose();
    data = '';
  }

  saveStockApplication() async {
    var map = <String, dynamic>{};
    map['memb_id'] = cust_id;
    map['receipt_dt'] = entryDate.toString();
    map['memb_name'] = nameUser.text;
    map['tot_share_hold'] = shareNum.text;
    map['tot_share_allot'] = allotShareNum.text;
    map['membership_no'] = memberNumber.text;
    map['nomi_name'] = nomiName.text;
    map['nomi_rel'] = nomiRel.text;
    map['nomi_addr'] = nomiAddr.text;
    map['offfice_name'] = offName.text;
    map['designation'] = offDesig.text;
    map['user'] = userName;
    map['sl_no'] = widget.slNo > 0 ? '1' : '0';
    var resDt =
        await MasterModel.globalApiCall(1, '/add_share_application_save', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);

    if (resDt['suc'] > 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const StockApplicationView();
      }));
    } else {
      dialogModel.showToast(resDt['msg']);
    }
  }

  getMemberDtls() async {
    var map = <String, dynamic>{};
    map['memb_id'] = cust_id;
    var resDt = await MasterModel.globalApiCall(1, '/get_memb_dtls', map);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      var dt = resDt['msg'];
      setState(() {
        nameUser.text =
            dt['MEMBER_NAME'] != '' ? dt['MEMBER_NAME'].toString() : '';
        offDesig.text =
            dt['DESIGNATION'] != '' ? dt['DESIGNATION'].toString() : '';
        nomiName.text =
            dt['GUARDIAN_NAME'] != '' ? dt['GUARDIAN_NAME'].toString() : '';
        nomiAddr.text = dt['ADDRESS'] != '' ? dt['ADDRESS'].toString() : "";
      });
    }
  }

  getStockApplicationDtls() async {
    var map = <String, dynamic>{};
    map['sl_no'] = widget.slNo.toString();
    map['member_id'] = cust_id;
    var resDt =
        await MasterModel.globalApiCall(1, '/get_memb_application', map);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      data = resDt['msg'];
      setState(() {
        try {
          entryDate = DateTime.parse(data[0]['RECEIPT_DT'].toString());
        } catch (e) {
          print(e);
        }
        nameUser.text =
            data[0]['MEM_NAME'] != '' ? data[0]['MEM_NAME'].toString() : '';
        shareNum.text =
            data[0]['TOT_SHARE'] != '' ? data[0]['TOT_SHARE'].toString() : "";
        offName.text = data[0]['OFFICE_NAME'] != ''
            ? data[0]['OFFICE_NAME'].toString()
            : '';
        offDesig.text = data[0]['DESIGNATION'] != ''
            ? data[0]['DESIGNATION'].toString()
            : '';
        nomiName.text =
            data[0]['NOMI_NAME'] != '' ? data[0]['NOMI_NAME'].toString() : '';
        nomiRel.text = data[0]['NOMI_RELATION'] != ''
            ? data[0]['NOMI_RELATION'].toString()
            : '';
        nomiAddr.text =
            data[0]['NOMI_ADDR'] != '' ? data[0]['NOMI_ADDR'].toString() : "";
      });
    }
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
                          'Application for Additional Shares',
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
                    const SeperatorWidget(color: Colors.grey),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Applicant Details',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SeperatorWidget(color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialValue: entryDate,
                      enabled: false,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          entryDate = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameUser,
                      decoration: const InputDecoration(
                          labelText: 'Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Name";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: memberNumber,
                      decoration: const InputDecoration(
                          labelText: 'Membership Number',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Membership Number";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: shareNum,
                      decoration: const InputDecoration(
                          labelText: 'Number of Share Holds',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Number of Share Holds";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: allotShareNum,
                      decoration: const InputDecoration(
                          labelText: 'Allot Share',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Allot Share";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SeperatorWidget(color: Colors.grey),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Nomine Details',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SeperatorWidget(color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nomiName,
                      decoration: const InputDecoration(
                          labelText: 'Nomine Name',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Nomine Name";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nomiRel,
                      decoration: const InputDecoration(
                          labelText: 'Relation', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Nomine relation";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nomiAddr,
                      enableSuggestions: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      maxLines: 4,
                      minLines: 2,
                      decoration: const InputDecoration(
                          labelText: 'Nomine Address',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Nomine Address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SeperatorWidget(color: Colors.grey),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Particulars of Applicant',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SeperatorWidget(color: Colors.grey),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: offName,
                      decoration: const InputDecoration(
                          labelText: 'Office in which employed',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Office in which employed";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: offDesig,
                      decoration: const InputDecoration(
                          labelText: 'Official designation',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Official designation";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await saveStockApplication();
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
