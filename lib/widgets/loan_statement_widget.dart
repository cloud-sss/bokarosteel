// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/themeModel.dart';

class LoanStatementView extends StatefulWidget {
  LoanStatementView(
      {Key? key,
      required this.loanId,
      required this.frmDt,
      required this.toDt,
      required this.bankId})
      : super(key: key);
  String? loanId;
  String? frmDt;
  String? toDt;
  String? bankId;

  @override
  State<LoanStatementView> createState() => _LoanStatementViewState();
}

class _LoanStatementViewState extends State<LoanStatementView> {
  final ThemeModel _themeModel = ThemeModel();
  var data;
  final columns = [
    'Trans Date',
    'Trans Type',
    'Disb Amount',
    'Prn Recov',
    'Intt Recov',
    'Curr Prn',
    'Curr Intt'
  ];
  // final users = widget.data;
  int? sortColumnIndex = 0;
  bool isAccending = false;

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((column) => DataColumn(
            label: Text(column),
            // onSort: onSort,
          ))
      .toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  List<DataRow> getRows(List<dynamic> users) => users.map((item) {
        final cell = [
          DateFormat('d MMM y').format(
              DateTime.parse(item['TRANS_DT']).add(const Duration(days: 1))),
          item['TRANS_TYPE'].toString(),
          item['DISB_AMT'].toString() != 'null'
              ? item['DISB_AMT'].toStringAsFixed(2)
              : 0,
          item['PRN_RECOV'].toString() != 'null'
              ? item['PRN_RECOV'].toStringAsFixed(2)
              : 0,
          item['INTT_RECOV'].toString() != 'null'
              ? item['INTT_RECOV'].toStringAsFixed(2)
              : 0,
          item['CURR_PRN'].toString() != 'null'
              ? item['CURR_PRN'].toStringAsFixed(2)
              : 0,
          item['CURR_INTT'].toString() != 'null'
              ? item['CURR_INTT'].toStringAsFixed(2)
              : 0,
        ];
        return DataRow(cells: getCells(cell));
      }).toList();

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  Future<void> LoanTransDtls() async {
    var map = <String, dynamic>{};
    map['loan_id'] = widget.loanId;
    map['frm_dt'] = widget.frmDt.toString();
    map['to_dt'] = widget.toDt.toString();
    map['bank_id'] = widget.bankId.toString();

    var dt = await MasterModel.globalApiCall(1, '/loan_stmt_download', map);
    dt = jsonDecode(dt.body);

    if (dt['suc'].toString() != '0') {
      data = dt['msg'];
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
            child: Center(
              child: Text(
                'Loan Details for the period of ${DateFormat('d MMM y').format(DateTime.parse(widget.frmDt.toString()))} from ${DateFormat('d MMM y').format(DateTime.parse(widget.toDt.toString()))}',
                style: TextStyle(fontSize: 19, color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: LoanTransDtls(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column();
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DataTable(
                              headingTextStyle: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              // for Heading Text Style
                              dataTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              sortAscending: isAccending,
                              sortColumnIndex: 0,
                              columns: getColumns(columns),
                              rows: getRows(data),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
