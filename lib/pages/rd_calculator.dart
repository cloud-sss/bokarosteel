// ignore_for_file: unused_field, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';

class RDCalculator extends StatefulWidget {
  const RDCalculator({super.key});

  @override
  State<RDCalculator> createState() => _RDCalculatorState();
}

class _RDCalculatorState extends State<RDCalculator> {
  final ThemeModel _themeModel = ThemeModel();

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _instlAmt = TextEditingController();
  final TextEditingController _period = TextEditingController();
  final TextEditingController _inttRt = TextEditingController();
  var bankId;

  DateTime sysDate = DateTime.now();
  bool _isVisible = false;
  int resVal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bankId = sharedPrefModel.getUserData('bank_id');
  }

  Future calculateRD(instAmt, period, inttRate) async {
    var map = <String, dynamic>{};
    map['instl_amt'] = instAmt;
    map['period'] = period;
    map['inst_rate'] = inttRate;
    map['bank_id'] = bankId;
    var response =
        await MasterModel.globalApiCall(1, '/rd_emi_calculator', map);
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
                            'RD Calculator',
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
                              TextFormField(
                                controller: _instlAmt,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Installment Amount',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  // orgName = value;
                                  if (value!.isEmpty) {
                                    return "Enter Installment Amount";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _period,
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Installment No',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  var validCharacters = RegExp(r'^[0-9&%=]+$');
                                  if (value!.isEmpty) {
                                    return "Enter Installment No";
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
                                    await calculateRD(
                                        _instlAmt.text.toString(),
                                        _period.text.toString(),
                                        _inttRt.text.toString());
                                  }
                                },
                                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _themeModel.lightPrimaryColor,
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
                                  child: Text(
                                    'Interest',
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: _themeModel.lightIconTextColor,
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
