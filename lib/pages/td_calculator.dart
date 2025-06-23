// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';

class TDCalculator extends StatefulWidget {
  const TDCalculator({super.key});

  @override
  State<TDCalculator> createState() => _TDCalculatorState();
}

class _TDCalculatorState extends State<TDCalculator> {
  final ThemeModel _themeModel = ThemeModel();

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _prnAmt = TextEditingController();
  final TextEditingController _period = TextEditingController();
  final TextEditingController _inttRt = TextEditingController();
  var bankId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bankId = sharedPrefModel.getUserData('bank_id');
  }

  var tdList = [
    {'id': 0, 'name': 'Select One'},
    // {'id': 2, 'name': 'Fixed Deposit Old'},
    {'id': 2, 'name': 'Fixed Deposit'},
    {'id': 3, 'name': 'DBS'},
    {'id': 4, 'name': 'Reinvestment/Term Deposit'},
    {'id': 5, 'name': 'Monthly Income Scheme'},
    // {'id': 6, 'name': 'Recurring Deposit'},
    // {'id': 10, 'name': 'Janata Bikash Bond'},
  ];
  var intType = [
    {'id': 'O', 'name': 'On Maturity'},
    {'id': 'M', 'name': 'Monthly'},
    {'id': 'Q', 'name': 'Quaterly'},
    {'id': 'H', 'name': 'Half Yearly'},
    {'id': 'Y', 'name': 'Yearly'},
  ];
  DateTime sysDate = DateTime.now();
  var _accType;
  var _inttType;
  DateTime? _SelectedDate;
  int? _periodDays;
  bool _isVisible = false;
  int resVal = 0;

  Future calculateTD(accType, prnAmt, inttType, period, inttRate) async {
    var map = <String, dynamic>{};
    map['acc_type'] = accType;
    map['prn_amt'] = prnAmt;
    map['sys_dt'] = sysDate.toString();
    map['intt_type'] = inttType.toString();
    map['period'] = period;
    map['intt_rate'] = inttRate;
    map['bank_id'] = bankId;
    var response =
        await MasterModel.globalApiCall(1, '/td_emi_calculator', map);
    response = jsonDecode(response.body);
    // print(response['msg']);
    if (response['suc'].toString() != '0') {
      setState(() {
        _isVisible = true;
        resVal = int.parse(response['msg']['RES'].toString());
      });
    }
    // print(response);
  }

  @override
  void dispose() {
    _prnAmt.dispose();
    _period.dispose();
    _inttRt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[50]),
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: 233,
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
                          child: Text(
                            'TD Calculator',
                            style: TextStyle(
                              fontSize: 23,
                              color: _themeModel.lightIconTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              DropdownButtonFormField(
                                  isDense: true,
                                  // value: _accType,
                                  decoration: const InputDecoration(
                                    label: Text('A/C Type'),
                                    // border: OutlineInputBorder(
                                    //     borderRadius: BorderRadius.all(
                                    //         Radius.circular(4.0)),
                                    //     gapPadding: 0.0),
                                  ),
                                  items: tdList.map((e) {
                                    return DropdownMenuItem(
                                      value: e['id'],
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    // print(val);
                                    // orgName = _orgName.text;
                                    setState(() {
                                      _accType = val.toString();
                                    });
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _prnAmt,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Principal Amount',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  // orgName = value;
                                  if (value!.isEmpty) {
                                    return "Enter Principal Amount";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                  // value: distId,
                                  decoration: const InputDecoration(
                                      label: Text('Interest Type'),
                                      border: OutlineInputBorder()),
                                  items: intType.map((e) {
                                    return DropdownMenuItem(
                                      value: e['id'],
                                      child: Text(e['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _inttType = val!;
                                    });
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _period,
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Period (in months)',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  var validCharacters = RegExp(r'^[0-9&%=]+$');
                                  if (value!.isEmpty) {
                                    return "Enter Period in Months";
                                  } else if (!validCharacters.hasMatch(value)) {
                                    return 'Remove Special Characters';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _inttRt,
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Interest Rate',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  // orgName = value;
                                  if (value!.isEmpty) {
                                    return "Enter Interest Rate";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (_accType.toString() != 'null') {
                                      if (_inttType.toString() != 'null') {
                                        _SelectedDate = DateTime(
                                            sysDate.year,
                                            int.parse(
                                                    sysDate.month.toString()) +
                                                int.parse(_period.text),
                                            sysDate.day);
                                        _periodDays = int.parse(_SelectedDate!
                                            .difference(sysDate)
                                            .inDays
                                            .toString());
                                        await calculateTD(
                                            _accType.toString(),
                                            _prnAmt.text.toString(),
                                            _inttType.toString(),
                                            _periodDays.toString(),
                                            _inttRt.text.toString());
                                      } else {
                                        dialogModel.showToast(
                                            'Please Select Intterest Type');
                                      }
                                    } else {
                                      dialogModel
                                          .showToast('Please Select A/C Type');
                                    }
                                  }
                                },
                                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                style: ElevatedButton.styleFrom(
                                    // backgroundColor: MainApp.primaryColor,
                                    elevation: 0.0,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    minimumSize: const Size(150, 40)),
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    bottom:
                                        5, // Space between underline and text
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: _themeModel.lightPrimaryColor,
                                    width: 3.0, // Underline thickness
                                  ))),
                                  child: const Text(
                                    'Interest',
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {},
                                icon: Icon(
                                  Icons.share_rounded,
                                  color: _themeModel.lightIconColor,
                                ),
                              ),
                              // Icon(Icons.share_rounded),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee_outlined,
                                  size: 20,
                                ),
                                Text(
                                  resVal.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
