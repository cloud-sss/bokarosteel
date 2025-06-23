// ignore_for_file: must_be_immutable

// import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/widgets/loan_statement_widget.dart';

class StatementDtls extends StatefulWidget {
  StatementDtls(
      {Key? key,
      required this.loanId,
      required this.acctype,
      required this.accNum,
      required this.prinAmt,
      required this.intAmt,
      required this.bankId})
      : super(key: key);
  String? loanId;
  String? acctype;
  String? accNum;
  String? prinAmt;
  String? intAmt;
  String? bankId;

  @override
  State<StatementDtls> createState() => _StatementDtlsState();
}

class _StatementDtlsState extends State<StatementDtls> {
  DateTime? selectedDate;
  String bankName = sharedPrefModel.getUserData('bank_name');
  String userName = sharedPrefModel.getUserData('user_name');
  DateTime _frmDt = DateTime.now();
  DateTime? _todt;
  int currYear = MasterModel.getFinDt();

  var yearList = [
    {'id': 0, 'name': 'Select One'},
    {'id': 90, 'name': '3 Months'},
    {'id': 180, 'name': '6 Months'},
    {'id': 365, 'name': '1 Year'},
  ];
  var totYear;

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
              style: TextStyle(
                  fontSize: 25, color: Colors.black, letterSpacing: 1),
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
                  value: e['id'],
                  child: Text(e['name'].toString()),
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

          // DateTimeFormField(
          //   decoration: const InputDecoration(
          //     hintStyle: TextStyle(color: Colors.black45),
          //     errorStyle: TextStyle(color: Colors.redAccent),
          //     border: OutlineInputBorder(),
          //     suffixIcon: Icon(Icons.event_note),
          //     labelText: 'From Date',
          //   ),
          //   mode: DateTimeFieldPickerMode.date,
          //   firstDate: DateTime.parse('$currYear-04-01'),
          //   lastDate: DateTime.now(),
          //   initialDate: DateTime.now(),
          //   // autovalidateMode: AutovalidateMode.always,
          //   validator: (DateTime? e) =>
          //       (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
          //   onDateSelected: (DateTime value) {
          //     setState(() {
          //       _frmDt = value;
          //     });
          //   },
          // ),
          // const SizedBox(
          //   height: 30,
          // ),
          // DateTimeFormField(
          //   decoration: const InputDecoration(
          //     hintStyle: TextStyle(color: Colors.black45),
          //     errorStyle: TextStyle(color: Colors.redAccent),
          //     border: OutlineInputBorder(),
          //     suffixIcon: Icon(Icons.event_note),
          //     labelText: 'To Date',
          //   ),
          //   mode: DateTimeFieldPickerMode.date,
          //   firstDate: _frmDt,
          //   lastDate:
          //       DateTime.parse(_frmDt.toString()).add(const Duration(days: 90)),
          //   // initialDate: DateTime.now(),
          //   autovalidateMode: AutovalidateMode.always,
          //   validator: (DateTime? e) =>
          //       (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
          //   onDateSelected: (DateTime value) {
          //     setState(() {
          //       _todt = value;
          //     });
          //   },
          // ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_todt != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => LoanStatementView(
                            loanId: widget.loanId.toString(),
                            frmDt: _frmDt.toString(),
                            toDt: _todt!.toString(),
                            bankId: widget.bankId,
                          )),
                );
                // var dt = await LoanApi.loanTnsPdfData(
                //     widget.loanId.toString(), _frmDt.toString(), _todt!.toString());
                // if (dt['suc'].toString() != '0') {
                //   // final pdfFile = await PdfGenerator.generate(
                //   //     dt['msg'],
                //   //     widget.acctype,
                //   //     widget.accNum,
                //   //     widget.prinAmt,
                //   //     widget.intAmt,
                //   //     userName.toString(),
                //   //     _frmDt,
                //   //     _todt);

                //   // PdfApi.openFile(pdfFile);
                // }
                // print(dt['suc']);
              } else {
                dialogModel.showToast("Please select date");
              }
            },
            // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
            style: ElevatedButton.styleFrom(
                // backgroundColor: MainApp.textColor,
                elevation: 12.0,
                textStyle: const TextStyle(color: Colors.white),
                minimumSize: const Size(150, 40)),
            child: const Text('View'),
          )
        ],
      ),
    );
  }
}
