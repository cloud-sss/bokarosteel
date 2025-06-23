// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/member_application/view.dart';
import 'package:bseccs/widgets/separatorWidget.dart';

class MembApplicationEntry extends StatefulWidget {
  MembApplicationEntry({super.key, this.slNo = 0});
  int slNo;

  @override
  State<MembApplicationEntry> createState() => _MembApplicationEntryState();
}

class _MembApplicationEntryState extends State<MembApplicationEntry> {
  final ThemeModel _themeModel = ThemeModel();
  String cust_id = sharedPrefModel.getUserData('cust_id');
  String userName = sharedPrefModel.getUserData('user_name');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController nameUser = TextEditingController();
  TextEditingController coName = TextEditingController();
  TextEditingController permAddr = TextEditingController();
  TextEditingController localAddr = TextEditingController();
  TextEditingController offName = TextEditingController();
  TextEditingController offDesig = TextEditingController();
  TextEditingController issueBy = TextEditingController();
  TextEditingController memoNum = TextEditingController();
  TextEditingController shareNum = TextEditingController();
  TextEditingController nomiName = TextEditingController();
  TextEditingController nomiRel = TextEditingController();
  TextEditingController nomiAge = TextEditingController();
  TextEditingController nomiAddr = TextEditingController();
  TextEditingController monSubPay = TextEditingController();

  DateTime dob = DateTime.now();
  DateTime depEntryDt = DateTime.now();
  DateTime doi = DateTime.now();
  DateTime entryDate = DateTime.now();
  DateTime memoDate = DateTime.now();

  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.slNo > 0) {
      getMembAppliDtls();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    data = '';
  }

  saveMemApplication() async {
    var map = <String, dynamic>{};
    map['memb_id'] = cust_id;
    map['receipt_dt'] = entryDate.toString();
    map['memb_name'] = nameUser.text;
    map['dob'] = dob.toString();
    map['co_name'] = coName.text;
    map['issue_by'] = issueBy.text;
    map['memo_no'] = memoNum.text;
    map['memo_dt'] = memoDate.toString();
    map['tot_share'] = shareNum.text;
    map['nomi_name'] = nomiName.text;
    map['nomi_rel'] = nomiRel.text;
    map['nomi_addr'] = nomiAddr.text;
    map['nomi_age'] = nomiAge.text;
    map['offfice_name'] = offName.text;
    map['designation'] = offDesig.text;
    map['dep_entry_dt'] = depEntryDt.toString();
    map['mon_sub_pay'] = monSubPay.text;
    map['last_inc_dt'] = doi.toString();
    map['per_addr'] = permAddr.text;
    map['loc_addr'] = localAddr.text;
    map['user'] = userName;
    map['sl_no'] = widget.slNo > 0 ? '1' : '0';
    var resDt =
        await MasterModel.globalApiCall(1, '/memb_application_save', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);

    if (resDt['suc'] > 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const MembApplicationView();
      }));
    } else {
      dialogModel.showToast(resDt['msg']);
    }
  }

  getMembAppliDtls() async {
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
          dob = DateTime.parse(data[0]['DOB'].toString());
          doi = DateTime.parse(data[0]['LAST_INC_DT'].toString());
          entryDate = DateTime.parse(data[0]['RECEIPT_DT'].toString());
          memoDate = DateTime.parse(data[0]['MEMO_DT'].toString());
          depEntryDt = DateTime.parse(data[0]['DEP_ENTRY_DT'].toString());
        } catch (e) {
          print(e);
        }
        nameUser.text =
            data[0]['MEM_NAME'] != '' ? data[0]['MEM_NAME'].toString() : '';
        coName.text =
            data[0]['CO_NAME'] != '' ? data[0]['CO_NAME'].toString() : '';
        shareNum.text =
            data[0]['TOT_SHARE'] != '' ? data[0]['TOT_SHARE'].toString() : "";
        permAddr.text =
            data[0]['PER_ADDR'] != '' ? data[0]['PER_ADDR'].toString() : "";
        localAddr.text =
            data[0]['LOCAL_ADDR'] != '' ? data[0]['LOCAL_ADDR'].toString() : '';
        offName.text = data[0]['OFFICE_NAME'] != ''
            ? data[0]['OFFICE_NAME'].toString()
            : '';
        offDesig.text = data[0]['DESIGNATION'] != ''
            ? data[0]['DESIGNATION'].toString()
            : '';
        issueBy.text =
            data[0]['ISSUED_BY'] != '' ? data[0]['ISSUED_BY'].toString() : "";
        memoNum.text =
            data[0]['MEMO_NO'] != '' ? data[0]['MEMO_NO'].toString() : '';
        nomiName.text =
            data[0]['NOMI_NAME'] != '' ? data[0]['NOMI_NAME'].toString() : '';
        nomiRel.text = data[0]['NOMI_RELATION'] != ''
            ? data[0]['NOMI_RELATION'].toString()
            : '';
        nomiAge.text =
            data[0]['NOMI_AGE'] != '' ? data[0]['NOMI_AGE'].toString() : '';
        nomiAddr.text =
            data[0]['NOMI_ADDR'] != '' ? data[0]['NOMI_ADDR'].toString() : "";
        monSubPay.text = data[0]['MON_SUB_PAY'] != ''
            ? data[0]['MON_SUB_PAY'].toString()
            : '';
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
                          'Application for Membership',
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
                      controller: coName,
                      decoration: const InputDecoration(
                          labelText: 'Son/Daughter/Wife Name',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Son/Daughter/Wife Name";
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
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Date of birth',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialValue: dob,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          dob = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: permAddr,
                      enableSuggestions: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      maxLines: 4,
                      minLines: 2,
                      decoration: const InputDecoration(
                          labelText: 'Permanent Address',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Permanent Address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: localAddr,
                      enableSuggestions: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      maxLines: 4,
                      minLines: 2,
                      decoration: const InputDecoration(
                          labelText: 'Local Address',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Local Address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: issueBy,
                      decoration: const InputDecoration(
                          labelText: 'Issued By', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Issued By";
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
                      controller: memoNum,
                      decoration: const InputDecoration(
                          labelText: 'Memo Number',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Memo Number";
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
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Memo Date',
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
                      controller: shareNum,
                      decoration: const InputDecoration(
                          labelText: 'Number of Share',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Number of Share";
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
                      controller: nomiAge,
                      decoration: const InputDecoration(
                          labelText: 'Age', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Nomine age";
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
                      height: 10,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Date of entry in the Dept',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialValue: depEntryDt,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          depEntryDt = value;
                        });
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
                        labelText: 'Date of last increment',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      initialValue: doi,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          doi = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: monSubPay,
                      decoration: const InputDecoration(
                          labelText: 'Monthly substantive pay',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Monthly substantive pay";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await saveMemApplication();
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
