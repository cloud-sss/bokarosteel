import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/themeModel.dart';

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  State<LoanCalculator> createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final ThemeModel _themeModel = ThemeModel();
  final formKey = GlobalKey<FormState>();
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _prnAmt = TextEditingController();
  final TextEditingController _period = TextEditingController();
  List items = [];
//List<items> items = [];
  var _inttRt = TextEditingController();

  var tdList = [
    {'id': 0, 'name': 'Select One'},
    {'id': 2, 'name': 'Fixed Deposit'},
    {'id': 3, 'name': 'DBS'},
    {'id': 4, 'name': 'RID'},
    {'id': 5, 'name': 'Monthly Income Scheme'},
    {'id': 10, 'name': 'Janata Bikash Bond'},
    {'id': 14, 'name': 'Fixed Investment Deposit Scheme'},
    {'id': 15, 'name': 'Minor Future Investment Deposit Scheme'},
    {'id': 16, 'name': 'MIIS (Monthly Income Investment Scheme)'},
    {'id': 17, 'name': 'Monthly Investment Deposit Scheme'},
  ];
  var intType = [
    {'id': '1', 'name': 'EMI'},
    {'id': '2', 'name': 'REDUCING'},
  ];
  DateTime sysDate = DateTime.now();
  var prnAmt = '', inttRate = '', period = '', emitype = '';
  var _emitype;
  // DateTime? _SelectedDate;
  bool _isVisible = false;
  int resVal = 0;
  String Cttype = 'NSrCt';
  double New_int_rate = 0.00;
  double rate_cal = 0.00;
  double tot_amt = 0.00;
  var data;

  var getRows = '';
  Future calculateLoanEmi(prnAmt, inttRate, period, emitype) async {
    // prnAmt = int.parse(prnAmt);
    // inttRate = int.parse(inttRate);
    // period = int.parse(period);
    // emitype = int.parse(emitype);

    // if (int.parse(emitype.toString()) == 1) {
    //   print('Here');
    //   print((prnAmt * (inttRate / 100) * pow((1 + (inttRate / 100)), period)) /
    //       (pow((1 + (inttRate / 100)), period) - 1));
    // }
    // print(emitype);
    var map = <String, dynamic>{};
    map['prn_amt'] = prnAmt;
    map['intt_rate'] = inttRate;
    map['period'] = period;
    map['intt_type'] = emitype;

    var response =
        await MasterModel.globalApiCall(1, '/loan_emi_calculator', map);
    response = jsonDecode(response.body);

    // print(response);
    if (response['suc'].toString() != '0') {
      data = response['msg'];
      setState(() {
        _isVisible = true;
        // resVal = data;
        if (data.length > 0) {
          items = data;
          _dialogBuilder(context);
        }
      });
    }
    print(response);
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
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: _themeModel.lightPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[50]),
            padding: const EdgeInsets.all(10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                                'Loan Calculator',
                                style: TextStyle(
                                  fontSize: 23,
                                  color: _themeModel.lightIconTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
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
                                  TextFormField(
                                    controller: _period,
                                    enableSuggestions: true,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'No of Installment',
                                        border: OutlineInputBorder()),
                                    validator: (value) {
                                      var validCharacters =
                                          RegExp(r'^[0-9&%=]+$');
                                      if (value!.isEmpty) {
                                        return "Enter No of Installment";
                                      } else if (!validCharacters
                                          .hasMatch(value)) {
                                        return 'Remove Special Characters';
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
                                      isDense: true,
                                      isExpanded: false,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      decoration: InputDecoration(
                                          label: const Text('Interest Type'),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          )),
                                      items: intType.map((e) {
                                        return DropdownMenuItem(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          value: e['id'],
                                          child:
                                              Text(e['name'].toString().trim()),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _emitype = val!;
                                        });
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (_emitype.toString() != 'null') {
                                          await calculateLoanEmi(
                                              _prnAmt.text.toString(),
                                              _inttRt.text.toString(),
                                              _period.text.toString(),
                                              _emitype.toString());
                                        } else {
                                          dialogModel.showToast(
                                              'Please Select Intterest Type');
                                        }
                                      }
                                    },
                                    // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                    style: ElevatedButton.styleFrom(
                                        // backgroundColor: const Color.fromARGB(
                                        //     237, 9, 79, 159),
                                        elevation: 0.0,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        minimumSize: const Size(150, 40)),
                                    child: const Text('Submit',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: true,
      useSafeArea: true,
      // useRootNavigator: true,
      barrierColor: const Color.fromARGB(237, 9, 79, 159),
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.fromLTRB(20.0, 0.0, 25.0, 0.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 40,
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back)),
                      )
                    ],
                  ),
                  const Column(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(''),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 27,
              margin: const EdgeInsets.fromLTRB(25.0, 3.0, 25.0, 0.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 30,
                        padding: const EdgeInsets.all(2),
                        child: const Text('SL'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 90,
                        padding: const EdgeInsets.all(2),
                        child: const Text('Principal'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        padding: const EdgeInsets.all(2),
                        child: const Text('Interest'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 90,
                        padding: const EdgeInsets.all(2),
                        child: const Text('EMI'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 550,
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
              decoration: const BoxDecoration(
                  //  border: Border.all(color: Colors.blueAccent)
                  ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (items.isNotEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Text(items[index]['EMI_NO'].toString()),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 95,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Text(items[index]['EMI_PRN'].toString()),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Text(items[index]['EMI_INTT'].toString()),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 95,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Text(items[index]['TOTAL_EMI'].toString()),
                            )
                          ],
                        )
                      ],
                    );
                  }
                  if (items.length == 0) return const Text('No data found');
                  return null;
                },
              ),
            ),
          ],
        ));
      },
    );
  }
}
